unit DockPanel;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls
  ,contnrs, DockButton, windows;

type

  { TDockPanel }
  PDockPanel = ^TDockPanel;
  TDockPanel = class(TPanel)
  private
    FButtons: TObjectList;
    FButtonSize: integer;
    function GetButton(Index: integer): TDockButton;
    function GetCount: integer;
    procedure SetButtonSize(const AValue: integer);
  public
    procedure InitButtons;
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    property Buttons[Index: integer]:TDockButton read GetButton;
    property Count: integer read GetCount;
    procedure AddButton(const APath: string; const APID: LongWord;
    	const AHWND: LongWord; const ACaption: string);
  published
    property Caption;
		property ButtonSize: integer read FButtonSize write SetButtonSize;
    procedure Delete(Index: integer);
  end;

procedure Register;

implementation

uses JwaPsApi;

procedure Register;
begin
  RegisterComponents('Dock',[TDockPanel]);
end;

{ TDockPanel }

function TDockPanel.GetButton(Index: integer): TDockButton;
begin
  if (Index < 0) or (Index > FButtons.Count - 1) then
  	Result := nil
  else
	  Result := TDockButton(FButtons[Index]);
end;

function TDockPanel.GetCount: integer;
begin
  Result := FButtons.Count;
end;

procedure TDockPanel.SetButtonSize(const AValue: integer);
begin
  if FButtonSize=AValue then exit;
  FButtonSize:=AValue;
end;

procedure TDockPanel.AddButton(const APath: string; const APID: LongWord;
  const AHWND: LongWord; const ACaption: string);
var
	idx, cnt: integer;
  btn: TDockButton;
begin
	cnt := Count - 1;
  btn := nil;
  for idx := 0 to cnt do
		if TDockButton(FButtons[idx]).Path = APath then
    begin
      btn := TDockButton(FButtons[idx]);
      break;
    end;
  if btn = nil then
  begin
  	btn := TDockButton.Create(self, APath, Count);
    FButtons.Add(btn);
    Width:=Count * ButtonSize;
    Update;
  end;
  btn.AddProcess(APID);
end;

procedure TDockPanel.Delete(Index: integer);
var
  idx,cnt: integer;
  b: TDockButton;
begin
  idx := 0;
  while idx < Count do
  begin
    b := TDockButton(FButtons[idx]);
    if b.Order = Index then
    	FButtons.Delete(idx)
    else
    begin
	    if b.Order > Index then
  	  	b.Order := b.Order - 1;
      idx := idx + 1;
    end;
  end;
end;

function EnumWindowProc(hWnd: THANDLE; lParam: LongInt): longbool; stdcall;
var
  dp: PDockPanel;
  style: LongWord;
  caption: PWCHAR;
  caption_size: integer;
  PID: LongWord;
  pHandle: THANDLE;
  mHandle: THANDLE;
  cb: LongWord;
  ModuleName: array [0..1024] of CHAR;
begin
  // Создаем ссылку на док
	dp := PDockPanel(lParam);
  // Получаем заголовок окна
  caption_size := GetWindowTextLengthW(hWnd);
  caption := GetMem(caption_size * sizeof(PWCHAR));
  GetWindowTextW(hWnd, caption, caption_size);
  // Получаем стиль окна
	style := GetWindowLong(hWnd, GWL_STYLE);
  //Ищем подходящие окна
  if (style and WS_VISIBLE) <> 0 then
  begin
  	// получаем информацию о процессе
    GetWindowThreadProcessId(hWnd, PID);
    pHandle:=OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ,false,PID);
    if pHandle > 0 then
    begin
	    EnumProcessModules(pHandle, @mHandle, sizeof(mHandle), cb);
      GetModuleFileNameEx(pHandle, mHandle, ModuleName, sizeof(ModuleName));
      CloseHandle(pHandle);
      if string(ModuleName) <> Application.ExeName then
	      dp^.AddButton(string(ModuleName), PID, hWnd, caption);
      // Итого: хэндл окна, идентификатор процесса, путь к программе
    end;
  end;
  Freemem(caption, caption_size);
  Result := true;
end;

procedure TDockPanel.InitButtons;
var
  idx, cnt: integer;
begin
  cnt := Count - 1;
	Perform(WM_SETREDRAW,0,0);
  for idx := 0 to cnt do
    Buttons[idx].BeginUpdate;
  EnumWindows(@EnumWindowProc, LongWord(@self));
  for idx := 0 to cnt do
    Buttons[idx].EndUpdate;

  idx := 0;
  while idx < Count do
  	if Buttons[idx].Count = 0 then
    	Delete(Buttons[idx].Order)
    else
      idx := idx + 1;

	Perform(WM_SETREDRAW,1,0);
end;

constructor TDockPanel.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  ButtonSize:=48;
  FButtons := TObjectList.create(true);
  //PIdx := 0;
  InitButtons;
end;

destructor TDockPanel.Destroy;
begin
  FreeAndNil(FButtons);
  inherited Destroy;
end;

end.
