unit Infraestructure.Worker.Registry;

interface

uses
  Infraestructure.Worker.Config, System.Generics.Collections;

type
  TWorkerRegistry = class
  private
    FWorkers: TObjectList<TWorkerConfig>;
    class var FRegistry: TWorkerRegistry;
  public
    class function GetInstance: TWorkerRegistry;
    class destructor UnInitialize;
    constructor Create;
    destructor Destroy; override;

    procedure AddWorker(const AWorker: TWorkerConfig);
    function GetWorkers: TArray<TWorkerConfig>;
  end;

implementation

uses
  System.SysUtils, System.SyncObjs;

var
  GLock: TCriticalSection; // thread-safe

{ TWorkerRegistry }

procedure TWorkerRegistry.AddWorker(const AWorker: TWorkerConfig);
begin
  GLock.Acquire;
  try
    FWorkers.Add(AWorker);
  finally
    GLock.Release;
  end;
end;

constructor TWorkerRegistry.Create;
begin
  GLock.Acquire;
  try
    FWorkers := TObjectList<TWorkerConfig>.Create(True);
  finally
    GLock.Release;
  end;
end;

destructor TWorkerRegistry.Destroy;
begin
  FreeAndNil(FWorkers);

  inherited;
end;

class function TWorkerRegistry.GetInstance: TWorkerRegistry;
begin
  if not Assigned(FRegistry) then
  begin
    GLock.Acquire; // evita criar duas instâncias se muitas threads em execução
    try
      if not Assigned(FRegistry) then
        FRegistry := TWorkerRegistry.Create;
    finally
      GLock.Release;
    end;
  end;
  Result := FRegistry;
end;

function TWorkerRegistry.GetWorkers: TArray<TWorkerConfig>;
begin
  GLock.Acquire;
  try
    Result := FWorkers.ToArray;
  finally
    GLock.Release;
  end;
end;

class destructor TWorkerRegistry.UnInitialize;
begin
  if Assigned(FRegistry) then
    FreeAndNil(FRegistry);
end;

initialization
  GLock := TCriticalSection.Create;

finalization
  GLock.Free;

end.
