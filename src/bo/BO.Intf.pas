unit BO.Intf;

interface

type
  IBOExample = interface
    ['{CFC15DCF-4F50-4388-961D-46BEB312BA36}']
    procedure WriteOnConsole;
    procedure WriteOnTextFile;
  end;

  IBOFactory = interface
    ['{6FADADD1-10CD-4E09-8D8C-C4CE998B4600}']
    function Example: IBOExample;
  end;

implementation

end.
