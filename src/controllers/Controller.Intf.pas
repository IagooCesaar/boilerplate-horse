unit Controller.Intf;

interface

type
  IController = interface
    ['{39DD0A47-4BDD-4313-A2BD-C350759FDD98}']
    function Registry(const AContext: string): IController;
    function SwaggerDefinition(const AContext: string): IController;
  end;

implementation

end.
