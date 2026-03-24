unit Infraestructure.Worker.Config;

interface

uses
  System.Generics.Collections, System.SysUtils, System.Classes, GBSwagger.Model.Attributes;

type
  TWorkerConfig = class
  private
    FName: string;
    FInterval: Integer;
    FProc: TProc;
    FEnabled: Boolean;
    FRunnable: Boolean;
    FArrayIndex: Integer;
    FRunnings: Integer;
    FSuccessfulRunnings: Integer;
    function GetRunnable: Boolean;
  public
    constructor Create(const AName: string; const AInterval: Integer; AProc: TProc; const AEnabled: Boolean = True);

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

function TWorkerConfig.GetRunnable: Boolean;
begin
  Result := (Self.Enabled) and Assigned(Self.Proc);
end;

constructor TWorkerConfig.Create(const AName: string; const AInterval: Integer; AProc: TProc; const AEnabled: Boolean);
begin
  FName := AName;
  FInterval := AInterval;
  FProc := AProc;
  FEnabled := AEnabled;
  FRunnings := 0;
  FSuccessfulRunnings := 0;
end;

end.
