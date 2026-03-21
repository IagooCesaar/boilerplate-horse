unit App.Controller.Factory;

interface

uses
  App.Controller.Intf;

type
  TAppControllerFactory = class(TNoRefCountObject, IAppController)
  private
    class var FFactory: TAppControllerFactory;
  public
    class function GetInstance: IAppController;
    class destructor UnInitialize;

    { IAppController }
    function Registry(const AContext: string): IAppController;
    function SwaggerDefinition(const AContext: string): IAppController;
  end;

implementation

uses
  System.SysUtils, App.Controller.Infraestructure;

{ TAppControllerFactory }

class function TAppControllerFactory.GetInstance: IAppController;
begin
  if not Assigned(FFactory) then
    FFactory := TAppControllerFactory.Create;
  Result := FFactory;
end;

function TAppControllerFactory.Registry(const AContext: string): IAppController;
begin
  Result := Self;

  TControllerInfraestructure.GetInstance
    .Registry(AContext);
end;

function TAppControllerFactory.SwaggerDefinition(const AContext: string): IAppController;
begin
  Result := Self;

  TControllerInfraestructure.GetInstance
    .SwaggerDefinition(AContext)
end;

class destructor TAppControllerFactory.UnInitialize;
begin
  if Assigned(FFactory) then
    FreeAndNil(FFactory);
end;

end.
