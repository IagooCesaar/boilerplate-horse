program boilerplate_backend_test;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}
{$STRONGLINKTYPES ON}
uses
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ELSE}
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  {$ENDIF }
  DUnitX.TestFramework,
  App in 'src\App.pas',
  App.Controller.Example in 'src\controllers\App.Controller.Example.pas',
  App.Controller.Factory in 'src\controllers\App.Controller.Factory.pas',
  App.Controller.Infraestructure in 'src\controllers\App.Controller.Infraestructure.pas',
  App.Controller.Intf in 'src\controllers\App.Controller.Intf.pas',
  DTO.Infraestructure.ApiError in 'src\dto\DTO.Infraestructure.ApiError.pas',
  DTO.Infraestructure.ApiVersion in 'src\dto\DTO.Infraestructure.ApiVersion.pas',
  DTO.Infraestructure.Healthcheck in 'src\dto\DTO.Infraestructure.Healthcheck.pas',
  Infraestructure.BaseClass in 'src\infraestructure\Infraestructure.BaseClass.pas',
  Infraestructure.DatabaseConfig.Intf in 'src\infraestructure\database-config\Infraestructure.DatabaseConfig.Intf.pas',
  Infraestructure.DatabaseConfig in 'src\infraestructure\database-config\Infraestructure.DatabaseConfig.pas',
  Infraestructure.DatabaseConfig.Provider.Ini in 'src\infraestructure\database-config\providers\Infraestructure.DatabaseConfig.Provider.Ini.pas',
  Infraestructure.Worker.Config in 'src\infraestructure\worker\Infraestructure.Worker.Config.pas',
  Infraestructure.Worker.HandleException in 'src\infraestructure\worker\Infraestructure.Worker.HandleException.pas',
  Infraestructure.Worker.Main in 'src\infraestructure\worker\Infraestructure.Worker.Main.pas',
  Infraestructure.Worker.Registry in 'src\infraestructure\worker\Infraestructure.Worker.Registry.pas',
  Repository.Intf in 'src\repositories\Repository.Intf.pas',
  Repository.InMemory.Example in 'src\repositories\in-memory\Repository.InMemory.Example.pas',
  Repository.InMemory.Factory in 'src\repositories\in-memory\Repository.InMemory.Factory.pas',
  Repository.Example in 'src\repositories\oficial\Repository.Example.pas',
  Repository.Factory in 'src\repositories\oficial\Repository.Factory.pas',
  Service.Example in 'src\services\Service.Example.pas',
  Service.Factory in 'src\services\Service.Factory.pas',
  Service.Intf in 'src\services\Service.Intf.pas',
  IntegrationTest.Config in 'src\tests\integration-tests\IntegrationTest.Config.pas',
  UnitTest.Example in 'src\tests\unit-test\UnitTest.Example.pas',
  IntegrationTest.Example in 'src\tests\integration-tests\IntegrationTest.Example.pas';

{ keep comment here to protect the following conditional from being removed by the IDE when adding a unit }
{$IFNDEF TESTINSIGHT}
var
  runner: ITestRunner;
  results: IRunResults;
  logger: ITestLogger;
  nunitLogger : ITestLogger;
{$ENDIF}
begin
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
{$ELSE}

  {$IFDEF MSWINDOWS}
  IsConsole := False;
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  try
    //Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    //Create the test runner
    runner := TDUnitX.CreateRunner;
    //Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    //When true, Assertions must be made during tests;
    runner.FailsOnNoAsserts := True;

    //tell the runner how we will log things
    //Log to the console window if desired
    if TDUnitX.Options.ConsoleMode <> TDunitXConsoleMode.Off then
    begin
      logger := TDUnitXConsoleLogger.Create(TDUnitX.Options.ConsoleMode = TDunitXConsoleMode.Quiet);
      runner.AddLogger(logger);
    end;
    //Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);

    //Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
    TDUnitX.Options.ExitBehavior := TDUnitXExitBehavior.Pause;

    //We don't want this happening when running under CI.
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
{$ENDIF}
end.
