unit App;

interface

uses
  System.Classes, Infraestructure.DatabaseConfig.Provider.Ini;

type
  TApp = class
  private
    class var FApp: TApp;

    procedure ConfigSwagger;
    procedure ConfigLogger;
    procedure ConfigDatabase;
    function GetSwaggerURL: string;
    function GetIsRunning: Boolean;
    function GetContext: string;
    function GetBaseURL: string;
    function GetTitle: string;
    function GetDescription: string;
    function GetVersion: string;
  public
    class function GetInstance: TApp;

    constructor Create;
    destructor Destroy; override;

    property SwaggerURL: string read GetSwaggerURL;
    property IsRunning: Boolean read GetIsRunning;
    property Context: string read GetContext;
    property BaseURL: string read GetBaseURL;
    property Title: string read GetTitle;
    property Description: string read GetDescription;
    property Version: string read GetVersion;

    procedure Start(APort: Integer);
    procedure Stop;
  end;


implementation

uses
  System.SyncObjs, System.SysUtils, System.DateUtils, System.StrUtils, System.Types, System.IniFiles,
  Horse, Horse.Jhonson, Horse.HandleException, Horse.GBSwagger, Horse.Compression,
  DataSet.Serialize, Horse.OctetStream, Horse.Logger.Manager, Horse.Logger.Provider.Console, Controller.Factory,
  DTO.Infraestructure.ApiError, Infraestructure.DatabaseConfig, Infraestructure.Worker.Factory,
  Infraestructure.Worker.Horse, Infraestructure.Worker.ExceptionHandler, Infraestructure.Worker.Config;

{ TApp }

procedure TApp.ConfigDatabase;
begin
  var LIniFileName := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+
    'myapp_database_config.ini';

  TInfraestructureDatabaseConfig.Configure(
    TInfraestructureDatabaseConfigProviderIni.New(LIniFileName)
  );
end;

procedure TApp.ConfigLogger;
begin
  var ALogFormat := '${request_clientip} [${time}] "${request_method}::${request_path_translated}" '+
    '${response_status} ${execution_time}ms';

  THorseLoggerManager.RegisterProvider(THorseLoggerProviderConsole.New(
    THorseLoggerConsoleConfig.New
      .SetLogFormat(ALogFormat)
  ));
end;

procedure TApp.ConfigSwagger;
begin
  Swagger
    .BasePath('')
    //.AddBasicSecurity.&End
    //.AddBearerSecurity
    .Register
      .Response(Integer(THTTPStatus.NoContent)).Description('No Content').&End
      .Response(Integer(THTTPStatus.BadRequest)).Description('Bad Request')
        .Schema(TDTOApiError).&End
      .Response(Integer(THTTPStatus.NotFound)).Description('Not Found')
        .Schema(TDTOApiError).&End
      .Response(Integer(THTTPStatus.PreconditionFailed)).Description('Precondition Failed')
        .Schema(TDTOApiError).&End
      .Response(Integer(THTTPStatus.NotAcceptable)).Description('Not Acceptable')
        .Schema(TDTOApiError).&End
      .Response(Integer(THTTPStatus.InternalServerError)).Description('Internal Server Error').&End
    .&End
    .AddProtocol(TGBSwaggerProtocol.gbHttp)
    .AddProtocol(TGBSwaggerProtocol.gbHttps)
    .Info
      .Title(Title)
      .Version(Version)
      .Description(Description)
      .Contact
        .Name('Iago César F. Nogueira')
        .Email('iagocesar.nogueira@gmail.com')
      .&End
    .&End
  .&End;
end;

constructor TApp.Create;
begin
  {$IFDEF MSWINDOWS}
  IsConsole := False;
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  ConfigSwagger;
  ConfigLogger;
  ConfigDatabase;

  THorse.MaxConnections := StrToIntDef(GetEnvironmentVariable('MAXCONNECTIONS'), 10000);
  THorse.ListenQueue := StrToIntDef(GetEnvironmentVariable('LISTENQUEUE'), 200);

  THorse
    .Use(Compression())
    .Use(Jhonson('UTF-8'))
    .Use(OctetStream)
    .Use(THorseLoggerManager.HorseCallback)
    .Use(WorkerCallback)
    .Use(HorseSwagger(Context+'/swagger-ui', Context+'/api-docs'))
    {.Use(HorseBasicAuthentication(ValidarLogin,
      THorseBasicAuthenticationConfig.New.SkipRoutes([
        FContext+'/api/healthcheck/',
        FContext+'/swagger-ui/',
        FContext+'/api-docs/'
      ])
    ))}
    .Use(HandleException);

  TControllerFactory.GetInstance
    .Registry(Context)
    .SwaggerDefinition(Context);

  TWorkerFactory.New.Registry;
  TExceptionHandlerManager.GetInstance
    .UseDefaultHandler
    .AddHandler(
      procedure (AWorker: TWorkerConfig; AException: Exception)
      begin
        Writeln(Format('OUTROS EXCPT HNDL - [%s] ERRO: %s', [AWorker.Name, AException.Message]));
      end
    );
end;

destructor TApp.Destroy;
begin

  inherited;
end;

function TApp.GetBaseURL: string;
begin
  Result := Format('http://localhost:%d%s', [THorse.Port, Context]);
end;

function TApp.GetContext: string;
begin
  Result := '/my-app-context';
end;

function TApp.GetTitle: string;
begin
  Result := 'Boilerplate Horse';
end;

function TApp.GetDescription: string;
begin
  Result:= 'Boilerplate elaborado para facilitar novos projetos utilizando Horse';
end;

class function TApp.GetInstance: TApp;
begin
  if not Assigned(FApp) then
    FApp := TApp.Create;
  Result := FApp;
end;

function TApp.GetIsRunning: Boolean;
begin
  Result := THorse.IsRunning;
end;

function TApp.GetSwaggerURL: string;
begin
  Result := Copy(BaseURL, 0, Pos('/api',BaseURL)-1 )+'/swagger-ui';
end;

function TApp.GetVersion: string;
begin
  Result := '1.0.0';
end;

procedure TApp.Start(APort: Integer);
begin
  {$IF (not defined(TEST))}
  TWorkerFactory.New.Run;
  {$ENDIF}

  THorse.Listen(APort,
    procedure begin
      {$IF defined(CONSOLE) and (not defined(TEST))}
      Writeln(Format('Server is runing on %s:%d', [THorse.Host, THorse.Port]));
      Writeln(Format('Try use Swagger on %s', [Context+'\'+SwaggerURL]));
      Readln;

      Writeln('Shutting down workers gracefully...');
      TWorkerFactory.New.GracefullShuttdown;
      {$ENDIF}
    end);
end;

procedure TApp.Stop;
begin
  while THorse.IsRunning do
    THorse.StopListen;

  TWorkerFactory.New.GracefullShuttdown;
end;

end.
