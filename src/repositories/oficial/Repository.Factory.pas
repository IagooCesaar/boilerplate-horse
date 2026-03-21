unit Repository.Factory;

interface

uses
  Repository.Intf;

type
  TRepositoryFactory = class(TInterfacedObject, IRepositoryFactory)
  public
    class function New: IRepositoryFactory;

    { IRepositoryFactory }
    function Example: IRepositoryExample;
  end;

implementation

uses
  Repository.Example;

{ TRepositoryFactory }

function TRepositoryFactory.Example: IRepositoryExample;
begin
  Result := TRepositoryExample.New;
end;

class function TRepositoryFactory.New: IRepositoryFactory;
begin
  Result := Self.Create;
end;

end.
