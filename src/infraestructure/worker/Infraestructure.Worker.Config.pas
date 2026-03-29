unit Infraestructure.Worker.Config;

interface

uses
  System.Generics.Collections, System.SysUtils, System.Classes, GBSwagger.Model.Attributes;

type
  TWorkerConfig = class
  private
    FKey: string;
    FName: string;
    FInterval: Integer;
    FProc: TProc;
    FEnabled: Boolean;
    FRunnable: Boolean;
    FArrayIndex: Integer;
    FRunnings: Integer;
    FSuccessfulRunnings: Integer;
    function GetRunnable: Boolean;
    procedure SetKey(const Value: string);
  public
    constructor Create(const AName: string; const AInterval: Integer; AProc: TProc;
      const AEnabled: Boolean = True); overload;
    constructor Create(const AKey: TGUID; const AName: string; const AInterval: Integer; AProc: TProc;
      const AEnabled: Boolean = True); overload;

    property Key: string read FKey write SetKey;
    property Name: string read FName write FName;
    property Interval: Integer read FInterval write FInterval;
    [SwagIgnore]
    property Proc: TProc read FProc write FProc;
    property Enabled: Boolean read FEnabled write FEnabled;
    property ArrayIndex: Integer read FArrayIndex write FArrayIndex;
    property Runnings: Integer read FRunnings write FRunnings;
    property SuccessfulRunnings: Integer read FSuccessfulRunnings write FSuccessfulRunnings;
    property Runnable: Boolean read GetRunnable;
  end;

implementation

{ TWorkerConfig }

constructor TWorkerConfig.Create(const AKey: TGUID; const AName: string; const AInterval: Integer; AProc: TProc;
  const AEnabled: Boolean);
begin
  SetKey(AKey.ToString);
  FName := AName;
  FInterval := AInterval;
  FProc := AProc;
  FEnabled := AEnabled;
  FRunnings := 0;
  FSuccessfulRunnings := 0;
end;

constructor TWorkerConfig.Create(const AName: string; const AInterval: Integer; AProc: TProc; const AEnabled: Boolean);
begin
  var LKey := TGUID.NewGuid;
  Create(LKey, AName, AInterval, AProc, AEnabled);
end;

function TWorkerConfig.GetRunnable: Boolean;
begin
  Result := (Self.Enabled) and Assigned(Self.Proc);
end;

procedure TWorkerConfig.SetKey(const Value: string);
var
  LGuid: TGUID;
begin
  try
    LGuid := StringToGUID(Value);
  except
    raise Exception.Create('A chave do Worker deve ser um GUID válido');
  end;
  FKey := Value.Replace('{','').Replace('}','');
end;

end.
