unit Service.Intf;

interface

uses
  Repository.Intf, Data.DB;

type
  IServiceExample = interface
    ['{BB9B7F5C-8D75-4121-9301-420BDFC38BC0}']
    function GetDados: TDataSet;
  end;

  IServiceFactory = interface
    ['{789FFF21-A6E3-414C-8331-AAE6D874ACFE}']
    function Example(const ARepoFactory: IRepositoryFactory): IServiceExample;
  end;

implementation

end.
