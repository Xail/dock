program dock;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, dock_form
  { you can add units after this };

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDockForm, DockForm);
  Application.Run;
end.

