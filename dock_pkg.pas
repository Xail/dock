{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit dock_pkg; 

interface

uses
  DockPanel, DockButton, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('DockPanel', @DockPanel.Register); 
  RegisterUnit('DockButton', @DockButton.Register); 
end; 

initialization
  RegisterPackage('dock_pkg', @Register); 
end.
