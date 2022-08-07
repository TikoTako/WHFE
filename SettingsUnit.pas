unit SettingsUnit;

interface

uses
  System.Classes, System.SysUtils,
  Vcl.Forms, Vcl.StdCtrls, Vcl.Graphics;

type
  TFormHax = class(TCustomForm);
  TFontHax = class(TFont);

  TSettings = class(TComponent)
  strict private
    fForm: TForm;
    fFS: TFileStream;
    fData: array of byte;
  public
    constructor Create(Form: TForm; FileName: string = 'settings.whfe'); reintroduce;
    destructor Destroy; override;
  end;

implementation

const
  IntSize = SizeOf(Integer);
  DataSize = IntSize * 6;

constructor TSettings.Create(Form: TForm; FileName: string = 'settings.whfe');
var
  b: byte;
  vFoMode: Word;
  i, vFontSize: Integer;
  vFontName: AnsiString;
begin
  fForm := Form;
  inherited Create(fForm);
  if FileExists(FileName) then
    vFoMode := fmOpenReadWrite
  else
    vFoMode := fmCreate;
  fFS := TFileStream.Create(FileName, vFoMode);
  SetLength(fData, DataSize);

  if fFS.Size > 0 then
  begin
    fFS.Read(fData[0], DataSize);
    fForm.Top := PInteger(@fData[0])^;
    fForm.Left := PInteger(@fData[IntSize])^;
    fForm.Width := PInteger(@fData[IntSize * 2])^;
    fForm.Height := PInteger(@fData[IntSize * 3])^;
    //
    vFontSize := PInteger(@fData[IntSize * 4])^;
    i := PInteger(@fData[IntSize * 5])^;
    SetLength(vFontName, i);
    fFS.Read(vFontName[1], i);
    // derp
    for i := 0 to fForm.ComponentCount - 1 do
      if fForm.Components[i] is TMemo then
      begin
        TMemo(fForm.Components[i]).Font.Size := vFontSize;
        TMemo(fForm.Components[i]).Font.Name := PWideString(@vFontName)^;
        break;
      end;

    fFS.Read(b, 1);
    for i := 0 to fForm.ComponentCount - 1 do
      if fForm.Components[i] is TCheckBox then
        TCheckBox(fForm.Components[i]).Checked := b = 1;
    SetLength(vFontName, 0);
    fFS.Position := 0;
  end;
end;

destructor TSettings.Destroy;
  function lolwut(bo: boolean): byte;
  begin
    if bo then
      Exit(1)
    else
      Exit(0);
  end;

var
  b: byte;
  i, ii: Integer;
begin
  fFS.Write(TFormHax(fForm).ExplicitTop, IntSize);
  fFS.Write(TFormHax(fForm).ExplicitLeft, IntSize);
  fFS.Write(TFormHax(fForm).ExplicitWidth, IntSize);
  fFS.Write(TFormHax(fForm).ExplicitHeight, IntSize);
  for i := 0 to fForm.ComponentCount - 1 do
    if fForm.Components[i] is TMemo then
    begin
      ii := TMemo(fForm.Components[i]).Font.Size;
      fFS.Write(ii, IntSize);
      ii := ByteLength(TMemo(fForm.Components[i]).Font.Name); // damn u widestrings è_é
      fFS.Write(ii, IntSize);
      fFS.Write(TMemo(fForm.Components[i]).Font.Name[1], ii);
      break;
    end;

  for i := 0 to fForm.ComponentCount - 1 do
    if fForm.Components[i] is TCheckBox then
    begin
      b := lolwut(TCheckBox(fForm.Components[i]).Checked);
      fFS.Write(b, 1);
    end;
  fFS.Size := fFS.Position;
  fFS.Free;
  inherited;
end;

end.
