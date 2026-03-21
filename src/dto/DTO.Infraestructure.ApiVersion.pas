unit DTO.Infraestructure.ApiVersion;

interface

uses
  Infraestructure.BaseClass;

type
  TDTOApiVersion = class(TInfraestructureBaseClass)
  private
    FVersion: string;
  public
    property Version: string read FVersion write FVersion;
  end;

implementation

end.
