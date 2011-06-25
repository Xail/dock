program dock;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, fm_main, un_launch_panel, un_launch_button, dock_pkg;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDockForm, DockForm);
  Application.Run;
end.

