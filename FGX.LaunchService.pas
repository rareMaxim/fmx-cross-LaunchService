{ *********************************************************************
  *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * Autor: Brovin Y.D.
 * E-mail: y.brovin@gmail.com
 *
 ******************************************************************** }

unit FGX.LaunchService;

interface

uses
  System.Classes, System.UITypes;

type

  IFGXLaunchService = interface
    ['{5BFFA845-EB02-480C-AFE9-EB15DE06AF10}']
    function OpenURL(const AUrl: string): Boolean;
  end;

  TFGXLaunchService = class(TInterfacedObject, IFGXLaunchService)
  private
    FLaunchService: IFGXLaunchService;
  public
    function OpenURL(const AUrl: string): Boolean;
    constructor Create;
    destructor Destroy; override;
    class function OPEN_URL(const AUrl: string): Boolean;
  end;

implementation

uses
  FMX.Platform
{$IFDEF MSWINDOWS}
    , FGX.LaunchService.Win
{$ENDIF}
{$IFDEF IOS}
    , FGX.LaunchService.iOS
{$ELSE}
{$IFDEF MACOS}
    , FGX.LaunchService.Mac
{$ENDIF}
{$ENDIF}
{$IFDEF ANDROID}
    , FGX.LaunchService.Android
{$ENDIF}
    ;
{ TFGXLaunchService }

constructor TFGXLaunchService.Create;
begin
  TPlatformServices.Current.SupportsPlatformService(IFGXLaunchService, FLaunchService);
end;

destructor TFGXLaunchService.Destroy;
begin
  FLaunchService := nil;
  inherited Destroy;
end;

function TFGXLaunchService.OpenURL(const AUrl: string): Boolean;
begin
  if FLaunchService <> nil then
    Result := FLaunchService.OpenURL(AUrl)
  else
    Result := False;
end;

class function TFGXLaunchService.OPEN_URL(const AUrl: string): Boolean;
var
  LLauncher: IFGXLaunchService;
begin
  LLauncher := TFGXLaunchService.Create;
  Result := LLauncher.OpenURL(AUrl);
end;

initialization

RegisterService;

finalization

UnregisterService;

end.
