program boilerplate_backend;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  App in 'src\App.pas',
  App.Controller.Intf in 'src\controllers\App.Controller.Intf.pas',
  App.Controller.Factory in 'src\controllers\App.Controller.Factory.pas',
  App.Controller.Infraestructure in 'src\controllers\App.Controller.Infraestructure.pas',
  DTO.Infraestructure.Healthcheck in 'src\dto\DTO.Infraestructure.Healthcheck.pas',
  Infraestructure.BaseClass in 'src\infraestructure\Infraestructure.BaseClass.pas',
  DTO.Infraestructure.ApiVersion in 'src\dto\DTO.Infraestructure.ApiVersion.pas',
  DTO.Infraestructure.ApiError in 'src\dto\DTO.Infraestructure.ApiError.pas';

begin
  var App := TApp.Create;
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
