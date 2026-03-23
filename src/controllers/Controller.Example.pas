unit Controller.Example;

interface

uses
  Controller.Intf, Horse;

type
  TControllerExample = class(TNoRefCountObject, IController)
  private
    class var FController: TControllerExample;
    procedure Example(ARequest: THorseRequest; AResponse: THorseResponse);
  public
    class function GetInstance: IController;
    class destructor UnInitialize;

    { IController }
    function Registry(const AContext: string): IController;
    function SwaggerDefinition(const AContext: string): IController;
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

class function TControllerExample.GetInstance: IController;
begin
  if not Assigned(FController) then
    FController := TControllerExample.Create;
  Result := FController;
end;

function TControllerExample.Registry(const AContext: string): IController;
begin
  Result := Self;

  THorse
    .Group.Prefix(AContext)
    .Get('/example', Example)
end;

function TControllerExample.SwaggerDefinition(const AContext: string): IController;
begin
  Result := Self;
end;

class destructor TControllerExample.UnInitialize;
begin
  if Assigned(FController) then
    FreeAndNil(FController);
end;

end.
