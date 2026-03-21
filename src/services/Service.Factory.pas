unit Service.Factory;

interface

uses
  Service.Intf, Repository.Intf;

type
  TServiceFactory = class(TInterfacedObject, IServiceFactory)
  public
    class function New: IServiceFactory;

    { IServiceFactory }
    function Example(const ARepoFactory: IRepositoryFactory): IServiceExample;
  end;

implementation

uses
  Service.Example;

{ TServiceFactory }

function TServiceFactory.Example(const ARepoFactory: IRepositoryFactory): IServiceExample;
begin
  Result := TServiceExample.New(ARepoFactory);
end;

class function TServiceFactory.New: IServiceFactory;
begin
  Result := Self.Create;
end;

end.
