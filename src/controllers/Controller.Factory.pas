unit Controller.Factory;

interface

uses
  Controller.Intf;

type
  TControllerFactory = class(TNoRefCountObject, IController)
  private
    class var FFactory: TControllerFactory;
  public
    class function GetInstance: IController;
    class destructor UnInitialize;

    { IController }
    function Registry(const AContext: string): IController;
    function SwaggerDefinition(const AContext: string): IController;
  end;

implementation

uses
  System.SysUtils, Controller.Infraestructure, Controller.Example;

{ TControllerFactory }

class function TControllerFactory.GetInstance: IController;
begin
  if not Assigned(FFactory) then
    FFactory := TControllerFactory.Create;
  Result := FFactory;
end;

function TControllerFactory.Registry(const AContext: string): IController;
begin
  Result := Self;

  TControllerInfraestructure.GetInstance.Registry(AContext);
  TControllerExample.GetInstance.Registry(AContext);
end;

function TControllerFactory.SwaggerDefinition(const AContext: string): IController;
begin
  Result := Self;

  TControllerInfraestructure.GetInstance.SwaggerDefinition(AContext);
  TControllerExample.GetInstance.SwaggerDefinition(AContext);
end;

class destructor TControllerFactory.UnInitialize;
begin
  if Assigned(FFactory) then
    FreeAndNil(FFactory);
end;

end.
