unit simpleupxwizardcode;

{
 This software was made by Popov Evgeniy Alekseyevich.
 It is distributed under the GNU GENERAL PUBLIC LICENSE (Version 2 or higher).
}

{$mode objfpc}
{$H+}

interface

uses Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls, StdCtrls;

type

  { TMainWindow }

  TMainWindow = class(TForm)
    OpenCompressedButton: TButton;
    CompressButton: TButton;
    OpenDecompressedButton: TButton;
    DecompressButton: TButton;
    ExportCheckBox: TCheckBox;
    ResourcesCheckBox: TCheckBox;
    IconsCheckBox: TCheckBox;
    RelocationCheckBox: TCheckBox;
    BackupCheckBox: TCheckBox;
    ForceCheckBox: TCheckBox;
    RatioPanel: TLabel;
    CompressionField: TLabeledEdit;
    DecompressionField: TLabeledEdit;
    OpenDialog: TOpenDialog;
    WorkSpace: TPageControl;
    CompressSheet: TTabSheet;
    DecompressSheet: TTabSheet;
    RatioBar: TTrackBar;
    procedure OpenCompressedButtonClick(Sender: TObject);
    procedure CompressButtonClick(Sender: TObject);
    procedure OpenDecompressedButtonClick(Sender: TObject);
    procedure DecompressButtonClick(Sender: TObject);
    procedure RelocationCheckBoxClick(Sender: TObject);
    procedure ForceCheckBoxClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CompressionFieldChange(Sender: TObject);
    procedure DecompressionFieldChange(Sender: TObject);
  private
    function get_option():string;
    procedure compress_file(const target:string);
    procedure window_setup();
    procedure dialog_setup();
    procedure interface_setup();
    procedure language_setup();
    procedure setup();
  public
    { public declarations }
  end;

var MainWindow: TMainWindow;

implementation

{$R *.lfm}

function get_backend():string;
begin
 Result:=ExtractFilePath(Application.ExeName)+'upx.exe';
end;

function convert_file_name(const source:string): string;
var target:string;
begin
 target:=source;
 if Pos(' ',source)>0 then
 begin
  target:='"'+source+'"';
 end;
 Result:=target;
end;

function execute_program(const executable:string;const argument:string):Integer;
var code:Integer;
begin
 try
  code:=ExecuteProcess(executable,argument,[]);
 except
  code:=-1;
 end;
 Result:=code;
end;

procedure decompress_file(const target:string);
var option:string;
begin
 option:='-d '+convert_file_name(target);
 if execute_program(get_backend(),option)<>0 then
 begin
  ShowMessage('Cannot decompress the target file');
 end;

end;

function TMainWindow.get_option():string;
var option:string;
var ratio:array[0..11] of string=('-1 ','-2 ','-3 ','-4 ','-5 ','-6 ','-7 ','-8 ','-9 ','--best ','--brute ','--ultra-brute ');
begin
 option:=ratio[Self.RatioBar.Position];
 if Self.ExportCheckBox.Checked=True then option:=option+'--compress-export=0 ';
 if Self.ResourcesCheckBox.Checked=True then option:=option+'--compress-resources=0 ';
 if Self.IconsCheckBox.Checked=True then option:=option+'--compress-icons=0 ';
 if Self.RelocationCheckBox.Checked=True then option:=option+'--strip-relocs=0 ';
 if Self.BackupCheckBox.Checked=True then option:=option+'--backup ';
 if Self.ForceCheckBox.Checked=True then option:=option+'-f ';
 Result:=option;
end;

procedure TMainWindow.compress_file(const target:string);
var option:string;
begin
 option:=Self.get_option()+convert_file_name(target);
 if execute_program(get_backend(),option)<>0 then
 begin
  ShowMessage('Cannot compress the target file');
 end;

end;

procedure TMainWindow.window_setup();
begin
 Application.Title:='Simple upx wizard';
 Self.Caption:='Simple upx wizard 0.9.8';
 Self.BorderStyle:=bsDialog;
 Self.Font.Name:=Screen.MenuFont.Name;
 Self.Font.Size:=14;
end;

