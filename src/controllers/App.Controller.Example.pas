unit App.Controller.Example;

interface

uses
  App.Controller.Intf, Horse;

type
  TControllerExample = class(TNoRefCountObject, IAppController)
  private
    class var FController: TControllerExample;
    procedure Example(ARequest: THorseRequest; AResponse: THorseResponse);
  public
    class function GetInstance: IAppController;
    class destructor UnInitialize;

    { IAppController }
    function Registry(const AContext: string): IAppController;
    function SwaggerDefinition(const AContext: string): IAppController;
  end;

implementation

uses
  System.SysUtils, Repository.Factory, Service.Factory, DataSet.Serialize;

{ TControllerExample }

procedure TControllerExample.Example(ARequest: THorseRequest; AResponse: THorseResponse);
begin
  var LRepoFactory := TRepositoryFactory.New;

  var LDados := TServiceFactory.New
    .Example(LRepoFactory)
    .GetDados;

  var LJson := LDados.ToJSONArray();
  AResponse.Status(THTTPStatus.OK).Send(LJson);

  LDados.Free;
end;

class function TControllerExample.GetInstance: IAppController;
begin
  if not Assigned(FController) then
    FController := TControllerExample.Create;
  Result := FController;
end;

function TControllerExample.Registry(const AContext: string): IAppController;
begin
  Result := Self;

  THorse
    .Group.Prefix(AContext)
    .Get('/example', Example)
end;

function TControllerExample.SwaggerDefinition(const AContext: string): IAppController;
begin
  Result := Self;
end;

class destructor TControllerExample.UnInitialize;
begin
  if Assigned(FController) then
    FreeAndNil(FController);
end;

end.
