unit fm_main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, Buttons, DockPanel;

type

  { TDockForm }

  TDockForm = class(TForm)
    DockPanel: TDockPanel;
    Timer1: TTimer;
    procedure DockPanelResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  protected
  public
    { public declarations }
  end;


var
  DockForm: TDockForm;

implementation

{$R *.lfm}

{ TDockForm }

procedure TDockForm.FormCreate(Sender: TObject);
begin

end;

procedure TDockForm.DockPanelResize(Sender: TObject);
begin
  Resize;
end;

procedure TDockForm.FormResize(Sender: TObject);
begin
  Top := Screen.Height - Height;
  Left:= (Screen.Width - Width) div 2;
end;

procedure TDockForm.Timer1Timer(Sender: TObject);
begin
  DockPanel.InitButtons;
end;

end.

