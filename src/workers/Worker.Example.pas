unit Worker.Example;

interface

uses
  Infraestructure.Worker.Intf, Infraestructure.Worker.Config;

type
  TWorkerExample = class(TInterfacedObject, IWorkerFacade)
  private
    function WorkerTXT: TWorkerConfig;
    function WorkerCONSOLE: TWorkerConfig;
    function WorkerERROR: TWorkerConfig;
  public
    class function New: IWorkerFacade;

    { IWorkerFacade }
    function GetWorkers: TArray<TWorkerConfig>;
  end;

implementation

uses
  BO.Factory, System.SysUtils;

{ TWorkerExample }

function TWorkerExample.GetWorkers: TArray<TWorkerConfig>;
begin
  SetLength(Result, 3);
  Result[0] := WorkerCONSOLE;
  Result[1] := WorkerTXT;
  Result[2] := WorkerERROR;
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

function TWorkerExample.WorkerERROR: TWorkerConfig;
begin
  Result :=  TWorkerConfig.Create(
    'Worker Test ERROR',
    1000 * 20,
    procedure
    begin
      raise Exception.Create('Este é um erro controlado');
    end
  );
end;

end.
