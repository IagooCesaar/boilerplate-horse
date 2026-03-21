unit IntegrationTest.Config;

interface

uses
  App, RESTRequest4D;

type
  TIntegrationTestConfig = class
  private
    class var FIntegrationTestConfig: TIntegrationTestConfig;
  public
    constructor Create;
	  destructor Destroy; override;
    class destructor UnInitialize;
    class function GetInstance: TIntegrationTestConfig;

    function DefaultRequest: IRequest;
  end;

implementation

uses
  System.SysUtils;

{ TIntegrationTestConfig }

constructor TIntegrationTestConfig.Create;
begin
  TApp.GetInstance.Start(9001);
end;

function TIntegrationTestConfig.DefaultRequest: IRequest;
begin
  Result := TRequest.New
    .BaseURL(TApp.GetInstance.BaseURL);
end;

destructor TIntegrationTestConfig.Destroy;
begin
  TApp.GetInstance.Free;

  inherited;
end;

class function TIntegrationTestConfig.GetInstance: TIntegrationTestConfig;
begin
  if not Assigned(FIntegrationTestConfig) then
    FIntegrationTestConfig := TIntegrationTestConfig.Create;
  Result := FIntegrationTestConfig;
end;

class destructor TIntegrationTestConfig.UnInitialize;
begin
  if Assigned(FIntegrationTestConfig) then
    FreeAndNil(FIntegrationTestConfig);
end;

end.
