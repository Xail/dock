unit un_launch_panel;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ExtCtrls, un_launch_button, contnrs;

type

  { TLaunchPanel }

  TLaunchPanel = class(TCustomPanel)
  private
    FButtons: TObjectList;
    function GetButtons(Index: integer): TLaunchButton;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;override;
    procedure AddWindow(const APath: string; const APID: LongWord; const AHandle: LongWord);
    property Buttons[Index: integer]: TLaunchButton read GetButtons;
  end;

implementation

{ TLaunchPanel }

function TLaunchPanel.GetButtons(Index: integer): TLaunchButton;
begin
  Result := TLaunchButton(FButtons[Index]);
end;

constructor TLaunchPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FButtons := TObjectList.create(true);
end;

destructor TLaunchPanel.Destroy;
begin
  FreeAndNil(FButtons);
  inherited Destroy;
end;

procedure TLaunchPanel.AddWindow(const APath: string; const APID: LongWord;
  const AHandle: LongWord);
begin

end;

end.

