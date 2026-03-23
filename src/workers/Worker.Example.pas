unit Worker.Example;

interface

uses
  Worker.Intf, Infraestructure.Worker.Config;

type
  TWorkerExample = class(TInterfacedObject, IWorkerFacade)
  private
    function PrepareWorker1: TWorkerConfig;
    function PrepareWorker2: TWorkerConfig;
  public
    class function New: IWorkerFacade;

    { IWorkerFacade }
    function GetWorkers: TArray<TWorkerConfig>;
  end;

implementation

uses
  BO.Factory;

{ TWorkerExample }

function TWorkerExample.GetWorkers: TArray<TWorkerConfig>;
begin
  SetLength(Result, 2);
  Result[0] := PrepareWorker1;
  Result[1] := PrepareWorker2;
end;

class function TWorkerExample.New: IWorkerFacade;
begin
  Result := Self.Create;
end;

function TWorkerExample.PrepareWorker1: TWorkerConfig;
begin
  Result := TWorkerConfig.Create(
    'Worker Test TXT',
    1000 * 10,
    procedure
    begin
      TBOFactory.New.Example.WriteOnTextFile;
    end
  );
end;

function TWorkerExample.PrepareWorker2: TWorkerConfig;
begin
  Result :=  TWorkerConfig.Create(
    'Worker Test CONSOLE',
    1000 * 15,
    procedure
    begin
      TBOFactory.New.Example.WriteOnConsole;
    end
  );
end;

end.
