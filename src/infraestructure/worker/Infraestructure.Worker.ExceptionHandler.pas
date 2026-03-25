unit Infraestructure.Worker.ExceptionHandler;

interface

uses
  System.SysUtils, Horse, Infraestructure.Worker.Config, System.Generics.Collections;

type
  TExceptionHandler = reference to procedure (AWorker: TWorkerConfig; AException: Exception);

  TExceptionHandlerManager = class
  private
    FHandlers: TArray<TExceptionHandler>;
    class var FManager: TExceptionHandlerManager;
    procedure DefaultHandler(AWorker: TWorkerConfig; AException: Exception);
  public
    class function GetInstance: TExceptionHandlerManager;
    class destructor UnInitialize;
    constructor Create;

    function UseDefaultHandler: TExceptionHandlerManager;
    function AddHandler(AHandler: TExceptionHandler): TExceptionHandlerManager;
    procedure Handle(const AWorker: TWorkerConfig; const AException: Exception);
  end;

implementation

{ TExceptionHandlerManager }

function TExceptionHandlerManager.AddHandler(AHandler: TExceptionHandler): TExceptionHandlerManager;
begin
  SetLength(FHandlers, Length(FHandlers)+1);
  FHandlers[Length(FHandlers)-1] := AHandler;
end;

constructor TExceptionHandlerManager.Create;
begin
  SetLength(FHandlers, 0);
end;

procedure TExceptionHandlerManager.DefaultHandler(AWorker: TWorkerConfig; AException: Exception);
begin
  Writeln(Format('[%s] ERRO: %s', [AWorker.Name, AException.Message]));
end;

class function TExceptionHandlerManager.GetInstance: TExceptionHandlerManager;
begin
  if not Assigned(FManager) then
    FManager := TExceptionHandlerManager.Create;
  Result := FManager;
end;

procedure TExceptionHandlerManager.Handle(const AWorker: TWorkerConfig; const AException: Exception);
begin
  for var LHandler in FHandlers do
    LHandler(AWorker, AException);
end;

class destructor TExceptionHandlerManager.UnInitialize;
begin
  FreeAndNil(FManager);
  inherited;
end;

function TExceptionHandlerManager.UseDefaultHandler: TExceptionHandlerManager;
begin
  Result := Self;
  AddHandler(DefaultHandler);
end;

end.