procedure TMainWindow.dialog_setup();
begin
 Self.OpenDialog.InitialDir:='';
 Self.OpenDialog.FileName:='*.exe';
 Self.OpenDialog.DefaultExt:='*.exe';
 Self.OpenDialog.Filter:='Executable files|*.exe';
end;

procedure TMainWindow.interface_setup();
begin
 Self.CompressButton.Enabled:=False;
 Self.DecompressButton.Enabled:=False;
 Self.ExportCheckBox.Checked:=False;
 Self.ResourcesCheckBox.Checked:=False;
 Self.IconsCheckBox.Checked:=False;
 Self.RelocationCheckBox.Checked:=True;
 Self.BackupCheckBox.Checked:=False;
 Self.ForceCheckBox.Checked:=False;
 Self.CompressionField.Enabled:=False;
 Self.DecompressionField.Enabled:=False;
 Self.CompressionField.LabelPosition:=lpLeft;
 Self.DecompressionField.LabelPosition:=lpLeft;
 Self.CompressionField.Text:='';
 Self.DecompressionField.Text:='';
 Self.RatioBar.Orientation:=trHorizontal;
 Self.RatioBar.TickStyle:=tsAuto;
 Self.RatioBar.Min:=0;
 Self.RatioBar.Max:=11;
 Self.RatioBar.Position:=9;
 Self.WorkSpace.ActivePageIndex:=0;
end;

procedure TMainWindow.language_setup();
begin
 Self.CompressionField.EditLabel.Caption:='Target file';
 Self.DecompressionField.EditLabel.Caption:='Target file';
 Self.OpenCompressedButton.Caption:='Open';
 Self.CompressButton.Caption:='Compress';
 Self.OpenDecompressedButton.Caption:='Open';
 Self.DecompressButton.Caption:='Decompress';
 Self.OpenDialog.Title:='Open an executable file';
 Self.WorkSpace.Pages[0].Caption:='Compression';
 Self.WorkSpace.Pages[1].Caption:='Decompression';
 Self.ExportCheckBox.Caption:='Do not compress the export section';
 Self.ResourcesCheckBox.Caption:='Do not compress the resources';
 Self.IconsCheckBox.Caption:='Do not compress the icons';
 Self.RelocationCheckBox.Caption:='Do not strip the relocations';
 Self.BackupCheckBox.Caption:='Create a backup';
 Self.ForceCheckBox.Caption:='Force compression';
 Self.RatioPanel.Caption:='Compress ratio';
end;

procedure TMainWindow.setup();
begin
 Self.window_setup();
 Self.dialog_setup();
 Self.interface_setup();
 Self.language_setup();
end;

{ TMainWindow }

procedure TMainWindow.FormCreate(Sender: TObject);
begin
 Self.setup();
end;

procedure TMainWindow.CompressionFieldChange(Sender: TObject);
begin
 Self.CompressButton.Enabled:=Self.CompressionField.Text<>'';
end;

procedure TMainWindow.DecompressionFieldChange(Sender: TObject);
begin
 Self.DecompressButton.Enabled:=Self.DecompressionField.Text<>'';
end;

procedure TMainWindow.OpenCompressedButtonClick(Sender: TObject);
begin
 if Self.OpenDialog.Execute()=True then
 begin
  Self.CompressionField.Text:=Self.OpenDialog.FileName;
 end;

end;

procedure TMainWindow.CompressButtonClick(Sender: TObject);
begin
 Self.compress_file(Self.CompressionField.Text);
end;

procedure TMainWindow.OpenDecompressedButtonClick(Sender: TObject);
begin
 if Self.OpenDialog.Execute()=True then
 begin
  Self.DecompressionField.Text:=Self.OpenDialog.FileName;
 end;

end;

procedure TMainWindow.DecompressButtonClick(Sender: TObject);
begin
 decompress_file(Self.DecompressionField.Text);
end;

procedure TMainWindow.RelocationCheckBoxClick(Sender: TObject);
begin
 if Self.RelocationCheckBox.Checked=False then
 begin
  Self.BackupCheckBox.Checked:=True;
 end;

end;

procedure TMainWindow.ForceCheckBoxClick(Sender: TObject);
begin
 if Self.ForceCheckBox.Checked=True then
 begin
  Self.BackupCheckBox.Checked:=True;
 end;

end;

end.
