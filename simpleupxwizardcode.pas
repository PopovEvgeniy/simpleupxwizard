unit simpleupxwizardcode;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, StdCtrls, LazFileUtils;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    Label1: TLabel;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TrackBar1: TTrackBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure LabeledEdit2Change(Sender: TObject);
  private

  public

  end;

var Form1: TForm1;

implementation

{$R *.lfm}

procedure window_setup();
begin
 Application.Title:='Simple upx wizard';
 Form1.Caption:='Simple upx wizard 0.8.6';
 Form1.BorderStyle:=bsDialog;
 Form1.Font.Name:=Screen.MenuFont.Name;
 Form1.Font.Size:=14;
end;

procedure dialog_setup();
begin
 Form1.OpenDialog1.InitialDir:='';
 Form1.OpenDialog1.FileName:='*.exe';
 Form1.OpenDialog1.DefaultExt:='*.exe';
 Form1.OpenDialog1.Filter:='Executable files|*.exe';
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
 option:=ratio[Form1.TrackBar1.Position];
 if Form1.CheckBox1.Checked=True then option:=option+'--compress-export=0 ';
 if Form1.CheckBox2.Checked=True then option:=option+'--compress-resources=0 ';
 if Form1.CheckBox3.Checked=True then option:=option+'--compress-icons=0 ';
 if Form1.CheckBox4.Checked=True then option:=option+'--strip-relocs=0 ';
 if Form1.CheckBox5.Checked=True then option:=option+'--backup ';
 if Form1.CheckBox6.Checked=True then option:=option+'-f ';
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
 Form1.Button2.Enabled:=False;
 Form1.Button4.Enabled:=False;
 Form1.CheckBox1.Checked:=False;
 Form1.CheckBox2.Checked:=False;
 Form1.CheckBox3.Checked:=False;
 Form1.CheckBox4.Checked:=True;
 Form1.CheckBox5.Checked:=False;
 Form1.CheckBox6.Checked:=False;
 Form1.LabeledEdit1.Enabled:=False;
 Form1.LabeledEdit2.Enabled:=False;
 Form1.LabeledEdit1.LabelPosition:=lpLeft;
 Form1.LabeledEdit2.LabelPosition:=lpLeft;
 Form1.LabeledEdit1.Text:='';
 Form1.LabeledEdit2.Text:='';
 Form1.TrackBar1.Orientation:=trHorizontal;
 Form1.TrackBar1.TickStyle:=tsAuto;
 Form1.TrackBar1.Min:=0;
 Form1.TrackBar1.Max:=11;
 Form1.TrackBar1.Position:=9;
 Form1.PageControl1.ActivePageIndex:=0;
end;

procedure language_setup();
begin
 Form1.LabeledEdit1.EditLabel.Caption:='Target file';
 Form1.LabeledEdit2.EditLabel.Caption:='Target file';
 Form1.Button1.Caption:='Open';
 Form1.Button2.Caption:='Compress';
 Form1.Button3.Caption:='Open';
 Form1.Button4.Caption:='Decompress';
 Form1.OpenDialog1.Title:='Open an executable file';
 Form1.PageControl1.Pages[0].Caption:='Compression';
 Form1.PageControl1.Pages[1].Caption:='Decompression';
 Form1.CheckBox1.Caption:='Dont compress the export section';
 Form1.CheckBox2.Caption:='Dont compress the resources';
 Form1.CheckBox3.Caption:='Dont compress the icons';
 Form1.CheckBox4.Caption:='Dont strip the relocations';
 Form1.CheckBox5.Caption:='Create a backup';
 Form1.CheckBox6.Caption:='Force compression';
 Form1.Label1.Caption:='Compress ratio';
end;

procedure setup();
begin
 window_setup();
 dialog_setup();
 interface_setup();
 language_setup();
end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
 setup();
end;

procedure TForm1.LabeledEdit1Change(Sender: TObject);
begin
 Form1.Button2.Enabled:=Form1.LabeledEdit1.Text<>'';
end;

procedure TForm1.LabeledEdit2Change(Sender: TObject);
begin
 Form1.Button4.Enabled:=Form1.LabeledEdit2.Text<>'';
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 if Form1.OpenDialog1.Execute()=True then
 begin
  Form1.LabeledEdit1.Text:=Form1.OpenDialog1.FileName;
 end;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 compress_file(Form1.LabeledEdit1.Text);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 if Form1.OpenDialog1.Execute()=True then
 begin
  Form1.LabeledEdit2.Text:=Form1.OpenDialog1.FileName;
 end;

end;

procedure TForm1.Button4Click(Sender: TObject);
begin
 decompress_file(Form1.LabeledEdit2.Text);
end;

procedure TForm1.CheckBox4Click(Sender: TObject);
begin
 Form1.CheckBox5.Checked:=not Form1.CheckBox4.Checked;
end;

procedure TForm1.CheckBox6Click(Sender: TObject);
begin
 Form1.CheckBox5.Checked:=Form1.CheckBox6.Checked;
end;

end.
