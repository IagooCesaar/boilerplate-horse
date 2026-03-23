unit BO.Example;

interface

uses
  BO.Intf;

type
  TBOExample = class(TInterfacedObject, IBOExample)
  public
    class function New: IBOExample;

    { IBOExample }
    procedure WriteOnConsole;
    procedure WirteOnTextFile;
  end;

implementation

uses
  System.SysUtils, System.Classes;

{ TBOExample }

class function TBOExample.New: IBOExample;
begin
  Result := Self.Create;
end;

procedure TBOExample.WirteOnTextFile;
begin
  var LArq := TStringList.Create;
  try
    LArq.LoadFromFile('C:\Temp\teste.txt');
    LArq.Add('This writes on TXT - '+DateTimeToStr(Now));
    LArq.SaveToFile('C:\Temp\teste.txt');
  finally
    LArq.Free;
  end;
end;

procedure TBOExample.WriteOnConsole;
begin
  Writeln('This writes on Console '+DateTimeToStr(Now));
end;

end.
