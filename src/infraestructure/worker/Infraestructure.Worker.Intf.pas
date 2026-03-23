unit Infraestructure.Worker.Intf;

interface

uses
  Infraestructure.Worker.Config;

type
  IWorkerFacade = interface
    ['{60C10321-2C7F-4992-B8D4-936721CAC36B}']
    function GetWorkers: TArray<TWorkerConfig>;
  end;

  IWorkerFactory = interface
    ['{0797A7C9-BCC8-46CD-B351-376890440504}']
    function Registry: IWorkerFactory;
    function Run: IWorkerFactory;
    function GracefullShuttdown: IWorkerFactory;
  end;

implementation

end.
