unit Infraestructure.Worker.Horse;

interface

uses
  Horse;

function WorkerCallback: THorseCallback; overload;
function WorkerCallback(const AContext: string): THorseCallback; overload;

implementation

uses
  System.JSON, Infraestructure.Worker.Registry, Horse.JsonInterceptor.Helpers, System.Generics.Collections,
  Infraestructure.Worker.Config, Horse.GBSwagger;

procedure GetWorkers(ARequest: THorseRequest; AResponse: THorseResponse; ANext: TProc);
begin
  var LWorkers := TWorkerRegistry.GetInstance.GetWorkers;
  var LWorkersList := TObjectList<TWorkerConfig>.Create(False);
  for var LWorker in LWorkers do
    LWorkersList.Add(LWorker);

  if Length(LWorkers) = 0 then
    AResponse.Status(THTTPStatus.NoContent)
  else
    AResponse.Status(THTTPStatus.Ok).Send(TJson.ObjectToClearJsonString(LWorkersList)).ContentType('application/json');

  LWorkersList.Free;
end;

function WorkerCallback: THorseCallback; overload;
begin
  Result := WorkerCallback('');
end;

function WorkerCallback(const AContext: string): THorseCallback;
begin
  THorse.GetInstance.Get(AContext + '/workers', GetWorkers);

  Swagger
    .Path('/workers')
    .Tag('Workers')
      .GET
        .AddResponse(200).Schema(TWorkerConfig).IsArray(True).&End
        .AddResponse(204).&End
      .&End
    .&End
  .&End;

  Result := (
    procedure(ARequest: THorseRequest; AResponse: THorseResponse; ANext: TProc)
    begin
      ANext();
    end
  );
end;

end.
