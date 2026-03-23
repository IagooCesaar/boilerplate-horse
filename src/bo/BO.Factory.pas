unit BO.Factory;

interface

uses
  BO.Intf;

type
  TBOFactory = class(TInterfacedObject, IBOFactory)
  public
    class function New: IBOFactory;

    { IBOFactory }
    function Example: IBOExample;
  end;

implementation

uses
  BO.Example;

{ TBOFactory }

function TBOFactory.Example: IBOExample;
begin
  Result := TBOExample.New;
end;

class function TBOFactory.New: IBOFactory;
begin
  Result := Self.Create;
end;

end.
