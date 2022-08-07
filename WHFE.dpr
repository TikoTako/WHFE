program WHFE;

uses
  Vcl.Forms,
  System.SysUtils,
  MainUnit in 'MainUnit.pas' {MainForm},
  SettingsUnit in 'SettingsUnit.pas',
  UtilsUnit in 'UtilsUnit.pas',
  AboutUnit in 'AboutUnit.pas' {AboutForm};

{$R *.res}

var
  s: string;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  s := GetVersion(paramstr(0));
  if s.StartsWith('GetVersion') then
    MainForm.Caption := s
  else
    MainForm.Caption := Format('Windows (c) TM Hosts File Editor (%s) [https://github.com/TikoTako]', [s]);
  Application.Title := Format('WHFE %s', [s]);
  Application.Run;

end.
