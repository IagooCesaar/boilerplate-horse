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
  LDados.FieldDefs.Add('exemplo', ftString, 20);
  LDados.CreateDataSet;

  LDados.Append;
  LDados.FieldByName('exemplo').AsString := 'Oficial';
  LDados.Post;

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
