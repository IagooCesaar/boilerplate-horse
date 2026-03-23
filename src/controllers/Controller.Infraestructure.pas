unit Controller.Infraestructure;

interface

uses
  Controller.Intf, Horse;

type
  TControllerInfraestructure = class(TNoRefCountObject, IController)
  private
    class var FController: TControllerInfraestructure;
    procedure Healthcheck(ARequest: THorseRequest; AResponse: THorseResponse);
    procedure Version(ARequest: THorseRequest; AResponse: THorseResponse);
  public
    class function GetInstance: IController;
    class destructor UnInitialize;

    { IController }
    function Registry(const AContext: string): IController;
    function SwaggerDefinition(const AContext: string): IController;
  end;

implementation

uses
  System.SysUtils, App, Horse.GBSwagger, DTO.Infraestructure.Healthcheck, Horse.JsonInterceptor.Helpers,
  DTO.Infraestructure.ApiVersion;

{ TControllerInfraestructure }

class function TControllerInfraestructure.GetInstance: IController;
begin
  if not Assigned(FController) then
    FController := TControllerInfraestructure.Create;
  Result := FController;
end;

procedure TControllerInfraestructure.Healthcheck(ARequest: THorseRequest; AResponse: THorseResponse);
begin
  var LDto := TDTOHealthcheck.Create;
  AResponse.Status(THTTPStatus.OK)
    .Send(TJson.ObjectToClearJsonObject(LDto));
  LDto.Free;
end;

function TControllerInfraestructure.Registry(const AContext: string): IController;
begin
  Result := Self;

  THorse
    .Get('/healthcheck', Healthcheck)
    .Get('/api-version', Version);
end;

function TControllerInfraestructure.SwaggerDefinition(const AContext: string): IController;
begin
  Result := Self;

  Swagger
    .Path('/healthcheck')
    .Tag('Infraestrutura')
      .GET('Healthcheck')
        .Description('Utilitário para verificar execução do serviço')
        .AddResponse(Integer(THTTPStatus.OK)).Schema(TDTOHealthcheck).&End
      .&End
    .&End

    .Path('/api-version')
    .Tag('Infraestrutura')
      .GET('API Version')
        .Description('Informações da versão da API')
        .AddResponse(Integer(THTTPStatus.OK)).Schema(TDTOApiVersion).&End
      .&End
    .&End;
end;

class destructor TControllerInfraestructure.UnInitialize;
begin
  if Assigned(FController) then
    FreeAndNil(FController);
end;

procedure TControllerInfraestructure.Version(ARequest: THorseRequest; AResponse: THorseResponse);
begin
  var LDto := TDTOApiVersion.Create;
  LDto.Version := TApp.GetInstance.Version;
  AResponse.Status(THTTPStatus.OK)
    .Send(TJson.ObjectToClearJsonObject(LDto));
  LDto.Free;
end;

end.
