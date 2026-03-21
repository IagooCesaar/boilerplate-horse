unit Infraestructure.DatabaseConfig.Provider.Ini;

interface

uses
  Infraestructure.DatabaseConfig.Intf, Database.Tipos, System.IniFiles;

type
  TInfraestructureDatabaseConfigProviderIni = class(TInterfacedObject, IDatabaseConfigProvider)
  private
    FIniFileName: string;
    FIniFile: TIniFile;
    FDBParams: TConnectionDefParams;
    FDBDriverParams: TConnectionDefDriverParams;
    FDBPoolParams: TConnectionDefPoolParams;
  public
    class function New(const AIniFileName: string): IDatabaseConfigProvider;
    constructor Create(const AIniFileName: string);
    destructor Destroy; override;
    { IDatabaseConfigProvider }
    function LoadConfig: IDatabaseConfigProvider;
    function SaveConfig: IDatabaseConfigProvider;
    function DBParams: TConnectionDefParams;
    function DBDriverParams: TConnectionDefDriverParams;
    function DBPoolParams: TConnectionDefPoolParams;
  end;

implementation

uses
  System.SysUtils;

{ TInfraestructureDatabaseConfigProviderIni }

constructor TInfraestructureDatabaseConfigProviderIni.Create(const AIniFileName: string);
begin
  FIniFileName := AIniFileName;
  FIniFile := TIniFile.Create(FIniFileName);
end;

function TInfraestructureDatabaseConfigProviderIni.DBDriverParams: TConnectionDefDriverParams;
begin
  Result := FDBDriverParams;
end;

function TInfraestructureDatabaseConfigProviderIni.DBParams: TConnectionDefParams;
begin
  Result := FDBParams;
end;

function TInfraestructureDatabaseConfigProviderIni.DBPoolParams: TConnectionDefPoolParams;
begin
  Result := FDBPoolParams;
end;

destructor TInfraestructureDatabaseConfigProviderIni.Destroy;
begin
  FreeAndNil(FIniFile);
  inherited;
end;

class function TInfraestructureDatabaseConfigProviderIni.New(const AIniFileName: string): IDatabaseConfigProvider;
begin
  Result := Self.Create(AIniFileName);
end;

function TInfraestructureDatabaseConfigProviderIni.SaveConfig: IDatabaseConfigProvider;
begin
  FIniFile.WriteString('DBParam', 'Server', FDBParams.Server);
  FIniFile.WriteString('DBParam', 'Databae',FDBParams.Database);
  FIniFile.WriteString('DBParam', 'UserName',FDBParams.UserName);
  FIniFile.WriteString('DBParam', 'Password',FDBParams.Password);

  FIniFile.WriteString('DBDriverParams', 'VendorLib', FDBDriverParams.VendorLib);

  FIniFile.WriteInt64('DBPoolParams', 'PoolMaximumItems', FDBPoolParams.PoolMaximumItems);
  FIniFile.WriteInt64('DBPoolParams', 'PoolCleanupTimeout', FDBPoolParams.PoolCleanupTimeout);
  FIniFile.WriteInt64('DBPoolParams', 'PoolExpireTimeout', FDBPoolParams.PoolExpireTimeout);
end;

function TInfraestructureDatabaseConfigProviderIni.LoadConfig: IDatabaseConfigProvider;
begin
  FDBParams := Default(TConnectionDefParams);
  FDBDriverParams := Default(TConnectionDefDriverParams);
  FDBPoolParams := Default(TConnectionDefPoolParams);

  // Parâmetros fixos
  FDBParams.ConnectionDefName := 'bd_loja';
  FDBDriverParams.DriverID := 'FB';
  FDBDriverParams.DriverDefName := 'FB_DRIVER';
  FDBParams.LocalConnection := False;
  FDBPoolParams.Pooled := True;

  FDBParams.Server := FIniFile.ReadString('DBParam', 'Server', '127.0.0.1');
  FDBParams.Database := FIniFile.ReadString('DBParam', 'Databae',
    'C:\#DEV\#Projetos\loja\server\database\loja-bd.fbd');
  FDBParams.UserName := FIniFile.ReadString('DBParam', 'UserName', 'SYSDBA');
  FDBParams.Password := FIniFile.ReadString('DBParam', 'Password', 'masterkey');

  FDBDriverParams.VendorLib := FIniFile.ReadString('DBDriverParams',
    'VendorLib', '');

  FDBPoolParams.PoolMaximumItems := FIniFile.ReadInteger('DBPoolParams',
    'PoolMaximumItems', 50);
  FDBPoolParams.PoolCleanupTimeout := FIniFile.ReadInteger('DBPoolParams',
    'PoolCleanupTimeout', 30000);
  FDBPoolParams.PoolExpireTimeout := FIniFile.ReadInteger('DBPoolParams',
    'PoolExpireTimeout', 60000);
end;

end.
