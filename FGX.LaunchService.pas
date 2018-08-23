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

  TFGXLaunchService = class
  private
    class var FLaunchService: IFGXLaunchService;
  public
    class function OpenURL(const AUrl: string): Boolean;
    class constructor Create;
    class destructor Destroy;
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
//
// { TLinkedLabel }
//
// procedure TfgCustomLinkedLabel.Click;
// begin
// if FLaunchService <> nil then
// begin
// FVisited := True;
// Repaint;
// FLaunchService.OpenURL(Url);
// end;
// end;

{ TFGXLaunchService }

class constructor TFGXLaunchService.Create;
begin
  TPlatformServices.Current.SupportsPlatformService(IFGXLaunchService, FLaunchService);
end;

class destructor TFGXLaunchService.Destroy;
begin
  FLaunchService := nil;
end;

class function TFGXLaunchService.OpenURL(const AUrl: string): Boolean;
begin
  if FLaunchService <> nil then
    Result := FLaunchService.OpenURL(AUrl)
  else
    Result := False;
end;

initialization

RegisterService;

finalization

UnregisterService;

end.
