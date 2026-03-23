unit Infraestructure.Worker.Main;

interface

uses
  System.Classes;

type
  TWorkerMain = class(TComponent)
  private
    FGracefullShuttdown: Boolean;
    FPreventMainThreadShutdown: Boolean;
    procedure ExecuteTask(Sender: TObject);
    procedure Start;
  public
    constructor Create;
    class procedure Run(const APreventMainThreadShutdown: Boolean = false);
    class procedure GracefullShuttdown;
    class destructor Unitialize;
  end;

implementation

uses
  Infraestructure.Worker.Registry, System.Threading, System.SysUtils, Infraestructure.Worker.Config;

var
  GWorkerMain: TWorkerMain;

{ TWorkerMain }

constructor TWorkerMain.Create;
begin
  FGracefullShuttdown := False;
  FPreventMainThreadShutdown := False;
end;

procedure TWorkerMain.ExecuteTask(Sender: TObject);
const ONE_SECOND = 1000;
begin
  var LWorkerLocal := Sender as TWorkerConfig;
  var LRemaingInterval := LWorkerLocal.Interval;

  while not FGracefullShuttdown do
  begin
    try
      LWorkerLocal.Proc();
    except
      on E: Exception do
        Writeln(Format('[%s] ERRO: %s', [LWorkerLocal.Name, E.Message]));
    end;

    repeat
      if LRemaingInterval > ONE_SECOND then
      begin
        Dec(LRemaingInterval, ONE_SECOND);
        Sleep(ONE_SECOND)
      end
      else
      begin
        Sleep(LRemaingInterval);
        LRemaingInterval:= 0;
      end;
    until (LRemaingInterval = 0) or (FGracefullShuttdown);
    LRemaingInterval := LWorkerLocal.Interval;
  end;

  {$IFDEF CONSOLE}
  Writeln(Format('Worker "%s" stopped', [LWorkerLocal.Name]));
  {$ENDIF}
end;

class procedure TWorkerMain.GracefullShuttdown;
begin
  GWorkerMain.FGracefullShuttdown := True;
end;

class procedure TWorkerMain.Run(const APreventMainThreadShutdown: Boolean);
begin
  if not Assigned(GWorkerMain) then
    GWorkerMain := TWorkerMain.Create();
  GWorkerMain.FPreventMainThreadShutdown := APreventMainThreadShutdown;

  GWorkerMain.Start;
end;

procedure TWorkerMain.Start;
var
  LWorkers: TArray<TWorkerConfig>;
  LWorker: TWorkerConfig;
begin
  LWorkers := TWorkerRegistry.GetInstance.GetWorkers;
  var LQtdWorkers := 0;
  for var I := 0 to Pred(Length(LWorkers)) do
  begin
    LWorker := LWorkers[I];
    LWorker.ArrayIndex := I;

    if (not LWorker.Enabled) or not Assigned(LWorker.Proc) then
    begin
      {$IFDEF CONSOLE}
      Writeln(Format('Worker "%s" will not start', [LWorker.Name]));
      {$ENDIF}
      Continue;
    end;

    {$IFDEF CONSOLE}
    Writeln(Format('Starting Worker "%s" with interval %d', [LWorker.Name, LWorker.Interval]));
    {$ENDIF}

    TTask.Run(LWorker, ExecuteTask);

    Inc(LQtdWorkers);
  end;

  {$IFDEF CONSOLE}
  Writeln(Format('Workers Started: %d', [LQtdWorkers]));
  {$ENDIF}

  if FPreventMainThreadShutdown then
  begin
    //Sleep(INFINITE);
    {$IFDEF CONSOLE}
    Writeln('Prevent main thread shutdown. Press any key to close.');
    {$ENDIF}
    Readln;
  end;
end;

class destructor TWorkerMain.Unitialize;
begin
  if Assigned(GWorkerMain) then
    FreeAndNil(GWorkerMain);

  inherited;
end;

end.
