program IPvX;

uses
  Vcl.Forms,
  UI in 'UI.pas' {UIForm};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'IPvX';
  Application.HelpFile := 'IPvX.chm';
  Application.CreateForm(TUIForm, UIForm);
  Application.Run;
end.
