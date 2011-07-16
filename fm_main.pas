unit fm_main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, Buttons, DockPanel, Windows;

type

  { TDockForm }

  TDockForm = class(TForm)
    DockPanel: TDockPanel;
    Panel1: TPanel;
    Timer1: TTimer;
    procedure DockPanelResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
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
  SetWindowLong(Self.Handle, GWL_EXSTYLE, WS_EX_TRANSPARENT or WS_EX_LAYERED);
  SetLayeredWindowAttributes(Self.Handle, 0, 255, LWA_ALPHA);
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

procedure TDockForm.Panel1Click(Sender: TObject);
begin
  SendMessage(Handle, WM_SYSCOMMAND, SC_TASKLIST, word(Mouse.CursorPos.x) +
  	word(Mouse.CursorPos.y << 16));
end;

procedure TDockForm.Timer1Timer(Sender: TObject);
begin
  if (Mouse.CursorPos.X >= Left) and (Mouse.CursorPos.X <= Width+Left+1) and
     (Mouse.CursorPos.Y >= Top) and (Mouse.CursorPos.Y <= Height+Top+1) then
    SetLayeredWindowAttributes(Self.Handle, 0, 200, LWA_ALPHA)
  else
    SetLayeredWindowAttributes(Self.Handle, 0, 255, LWA_ALPHA);
end;

end.

