unit Service.Example;

interface

uses
  Service.Intf, Repository.Intf, Data.DB;

type
  TServiceExample = class(TInterfacedObject, IServiceExample)
  private
    FRepoFactory: IRepositoryFactory;
  public
    class function New(const ARepoFactory: IRepositoryFactory): IServiceExample;
    constructor Create(const ARepoFactory: IRepositoryFactory);

    { IServiceExample }
    function GetDados: TDataSet;
  end;

implementation

{ TServiceExample }

constructor TServiceExample.Create(const ARepoFactory: IRepositoryFactory);
begin
  FRepoFactory := ARepoFactory;
end;

function TServiceExample.GetDados: TDataSet;
begin
  Result := FRepoFactory.Example.GetDados;
end;

class function TServiceExample.New(const ARepoFactory: IRepositoryFactory): IServiceExample;
begin
  Result := Self.Create(ARepoFactory);
end;

end.
