unit dock_form;
{
Задача
1. Найти видимые главные окна, имеющие название  WS_EX_CONTROLPARENT WS_VISIBLE WS_EX_APPWINDOW
2. Отобразить их на панели
3. При выборе кнопки на панели активировать соответствующее окно.
}
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ActnList,
  ComCtrls, ExtCtrls, Windows;

type
	TEnumWindowProc = function (wnd_handle: HWND; low_param: LPARAM): longbool; stdcall;
  { TDockForm }

  TDockForm = class(TForm)
    get_applications: TAction;
    dock_actions: TActionList;
    dock_toolbar: TToolBar;
    refresh_timer: TTimer;
    procedure get_applicationsExecute(Sender: TObject);
  private
  	is_enumerating: bool;
  public
    { public declarations }
  end; 

var
  DockForm: TDockForm;

implementation

{$R *.lfm}
function EnumWindowProc(wnd_handle: HWND; low_param: LPARAM): longbool; stdcall;
var
  style: LONG;
  text_length: long;
  text: array [0..max_path] of widechar;
begin
  //showmessage(IntToStr(wnd_handle));
  style := GetWindowLong(wnd_handle, GWL_EXSTYLE);
  if (style and WS_EX_CONTROLPARENT) <> 0 then
 	begin
    //text_length:=GetWindowTextLengthW(wnd_handle);
    //if text_length > 0 then
    begin
      //text := GetMemory(sizeof(WideChar) * text_length + 1);
      SendMessage(wnd_handle, WM_GETTEXT, sizeof(text), longint(@text));
      GetWindowTextW(wnd_handle, @text, sizeof(text));
      MessageBoxW(wnd_handle, @text, '',0);
      //Freememory(text,sizeof(WideChar) * text_length + 1);
    end;
  end;
  Result := true;
end;
{ TDockForm }

procedure TDockForm.get_applicationsExecute(Sender: TObject);
begin
	if is_enumerating = true then
  	exit;
  is_enumerating:=true;
	EnumWindows(@EnumWindowProc, long_ptr(@self));
  is_enumerating:=false;
end;

end.

