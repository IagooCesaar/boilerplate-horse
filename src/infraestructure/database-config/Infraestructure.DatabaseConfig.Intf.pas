unit Infraestructure.DatabaseConfig.Intf;

interface

uses
  Database.Tipos;

type
  IDatabaseConfigProvider = interface
    ['{C45124BD-9C50-4C87-A441-F90B8A35F2AB}']
    function LoadConfig: IDatabaseConfigProvider;
    function SaveConfig: IDatabaseConfigProvider;
    function DBParams: TConnectionDefParams;
    function DBDriverParams: TConnectionDefDriverParams;
    function DBPoolParams: TConnectionDefPoolParams;
  end;

implementation

end.
