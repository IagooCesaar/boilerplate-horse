unit Infraestructure.DatabaseConfig;

interface

uses
  Database.Tipos, Infraestructure.DatabaseConfig.Intf;

type
  TInfraestructureDatabaseConfig = class
  public
    class procedure Configure(const AProvider: IDatabaseConfigProvider);
  end;

implementation

uses
  Database.Factory;

{ TInfraestructureDatabaseConfig }

class procedure TInfraestructureDatabaseConfig.Configure(const AProvider: IDatabaseConfigProvider);
begin
  AProvider.LoadConfig;

  TDatabaseFactory.New
    .Conexao
      .SetConnectionDefDriverParams(AProvider.DBDriverParams)
      .SetConnectionDefParams(AProvider.DBParams)
      .SetConnectionDefPoolParams(AProvider.DBPoolParams)
    .IniciaPoolConexoes;
end;

end.
