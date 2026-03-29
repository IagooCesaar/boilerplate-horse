program boilerplate_backend;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  App in 'src\App.pas',
  Controller.Intf in 'src\controllers\Controller.Intf.pas',
  Controller.Factory in 'src\controllers\Controller.Factory.pas',
  Controller.Infraestructure in 'src\controllers\Controller.Infraestructure.pas',
  DTO.Infraestructure.Healthcheck in 'src\dto\DTO.Infraestructure.Healthcheck.pas',
  Infraestructure.BaseClass in 'src\infraestructure\Infraestructure.BaseClass.pas',
  DTO.Infraestructure.ApiVersion in 'src\dto\DTO.Infraestructure.ApiVersion.pas',
  DTO.Infraestructure.ApiError in 'src\dto\DTO.Infraestructure.ApiError.pas',
  Infraestructure.DatabaseConfig.Intf in 'src\infraestructure\database-config\Infraestructure.DatabaseConfig.Intf.pas',
  Infraestructure.DatabaseConfig in 'src\infraestructure\database-config\Infraestructure.DatabaseConfig.pas',
  Infraestructure.DatabaseConfig.Provider.Ini in 'src\infraestructure\database-config\providers\Infraestructure.DatabaseConfig.Provider.Ini.pas',
  Infraestructure.Worker.Main in 'src\infraestructure\worker\Infraestructure.Worker.Main.pas',
  Infraestructure.Worker.Config in 'src\infraestructure\worker\Infraestructure.Worker.Config.pas',
  Infraestructure.Worker.Registry in 'src\infraestructure\worker\Infraestructure.Worker.Registry.pas',
  Service.Intf in 'src\services\Service.Intf.pas',
  Service.Factory in 'src\services\Service.Factory.pas',
  Repository.Intf in 'src\repositories\Repository.Intf.pas',
  Repository.InMemory.Factory in 'src\repositories\in-memory\Repository.InMemory.Factory.pas',
  Repository.Factory in 'src\repositories\oficial\Repository.Factory.pas',
  Repository.InMemory.Example in 'src\repositories\in-memory\Repository.InMemory.Example.pas',
  Repository.Example in 'src\repositories\oficial\Repository.Example.pas',
  Service.Example in 'src\services\Service.Example.pas',
  Controller.Example in 'src\controllers\Controller.Example.pas',
  BO.Intf in 'src\bo\BO.Intf.pas',
  BO.Factory in 'src\bo\BO.Factory.pas',
  BO.Example in 'src\bo\BO.Example.pas',
  Infraestructure.Worker.Intf in 'src\infraestructure\worker\Infraestructure.Worker.Intf.pas',
  Infraestructure.Worker.Factory in 'src\infraestructure\worker\Infraestructure.Worker.Factory.pas',
  Worker.Example in 'src\workers\Worker.Example.pas',
  Infraestructure.Worker.Horse in 'src\infraestructure\worker\Infraestructure.Worker.Horse.pas',
  Infraestructure.Worker.ExceptionHandler in 'src\infraestructure\worker\Infraestructure.Worker.ExceptionHandler.pas',
  Infraestructure.Worker.DTO.Patch in 'src\infraestructure\worker\Infraestructure.Worker.DTO.Patch.pas';

begin
  var App := TApp.GetInstance;
  try
    try
      App.Start(9000);
    except
      on E: Exception do
        Writeln(E.ClassName, ': ', E.Message);
    end;
  finally
    FreeAndNil(App)
  end;
end.
