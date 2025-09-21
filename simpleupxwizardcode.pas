unit simpleupxwizardcode;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, StdCtrls;

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

  public

  end;

var MainWindow: TMainWindow;

implementation

{$R *.lfm}

procedure window_setup();
begin
 Application.Title:='Simple upx wizard';
 MainWindow.Caption:='Simple upx wizard 0.9.1';
 MainWindow.BorderStyle:=bsDialog;
 MainWindow.Font.Name:=Screen.MenuFont.Name;
 MainWindow.Font.Size:=14;
end;

procedure dialog_setup();
begin
 MainWindow.OpenDialog.InitialDir:='';
 MainWindow.OpenDialog.FileName:='*.exe';
 MainWindow.OpenDialog.DefaultExt:='*.exe';
 MainWindow.OpenDialog.Filter:='Executable files|*.exe';
end;

function convert_file_name(const source:string): string;
var target:string;
begin
 target:=source;
 if Pos(' ',source)>0 then
 begin
  target:='"'+source+'"';
 end;
 convert_file_name:=target;
end;

function execute_program(const executable:string;const argument:string):Integer;
var code:Integer;
begin
 try
  code:=ExecuteProcess(executable,argument,[]);
 except
  code:=-1;
 end;
 execute_program:=code;
end;

function get_option():string;
var option:string;
var ratio:array[0..11] of string=('-1 ','-2 ','-3 ','-4 ','-5 ','-6 ','-7 ','-8 ','-9 ','--best ','--brute ','--ultra-brute ');
begin
 option:=ratio[MainWindow.RatioBar.Position];
 if MainWindow.ExportCheckBox.Checked=True then option:=option+'--compress-export=0 ';
 if MainWindow.ResourcesCheckBox.Checked=True then option:=option+'--compress-resources=0 ';
 if MainWindow.IconsCheckBox.Checked=True then option:=option+'--compress-icons=0 ';
 if MainWindow.RelocationCheckBox.Checked=True then option:=option+'--strip-relocs=0 ';
 if MainWindow.BackupCheckBox.Checked=True then option:=option+'--backup ';
 if MainWindow.ForceCheckBox.Checked=True then option:=option+'-f ';
 get_option:=option;
end;

function get_backend():string;
begin
 get_backend:=ExtractFilePath(Application.ExeName)+'upx.exe';
end;

procedure compress_file(const target:string);
var option:string;
begin
 option:=get_option()+convert_file_name(target);
 if execute_program(get_backend(),option)=-1 then
 begin
  ShowMessage('Can not compress the target file');
 end;

end;

procedure decompress_file(const target:string);
var option:string;
begin
 option:='-d '+convert_file_name(target);
 if execute_program(get_backend(),option)=-1 then
 begin
  ShowMessage('Can not decompress the target file');
 end;

end;

procedure interface_setup();
begin
 MainWindow.CompressButton.Enabled:=False;
 MainWindow.DecompressButton.Enabled:=False;
 MainWindow.ExportCheckBox.Checked:=False;
 MainWindow.ResourcesCheckBox.Checked:=False;
 MainWindow.IconsCheckBox.Checked:=False;
 MainWindow.RelocationCheckBox.Checked:=True;
 MainWindow.BackupCheckBox.Checked:=False;
 MainWindow.ForceCheckBox.Checked:=False;
 MainWindow.CompressionField.Enabled:=False;
 MainWindow.DecompressionField.Enabled:=False;
 MainWindow.CompressionField.LabelPosition:=lpLeft;
 MainWindow.DecompressionField.LabelPosition:=lpLeft;
 MainWindow.CompressionField.Text:='';
 MainWindow.DecompressionField.Text:='';
 MainWindow.RatioBar.Orientation:=trHorizontal;
 MainWindow.RatioBar.TickStyle:=tsAuto;
 MainWindow.RatioBar.Min:=0;
 MainWindow.RatioBar.Max:=11;
 MainWindow.RatioBar.Position:=9;
 MainWindow.WorkSpace.ActivePageIndex:=0;
end;

procedure language_setup();
begin
 MainWindow.CompressionField.EditLabel.Caption:='Target file';
 MainWindow.DecompressionField.EditLabel.Caption:='Target file';
 MainWindow.OpenCompressedButton.Caption:='Open';
 MainWindow.CompressButton.Caption:='Compress';
 MainWindow.OpenDecompressedButton.Caption:='Open';
 MainWindow.DecompressButton.Caption:='Decompress';
 MainWindow.OpenDialog.Title:='Open an executable file';
 MainWindow.WorkSpace.Pages[0].Caption:='Compression';
 MainWindow.WorkSpace.Pages[1].Caption:='Decompression';
 MainWindow.ExportCheckBox.Caption:='Dont compress the export section';
 MainWindow.ResourcesCheckBox.Caption:='Dont compress the resources';
 MainWindow.IconsCheckBox.Caption:='Dont compress the icons';
 MainWindow.RelocationCheckBox.Caption:='Dont strip the relocations';
 MainWindow.BackupCheckBox.Caption:='Create a backup';
 MainWindow.ForceCheckBox.Caption:='Force compression';
 MainWindow.RatioPanel.Caption:='Compress ratio';
end;

procedure setup();
begin
 window_setup();
 dialog_setup();
 interface_setup();
 language_setup();
end;

{ TMainWindow }

procedure TMainWindow.FormCreate(Sender: TObject);
begin
 setup();
end;

procedure TMainWindow.CompressionFieldChange(Sender: TObject);
begin
 MainWindow.CompressButton.Enabled:=MainWindow.CompressionField.Text<>'';
end;

procedure TMainWindow.DecompressionFieldChange(Sender: TObject);
begin
 MainWindow.DecompressButton.Enabled:=MainWindow.DecompressionField.Text<>'';
end;

procedure TMainWindow.OpenCompressedButtonClick(Sender: TObject);
begin
 if MainWindow.OpenDialog.Execute()=True then
 begin
  MainWindow.CompressionField.Text:=MainWindow.OpenDialog.FileName;
 end;

end;

procedure TMainWindow.CompressButtonClick(Sender: TObject);
begin
 compress_file(MainWindow.CompressionField.Text);
end;

procedure TMainWindow.OpenDecompressedButtonClick(Sender: TObject);
begin
 if MainWindow.OpenDialog.Execute()=True then
 begin
  MainWindow.DecompressionField.Text:=MainWindow.OpenDialog.FileName;
 end;

end;

procedure TMainWindow.DecompressButtonClick(Sender: TObject);
begin
 decompress_file(MainWindow.DecompressionField.Text);
end;

procedure TMainWindow.RelocationCheckBoxClick(Sender: TObject);
begin
 MainWindow.BackupCheckBox.Checked:=not MainWindow.RelocationCheckBox.Checked;
end;

procedure TMainWindow.ForceCheckBoxClick(Sender: TObject);
begin
 MainWindow.BackupCheckBox.Checked:=MainWindow.ForceCheckBox.Checked;
end;

end.
