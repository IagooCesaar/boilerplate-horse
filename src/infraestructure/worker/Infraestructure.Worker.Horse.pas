unit Infraestructure.Worker.Horse;

interface

uses
  Horse;

function WorkerCallback: THorseCallback; overload;
function WorkerCallback(const AContext: string): THorseCallback; overload;

implementation

uses
  System.JSON, Infraestructure.Worker.Registry, Horse.JsonInterceptor.Helpers, System.Generics.Collections,
  Infraestructure.Worker.Config, Horse.GBSwagger, Infraestructure.Worker.DTO.Patch;

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

procedure PatchWorker(ARequest: THorseRequest; AResponse: THorseResponse; ANext: TProc);
begin
  if ARequest.Body = '' then
    raise EHorseException.New
      .Status(THTTPStatus.BadRequest)
      .Error('O body não estava no formato esperado');

  var LKey := ARequest.Params.Field('key')
    .Required
    .RequiredMessage('UUID identificador do Worker é obrigatório')
    .AsString;

  var LDto := TJson.ClearJsonAndConvertToObject<TWorkerDtoPatch>(ARequest.Body);
  try
    if not TWorkerRegistry.GetInstance.EnableWorker(LKey, LDto.Enable) then
      AResponse.Status(THTTPStatus.NotFound)
    else
      AResponse.Status(THTTPStatus.OK);
  finally
    LDto.Free;
  end;
end;

procedure PatchAllWorkers(ARequest: THorseRequest; AResponse: THorseResponse; ANext: TProc);
begin
  TWorkerRegistry.GetInstance.DisableAllWorkers;
end;

function WorkerCallback: THorseCallback; overload;
begin
  Result := WorkerCallback('');
end;

function WorkerCallback(const AContext: string): THorseCallback;
begin
  THorse.GetInstance
    .Get(AContext + '/workers', GetWorkers)
    .Patch(AContext + '/workers/:key', PatchWorker)
    .Patch(AContext + '/workers/disable-all', PatchAllWorkers);

  Swagger
    .Path('/workers')
    .Tag('Workers')
      .GET
        .AddResponse(200).Schema(TWorkerConfig).IsArray(True).&End
        .AddResponse(204).&End
      .&End
    .&End
    .Path('/workers/{key}')
    .Tag('Workers')
      .PATCH
        .AddParamPath('key', 'UUID identificador do Worker').&End
        .AddParamBody('body').Schema(TWorkerDtoPatch).IsArray(False).&End
        .AddResponse(200).&End
        .AddResponse(404).&End
      .&End
    .&End
    .Path('/workers/disable-all')
    .Tag('Workers')
      .PATCH
        .AddResponse(200).&End
        .AddResponse(404).&End
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
