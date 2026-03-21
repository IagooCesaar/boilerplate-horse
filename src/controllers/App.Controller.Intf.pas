unit App.Controller.Intf;

interface

type
  IAppController = interface
    ['{39DD0A47-4BDD-4313-A2BD-C350759FDD98}']
    function Registry(const AContext: string): IAppController;
    function SwaggerDefinition(const AContext: string): IAppController;
  end;

implementation

end.
