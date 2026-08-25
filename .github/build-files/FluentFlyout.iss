; Inno Setup script for the unpackaged (non-MSIX) FluentFlyout build.
; Build the payload first:
;   dotnet publish FluentFlyoutWPF/FluentFlyout.csproj -c "GitHub Release" -r win-x64 \
;     --self-contained true -p:Platform=x64 -p:Version=<ver> -p:DebugType=none -o publish
; Then compile:
;   ISCC.exe /DMyAppVersion=<ver> .github\build-files\FluentFlyout.iss

#ifndef MyAppVersion
  #define MyAppVersion "2.14.0"
#endif
#define MyAppName "FluentFlyout"
#define MyAppPublisher "The FluentFlyout Authors"
#define MyAppURL "https://fluentflyout.com"
#define MyAppExeName "FluentFlyout.exe"

[Setup]
AppId={{8F3C1A64-1D9E-4B7A-9C2F-2E5D7A1B6C40}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL=https://github.com/unchihugo/FluentFlyout/issues
AppUpdatesURL=https://github.com/unchihugo/FluentFlyout/releases
VersionInfoVersion={#MyAppVersion}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
LicenseFile=..\..\LICENSE
OutputDir=..\..\installer
OutputBaseFilename=FluentFlyout-{#MyAppVersion}-x64-setup
SetupIconFile=..\..\FluentFlyoutWPF\Resources\FluentFlyout2.ico
UninstallDisplayIcon={app}\{#MyAppExeName}
UninstallDisplayName={#MyAppName} {#MyAppVersion}
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
; per-user install, so no UAC prompt is needed
PrivilegesRequired=lowest
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
MinVersion=10.0.22000
; the app lives in the tray, so shut it down before replacing its files
CloseApplications=yes
CloseApplicationsFilter=*.exe,*.dll

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "..\..\publish\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
; logs and settings written next to the executable, if any
Type: filesandordirs; Name: "{app}\logs"

[Code]
// the app registers itself for autostart from its own settings page;
// drop that entry on uninstall so nothing points at a removed executable
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usPostUninstall then
    RegDeleteValue(HKCU, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Run', 'FluentFlyout');
end;
