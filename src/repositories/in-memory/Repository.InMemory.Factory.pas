unit Repository.InMemory.Factory;

interface

uses
  Repository.Intf;

type
  TRepositoryInMemoryFactory = class(TNoRefCountObject, IRepositoryFactory)
  public
    class var FRepo: TRepositoryInMemoryFactory;
    class function GetInstance: IRepositoryFactory;
    class destructor UnInitialize;

    { IRepositoryFactory }
    function Example: IRepositoryExample;
  end;

implementation

uses
  Repository.InMemory.Example, System.SysUtils;

{ TRepositoryInMemoryFactory }

function TRepositoryInMemoryFactory.Example: IRepositoryExample;
begin
  Result := TRepositoryInMemoryExample.GetInstance;
end;

class function TRepositoryInMemoryFactory.GetInstance: IRepositoryFactory;
begin
  if not Assigned(FRepo) then
    FRepo := TRepositoryInMemoryFactory.Create;
  Result := FRepo;
end;

class destructor TRepositoryInMemoryFactory.UnInitialize;
begin
  if Assigned(FRepo) then
    FreeAndNil(FRepo);
end;

end.
