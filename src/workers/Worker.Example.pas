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

const
  WORKER_CONSOLE_KEY: TGUID = '{C6A043DA-399A-444E-966D-AD974A23E7FE}';
  WORKER_TEXT_KEY: TGUID = '{D73562BB-3465-4F46-8C3C-C71A3A273289}';
  WORKER_ERROR_KEY: TGUID = '{57C76A8A-023A-4342-936A-2F8250EB57DF}';

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
    WORKER_TEXT_KEY,
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
    WORKER_CONSOLE_KEY,
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
    WORKER_ERROR_KEY,
    'Worker Test ERROR',
    1000 * 20,
    procedure
    begin
      raise Exception.Create('Este é um erro controlado');
    end
  );
end;

end.
