unit Infraestructure.Worker.Config;

interface

uses
  System.Generics.Collections, System.SysUtils, System.Classes;

type
  TWorkerConfig = class
    public
      Nome: string;
      Intervalo: Integer;
      Proc: TProc;
      Enabled: Boolean;
      ArrayIndex: Integer;
      constructor Create(const ANome: string; const AIntervalo: Integer; AProc: TProc; const AEnabled: Boolean = True);
  end;

implementation

{ TWorkerConfig }

constructor TWorkerConfig.Create(const ANome: string; const AIntervalo: Integer; AProc: TProc; const AEnabled: Boolean);
begin
  Nome := ANome;
  Intervalo := AIntervalo;
  Proc := AProc;
  Enabled := AEnabled;
end;

end.
