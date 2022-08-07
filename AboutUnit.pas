unit AboutUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.Buttons;

type
  TAboutForm = class(TForm)
    LinkLabel1: TLinkLabel;
    LinkLabel2: TLinkLabel;
    Image1: TImage;
    BitBtn1: TBitBtn;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure LinkClick(Sender: TObject; const Link: string; LinkType: TSysLinkType);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

uses
  UtilsUnit;

{$R *.dfm}

procedure TAboutForm.FormCreate(Sender: TObject);
begin
  Label3.Caption := 'Version:' + GetVersion(ParamStr(0)).Substring(1);
end;

procedure TAboutForm.LinkClick(Sender: TObject; const Link: string; LinkType: TSysLinkType);
begin
  ShellExecute(0, 'open', PChar(Link), nil, nil, SW_SHOWNORMAL);
end;

end.
