unit UnitTest.Example;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TUnitTestExample = class
  public
    [Test]
    procedure TestExample;
  end;

implementation

uses
  Repository.InMemory.Factory, Service.Factory;


{ TUnitTestExample }

procedure TUnitTestExample.TestExample;
begin
  var LRepoFactory := TRepositoryInMemoryFactory.GetInstance;

  var LDados := TServiceFactory.New
    .Example(LRepoFactory)
    .GetDados;

  Assert.IsTrue(Assigned(LDados));
  LDados.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TUnitTestExample);

end.
