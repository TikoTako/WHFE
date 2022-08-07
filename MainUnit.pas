unit MainUnit;

interface

uses
  SettingsUnit,
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.UITypes, System.IOUtils,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TMainForm = class(TForm)
    Memo1: TMemo;
    Button2: TButton;
    FontDialog1: TFontDialog;
    AboutButton: TButton;
    BackupCheckBox: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure AboutButtonClick(Sender: TObject);
  private
    { Private declarations }
    fSettings: TSettings;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  gHostsFileName, gOriginalHostsFileData: string;

implementation

uses
  AboutUnit;

const
  cHostsFileName = 'c:\windows\system32\drivers\etc\hosts';

{$R *.dfm}

procedure TMainForm.Button2Click(Sender: TObject);
begin
  FontDialog1.Font := Memo1.Font;
  if FontDialog1.Execute then
    Memo1.Font := FontDialog1.Font;
end;

procedure TMainForm.AboutButtonClick(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  vMr: TModalResult;
begin
  CanClose := true;
  if not gOriginalHostsFileData.Equals(Memo1.Lines.Text) then
  begin
    vMr := MessageDlg('Wanna save da file?', mtConfirmation, [mbYes, mbNo, mbCancel], 0);
    case vMr of
      mrYes:
        try
          if BackupCheckBox.Checked then
          begin
            if not DirectoryExists('backup') then
              TDirectory.CreateDirectory('backup');
            try
              with TFileStream.create(Format('backup\%s.txt', [FormatDateTime('DD-MM-YYY HH_nn_ss', now)]), fmCreate) do
                try
                  writeBuffer(gOriginalHostsFileData[1], Length(gOriginalHostsFileData));
                finally
                  free;
                end;
            except
              on e: exception do
                MessageDlg(e.Message, mtError, [mbOk], 0);
            end;
          end;
          Memo1.Lines.SaveToFile(gHostsFileName);
        except
          on e: exception do
            MessageDlg(e.Message, mtError, [mbOk], 0);
        end;
      mrNo:
        ; //
      mrCancel:
        CanClose := false;
    end;
  end;

  if CanClose then
    fSettings.free;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  fSettings := TSettings.create(TForm(self));
  if ParamCount > 0 then
    gHostsFileName := ParamStr(1)
  else
    gHostsFileName := cHostsFileName;
  Memo1.Lines.LoadFromFile(gHostsFileName);
  gOriginalHostsFileData := Memo1.Lines.Text;
end;

end.
