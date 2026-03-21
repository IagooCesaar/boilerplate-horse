unit DTO.Infraestructure.ApiError;

interface

uses
  Infraestructure.BaseClass, Horse;

type
  TDTOApiError = class(TInfraestructureBaseClass)
  private
    FError: string;
    FStatus: THTTPStatus;
    FCode: Integer;
    FUnit: string;
  public
    property Error: string read FError write FError;
    property Status: THTTPStatus read FStatus write FStatus;
    property Code: Integer read FCode write FCode;
    property &Unit: string read FUnit write FUnit;
  end;

implementation

end.
