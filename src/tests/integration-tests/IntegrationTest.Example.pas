unit IntegrationTest.Example;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TIntegrationTestExample = class
  public
    [Test]
    procedure TestExample;
  end;

implementation

uses
  IntegrationTest.Config, Horse;

{ TIntegrationTestExample }

procedure TIntegrationTestExample.TestExample;
begin
  var LResponse := TIntegrationTestConfig.GetInstance.DefaultRequest
    .Resource('\example')
    .Get;

  Assert.AreEqual<Integer>(Integer(THTTPStatus.OK), LResponse.StatusCode);
end;

initialization
  TDUnitX.RegisterTestFixture(TIntegrationTestExample);

end.
