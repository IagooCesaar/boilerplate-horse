unit Infraestructure.Worker.Main;

interface

type
  TWorkerMain = class
  private
    class var FGracefullShutdown: Boolean;
  public
    class procedure Run(const APreventMainThreadShutdown: Boolean = false);
    class procedure GracefullShutdown;
  end;

implementation

uses
  Infraestructure.Worker.Registry, System.Threading, System.SysUtils;

{ TWorkerMain }

class procedure TWorkerMain.GracefullShutdown;
begin
  FGracefullShutdown := True;
end;

class procedure TWorkerMain.Run(const APreventMainThreadShutdown: Boolean);
begin
  FGracefullShutdown := False;
  var LWorkers := TWorkerRegistry.GetInstance.GetWorkers;
  var LQtdWorkers := 0;
  for var LWorker in LWorkers do
  begin
    if (not LWorker.Enabled) or not(Assigned(LWorker.Proc)) then
    begin
      {$IFDEF CONSOLE}
      Writeln(Format('Worker "%s" will not start', [LWorker.Nome]));
      {$ENDIF}
      Continue;
    end;

    {$IFDEF CONSOLE}
    Writeln(Format('Starting Worker "%s" with interval %d', [LWorker.Nome, LWorker.Intervalo]));
    {$ENDIF}
    TTask.Run(
      procedure
      begin
        while not FGracefullShutdown do
        begin
          try
            LWorker.Proc();
          except
            on E: Exception do
              Writeln(Format('[%s] ERRO: %s', [LWorker.Nome, E.Message]));
          end;

          Sleep(LWorker.Intervalo);  // Enquanto ocioso, libera recursos pra outras tasks
        end;
      end
    );
    Inc(LQtdWorkers);
  end;

  {$IFDEF CONSOLE}
  Writeln(Format('Workers Started: %d', [LQtdWorkers]));
  {$ENDIF}

  if APreventMainThreadShutdown then
  begin
    //Sleep(INFINITE);
    {$IFDEF CONSOLE}
    Writeln('Prevent main thread shutdown. Press any key to close.');
    {$ENDIF}
    Readln;
  end;
end;

end.
