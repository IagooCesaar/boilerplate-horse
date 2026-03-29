unit Infraestructure.Worker.DTO.Patch;

interface

type
  TWorkerDtoPatch = class
  private
    FEnable: Boolean;
  public
    property Enable: Boolean read FEnable write FEnable;
  end;

implementation

end.
