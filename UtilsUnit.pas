{
  Modified copypasta, original sauce:

  https://stackoverflow.com/questions/17279394/getfileversioninfosize-and-getfileversioninfo-return-nothing/17286050#17286050
}

unit UtilsUnit;

interface

function GetVersion(const FileName: string): String;

implementation

uses
  Winapi.Windows, System.SysUtils;

function GetVersion(const FileName: string): String;
var
  iLastError: DWord;
  vPVerInfo: Pointer;
  vVerInfoSize: Cardinal;
  vVerValueSize: Cardinal;
  vWhyThisExists: Cardinal;
  vPVerValue: PVSFixedFileInfo;
begin
  Result := '';
  iLastError := 0;
  vVerInfoSize := GetFileVersionInfoSize(PChar(FileName), vWhyThisExists);
  if vVerInfoSize > 0 then
  begin
    GetMem(vPVerInfo, vVerInfoSize);
    try
      if GetFileVersionInfo(PChar(FileName), 0, vVerInfoSize, vPVerInfo) then
      begin
        if VerQueryValue(vPVerInfo, '\', Pointer(vPVerValue), vVerValueSize) then
          with vPVerValue^ do
            Exit(Format('v %d.%d.%d build %d',
              //
              [HiWord(dwFileVersionMS), // Major
              LoWord(dwFileVersionMS), // Minor
              HiWord(dwFileVersionLS), // Release
              LoWord(dwFileVersionLS)])); // Build
      end
      else
        iLastError := GetLastError;
    finally
      FreeMem(vPVerInfo, vVerInfoSize); // this run anyway even with exit up there
    end;
  end
  else
    iLastError := GetLastError;
  Result := Format('GetVersion failed: (%d) %s', [iLastError, SysErrorMessage(iLastError)]);
end;

end.
