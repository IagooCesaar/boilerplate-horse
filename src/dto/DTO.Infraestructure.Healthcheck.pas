unit DTO.Infraestructure.Healthcheck;

interface

uses
  Infraestructure.BaseClass;

type
  TDTOHealthcheck = class(TInfraestructureBaseClass)
  private
    FHealthcheck: Boolean;
  public
    constructor Create(AValue: Boolean = True);
    property Healthcheck: Boolean read FHealthcheck write FHealthcheck;
  end;

implementation

{ TDTOHealthcheck }

constructor TDTOHealthcheck.Create(AValue: Boolean);
begin
  FHealthcheck := AValue;
end;

end.
