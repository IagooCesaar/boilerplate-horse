unit Worker.Example;

interface

uses
  Worker.Intf, Infraestructure.Worker.Config;

type
  TWorkerExample = class(TInterfacedObject, IWorkerFacade)
  private
    function WorkerTXT: TWorkerConfig;
    function WorkerCONSOLE: TWorkerConfig;
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
  Result[0] := WorkerCONSOLE;
  Result[1] := WorkerTXT;
end;

class function TWorkerExample.New: IWorkerFacade;
begin
  Result := Self.Create;
end;

function TWorkerExample.WorkerTXT: TWorkerConfig;
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

function TWorkerExample.WorkerCONSOLE: TWorkerConfig;
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
