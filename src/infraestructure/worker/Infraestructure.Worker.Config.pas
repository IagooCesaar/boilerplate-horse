unit Infraestructure.Worker.Config;

interface

uses
  System.Generics.Collections, System.SysUtils, System.Classes;

type
  TWorkerConfig = class
  private

    FInterval: Integer;
    FName: string;
    FProc: TProc;
    FEnabled: Boolean;
    FArrayIndex: Integer;
  public
    constructor Create(const AName: string; const AInterval: Integer; AProc: TProc; const AEnabled: Boolean = True);

    property Name: string read FName write FName;
    property Interval: Integer read FInterval write FInterval;
    property Proc: TProc read FProc write FProc;
    property Enabled: Boolean read FEnabled write FEnabled;
    property ArrayIndex: Integer read FArrayIndex write FArrayIndex;
  end;

implementation

{ TWorkerConfig }

constructor TWorkerConfig.Create(const AName: string; const AInterval: Integer; AProc: TProc; const AEnabled: Boolean);
begin
  FName := AName;
  FInterval := AInterval;
  FProc := AProc;
  FEnabled := AEnabled;
end;

end.
