unit Infraestructure.Worker.Factory;

interface

uses
  Infraestructure.Worker.Intf, Infraestructure.Worker.Config;

type
  TWorkerFactory = class(TInterfacedObject, IWorkerFactory)
    procedure AddWorkers(const AWorkers: TArray<TWorkerConfig>);
  public
    class function New: IWorkerFactory;

    { IWorkerFactory }
    function Registry: IWorkerFactory;
    function Run:IWorkerFactory;
    function GracefullShuttdown: IWorkerFactory;
  end;

implementation

uses
  Infraestructure.Worker.Registry, Infraestructure.Worker.Main, Worker.Example;

{ TWorkenFactory }

procedure TWorkerFactory.AddWorkers(const AWorkers: TArray<TWorkerConfig>);
begin
  for var LWorker in  AWorkers do
  begin
    TWorkerRegistry.GetInstance.AddWorker(LWorker);
  end;
end;

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
  AddWorkers(TWorkerExample.New.GetWorkers);
end;

function TWorkerFactory.Run: IWorkerFactory;
begin
  Result := Self;
  TWorkerMain.Run;
end;

end.
