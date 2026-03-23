unit Repository.InMemory.Example;

interface

uses
  Repository.Intf, Data.DB;

type
  TRepositoryInMemoryExample = class(TNoRefCountObject, IRepositoryExample)
  public
    class var FRepo: TRepositoryInMemoryExample;
    class function GetInstance: IRepositoryExample;
    class destructor UnInitialize;

    { IRepositoryExample }
    function GetDados: TDataSet;
  end;

implementation

uses
  System.SysUtils, FireDAC.Comp.Client;

{ TRepositoryInMemoryExample }

function TRepositoryInMemoryExample.GetDados: TDataSet;
begin
  var LDados := TFDMemTable.Create(nil);
  LDados.FieldDefs.Add('exemplo', ftString, 20);
  LDados.CreateDataSet;

  LDados.Append;
  LDados.FieldByName('exemplo').AsString := 'In Memory';
  LDados.Post;

  Result := LDados;
end;

class function TRepositoryInMemoryExample.GetInstance: IRepositoryExample;
begin
  if not Assigned(FRepo) then
    FRepo := TRepositoryInMemoryExample.Create;
  Result := FRepo;
end;

class destructor TRepositoryInMemoryExample.UnInitialize;
begin
  if Assigned(FRepo) then
    FreeAndNil(FRepo);
end;

end.
