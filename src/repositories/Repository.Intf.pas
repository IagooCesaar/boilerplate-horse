unit Repository.Intf;

interface

uses
  Data.DB;

type
  IRepositoryExample = interface
    ['{4365FB44-5B01-4C6B-A810-6E8EE03A6B5C}']
    function GetDados: TDataSet;
  end;

  IRepositoryFactory = interface
    ['{9F8A6285-4542-40B9-885F-C592E35AEDD4}']
    function Example: IRepositoryExample;
  end;

implementation

end.
