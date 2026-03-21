unit Repository.Example;

interface

uses
  Repository.Intf, Data.DB;

type
  TRepositoryExample = class(TInterfacedObject, IRepositoryExample)
  public
    class function New: IRepositoryExample;

    { IRepositoryExample }
    function GetDados: TDataSet;
  end;

implementation

uses
  FireDAC.Comp.Client, Database.SQL, Database.Tipos;

{ TRepositoryExample }

function TRepositoryExample.GetDados: TDataSet;
begin
  var LDados := TFDMemTable.Create(nil);
  LDados.FieldDefs.Add('nome', ftString, 20);
  LDados.CreateDataSet;

  Result := LDados;
  {// fazer consulta à base de dados oficial do projeto
  Result := nil;

  var LSQL := 'select * from ITEM where cod_item = :cod_item';
  var ds := TDatabaseFactory.New
    .SQL
    .SQL(LSQL)
    .ParamList
      .AddInteger('cod_item', ACodItem)
      .&End
    .Open;

  if ds.isEmpty
  then Exit;

  Result := AtribuiCampos(ds);}
end;

class function TRepositoryExample.New: IRepositoryExample;
begin
  Result := Self.Create;
end;

end.
