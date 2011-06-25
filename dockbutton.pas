unit DockButton;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Buttons,
  contnrs;

type

  { TDockButton }

  { TDockProcess }

  TDockProcess = class
  private
    FActive: boolean;
    FCaption: string;
    FPID: longword;
    procedure SetActive(const AValue: boolean);
    procedure SetCaption(const AValue: string);
  public
    constructor Create(const PID: longword);
    destructor Destroy; override;
    property PID: longword read FPID;
    property Caption: string read FCaption write SetCaption;
    property Active: boolean read FActive write SetActive;
  end;

  TDockButton = class(TSpeedButton)
  private
    FOrder: integer;
    FPath: string;
    FProcesses: TObjectList;
    function GetCount: integer;
    function GetProcesses(index: integer): TDockProcess;
    procedure SetOrder(const AValue: integer);
    procedure SetPath(const AValue: string);
    { Private declarations }
  protected
    procedure OnClickHandler(Sender: TObject);
  public
    constructor Create(TheOwner: TComponent; const APath: string;
      const AOrder: integer); reintroduce;
    property Path: string read FPath write SetPath;
    property Order: integer read FOrder write SetOrder;
    property Processes[index: integer]: TDockProcess read GetProcesses;
    procedure AddProcess(const PID: longword);
    procedure BeginUpdate;
    procedure EndUpdate;
    destructor Destroy; override;
    property Count: integer read GetCount;
  published
    { Published declarations }
  end;

procedure Register;

implementation

uses Windows, DockPanel, Menus;

procedure Register;
begin
  RegisterComponents('Dock', [TDockButton]);
end;

{ TDockProcess }

procedure TDockProcess.SetActive(const AValue: boolean);
begin
  if FActive = AValue then
    exit;
  FActive := AValue;
end;

procedure TDockProcess.SetCaption(const AValue: string);
begin
  if not Active then
  begin
    Active := True;
    if FCaption = AValue then
      exit;
    FCaption := AValue;
  end;
end;

constructor TDockProcess.Create(const PID: longword);
begin
  FPID := PID;
  Active := true;
end;

destructor TDockProcess.Destroy;
begin
  inherited Destroy;
end;

{ TDockButton }

procedure TDockButton.SetPath(const AValue: string);
var
  icon: TIcon;
begin
  if FPath = AValue then
    exit;
  if not FileExists(AValue) then
    exit;
  FPath := AValue;
  // Получение значка приложения
  icon := TIcon.Create;
  icon.Handle := ExtractIcon(HINSTANCE, PChar(AValue), 0);
  self.Glyph.BitmapHandle := icon.BitmapHandle;
  FreeAndNil(icon);
end;
function EnumWindowsProc(hWnd: THANDLE; pBtn: LongInt): longbool; stdcall;
var
  WindowPID: LongWord;
  Style: LongWord;
  db: TDockButton;
  idx, cnt: integer;
begin
  if (GetWindowLong(hWnd, GWL_STYLE) and WS_VISIBLE) <> 0 then
  begin
    db := TDockButton(pointer(pBtn)^);
	  GetWindowThreadProcessId(hWnd, WindowPID);
    cnt := db.FProcesses.Count - 1;
    for idx := 0 to cnt do
	    if WindowPID = db.Processes[idx].PID then
      begin
        //ShowWindow(hWnd, SW_RESTORE);
        ShowWindow(hWnd, SW_SHOW);
        SetForegroundWindow(hWnd);

      end;
  end;
  Result := true;
end;

procedure TDockButton.OnClickHandler(Sender: TObject);
begin
  EnumWindows(@EnumWindowsProc, LongWord(@self));
end;

procedure TDockButton.SetOrder(const AValue: integer);
begin
  FOrder := AValue;
  Left := ((Owner as TDockPanel).ButtonSize + 4) * FOrder;
  Width := (Owner as TDockPanel).ButtonSize + 4;
  Height := (Owner as TDockPanel).ButtonSize + 4;
end;

function TDockButton.GetProcesses(index: integer): TDockProcess;
begin
  Result := TDockProcess(FProcesses[index]);
end;

function TDockButton.GetCount: integer;
begin
  Result := FProcesses.Count;
end;

constructor TDockButton.Create(TheOwner: TComponent; const APath: string;
  const AOrder: integer);
begin
  inherited Create(TheOwner);
  FProcesses := TObjectList.create(true);
  //ShowMessage('Order: '+IntToStr(AOrder));
  Flat := True;
  Layout := blGlyphTop;
  Path := APath;
  Order := AOrder;
  Parent := TWinControl(TheOwner);
  Caption := '';
  Hint := APath;
  ShowHint := True;
  OnClick := @OnClickHandler;
end;

procedure TDockButton.AddProcess(const PID: longword);
var
  idx, cnt: integer;
  pr: TDockProcess;
begin
  cnt := FProcesses.Count - 1;
  for idx := 0 to cnt do
    if Processes[idx].PID = PID then
    begin
      Processes[idx].Active := True;
      exit;
    end;
  pr := TDockProcess.Create(PID);
  FProcesses.Add(pr);

  Path:=Path;

	Hint := IntToStr(FProcesses.Count);
  ShowHint:=true;
end;

procedure TDockButton.BeginUpdate;
var
  idx, cnt: integer;
begin
  cnt := FProcesses.Count - 1;
  for idx := 0 to cnt do
    Processes[idx].Active := False;
end;

procedure TDockButton.EndUpdate;
var
  idx, cnt: integer;
begin
  idx := 0;
  while idx < FProcesses.Count do
    if not Processes[idx].Active then
      FProcesses.Delete(idx)
    else
      idx := idx + 1;
end;

destructor TDockButton.Destroy;
begin
  FreeAndNil(FProcesses);
  inherited Destroy;
end;

end.

