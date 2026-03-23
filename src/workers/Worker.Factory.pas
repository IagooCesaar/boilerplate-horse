unit Worker.Factory;

interface

uses
  Worker.Intf;

type
  TWorkerFactory = class(TInterfacedObject, IWorkerFactory)
  public
    class function New: IWorkerFactory;

    { IWorkerFactory }
    function Registry: IWorkerFactory;
    function Run:IWorkerFactory;
    function GracefullShuttdown: IWorkerFactory;
  end;

implementation

uses
  Infraestructure.Worker.Registry, Infraestructure.Worker.Config, Worker.Example, Infraestructure.Worker.Main;

{ TWorkenFactory }

function TWorkerFactory.GracefullShuttdown: IWorkerFactory;
begin
  Result := Self;
  TWorkerMain.GracefullShuttdown;
end;

class function TWorkerFactory.New: IWorkerFactory;
begin
  Result := Self.Create;
end;

function TWorkerFactory.Registry: IWorkerFactory;
begin
  Result := Self;
  var LExampleWorkers := TWorkerExample.New.GetWorkers;
  for var LWorker in  LExampleWorkers do
  begin
    TWorkerRegistry.GetInstance.AddWorker(LWorker);
  end;
end;

function TWorkerFactory.Run: IWorkerFactory;
begin
  Result := Self;
  TWorkerMain.Run;
end;

end.
