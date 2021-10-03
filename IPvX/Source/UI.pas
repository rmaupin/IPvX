//******************************************************************************
//*                                                                            *
//* File:       UI.pas                                                         *
//*                                                                            *
//* Function:   The user interface for IPvX, which started as a demonstration  *
//*             of the IP.pas library, but it has some added features:         *
//*                                                                            *
//*              - A keypad that allows mouse-only use of the application,     *
//*                inspired by the IPv6 Buddy (https://www.ipv6buddy.com/)     *
//*                                                                            *
//*              - Status of the IP addressing, including the address cast,    *
//*                scope, and (more or less official) desription.              *
//*                                                                            *
//*             There is one IPv4 and one IPv6 object, and the field values    *
//*             are read directly from the two IP objects, and changing one of *
//*             the read/write fields sets the address and/or mask in the      *
//*             chosen (IPv4 or IPv6) object, then all the fields for that     *
//*             object are updated, along with the status fields.              *
//*                                                                            *
//*             The status cast, scope and desription fields are informed by   *
//*             IANA and RFCs:                                                 *
//*                                                                            *
//*              - IANA IPv4 Special-Purpose Address Registry                  *
//*              - IPv4 Multicast Address Space Registry                       *
//*              - IANA IPv6 Special-Purpose Address Registry                  *
//*              - IPv6 Multicast Address Space Registry                       *
//*              - Various RFCs                                                *
//*                                                                            *
//* Language:   Delphi version 10.4 or later as required for Virtual Images    *
//*                                                                            *
//* Author:     Ron Maupin                                                     *
//*                                                                            *
//* Copyright:  (c) 2010 - 2021 by Ron Maupin                                  *
//*                                                                            *
//* License:    Redistribution and use in source and binary forms, with or     *
//*             without modification, are permitted provided that the          *
//*             following conditions are met:                                  *
//*                                                                            *
//*              - Redistributions of source code must retain the above        *
//*                copyright notices, this list of conditions and the          *
//*                following disclaimer.                                       *
//*                                                                            *
//*              - Redistributions in binary form must reproduce the above     *
//*                copyright notice, this list of conditions and the following *
//*                disclaimer in the documentation and/or other materials      *
//*                provided with the distribution.                             *
//*                                                                            *
//* Disclaimer: THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS "AS IS" AND *
//*             ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED  *
//*             TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR  *
//*             A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE     *
//*             COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,      *
//*             INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL     *
//*             DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF         *
//*             SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;   *
//*             OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  *
//*             LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT      *
//*             (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF  *
//*             THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY   *
//*             OF SUCH DAMAGE.                                                *
//*                                                                            *
//******************************************************************************

unit UI;

interface

uses
  About, IP,
  System.Classes, System.ImageList, System.IOUtils, System.SysUtils, System.UITypes,
  Vcl.BaseImageCollection, Vcl.Controls, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Forms, Vcl.HtmlHelpViewer, Vcl.ImageCollection, Vcl.ImgList, Vcl.Menus, Vcl.StdCtrls, Vcl.VirtualImage, Vcl.VirtualImageList,
  Winapi.Messages, Winapi.Windows;

type
  TUIForm = class(TForm)
    ApplicationImageCollection: TImageCollection;
    ApplicationImageList: TVirtualImageList;
    KeypadImageCollection: TImageCollection;
    MainMenu: TMainMenu;
      FileMenu: TMenuItem;
        ClearMenuItem: TMenuItem;
        N1: TMenuItem;
        ExitMenuItem: TMenuItem;
      IPMenu: TMenuItem;
        IPv4MenuItem: TMenuItem;
        IPv6MenuItem: TMenuItem;
      HelpMenu: TMenuItem;
        HelpManuItem: TMenuItem;
        N2: TMenuItem;
        AboutMenuItem: TMenuItem;
    KeyPanel: TPanel;
      KeyBaseImage: TVirtualImage;
      KeyImage0: TVirtualImage;
      KeyImage1: TVirtualImage;
      KeyImage2: TVirtualImage;
      KeyImage3: TVirtualImage;
      KeyImage4: TVirtualImage;
      KeyImage5: TVirtualImage;
      KeyImage6: TVirtualImage;
      KeyImage7: TVirtualImage;
      KeyImage8: TVirtualImage;
      KeyImage9: TVirtualImage;
      KeyImageA: TVirtualImage;
      KeyImageB: TVirtualImage;
      KeyImageC: TVirtualImage;
      KeyImageD: TVirtualImage;
      KeyImageE: TVirtualImage;
      KeyImageF: TVirtualImage;
      KeyImageDot: TVirtualImage;
      KeyImageColon: TVirtualImage;
      KeyImageEnter: TVirtualImage;
      KeyImageColonX2: TVirtualImage;
      KeyImageSlash: TVirtualImage;
      KeyImageBack: TVirtualImage;
      KeyImageClear: TVirtualImage;
    IPv4Panel: TPanel;
      IPPanel: TPanel;
      IPv4PrefixLabel: TLabel;
      IPv4PrefixEdit: TEdit;
      IPv4NetworkLabel: TLabel;
      IPv4NetworkEdit: TEdit;
      IPv4PrefixLengthLabel: TLabel;
      IPv4PrefixLengthEdit: TEdit;
      IPv4AddressLabel: TLabel;
      IPv4AddressEdit: TEdit;
      IPv4NetworkMaskLabel: TLabel;
      IPv4NetworkMaskEdit: TEdit;
      IPv4HostMaskLabel: TLabel;
      IPv4HostMaskEdit: TEdit;
      IPv4OffsetLabel: TLabel;
      IPv4OffsetEdit: TEdit;
      IPv4FirstAddressLabel: TLabel;
      IPv4FirstAddressEdit: TEdit;
      IPv4LastAddressLabel: TLabel;
      IPv4LastAddressEdit: TEdit;
      IPv4BroadcastAddressLabel: TLabel;
      IPv4BroadcastAddressEdit: TEdit;
    IPv6Panel: TPanel;
      IPv6PrefixLabel: TLabel;
      IPv6PrefixEdit: TEdit;
      IPv6NetworkLabel: TLabel;
      IPv6NetworkEdit: TEdit;
      IPv6PrefixLengthLabel: TLabel;
      IPv6PrefixLengthEdit: TEdit;
      IPv6AddressLabel: TLabel;
      IPv6AddressEdit: TEdit;
      IPv6OffsetLabel: TLabel;
      IPv6OffsetEdit: TEdit;
      IPv6FirstAddressLabel: TLabel;
      IPv6FirstAddressEdit: TEdit;
      IPv6LastAddressLabel: TLabel;
      IPv6LastAddressEdit: TEdit;
    StatusPanel: TPanel;
      StatusCastPanel: TPanel;
        StatusCastLabel: TLabel;
      StatusScopePanel: TPanel;
        StatusScopeLabel: TLabel;
      StatusDescriptionPanel: TPanel;
        StatusDescriptionLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure ClearMenuItemClick(Sender: TObject);
    procedure ExitMenuItemClick(Sender: TObject);
    procedure IPv4MenuItemClick(Sender: TObject);
    procedure IPv6MenuItemClick(Sender: TObject);
    procedure AboutMenuItemClick(Sender: TObject);
    procedure HelpManuItemClick(Sender: TObject);
    procedure KeyImage0MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImage0MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImage1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImage1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImage2MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImage2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImage3MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImage3MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImage4MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImage4MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImage5MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImage5MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImage6MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImage6MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImage7MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImage7MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImage8MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImage8MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImage9MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImage9MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImageAMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImageAMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImageBMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImageBMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImageCMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImageCMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImageDMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImageDMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImageEMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImageEMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImageFMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImageFMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImageDotMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImageDotMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImageColonMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImageColonMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImageEnterMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImageEnterMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImageColonX2MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImageColonX2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImageSlashMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImageSlashMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImageBackMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImageBackMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImageClearMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImageClearMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure IPv4EditExit(Sender: TObject);
    procedure IPv6EditExit(Sender: TObject);
  private
    FIPVersion: Integer;
    FIPv4Cast: string;
    FIPv6Cast: string;
    FIPv4Scope: string;
    FIPv6Scope: string;
    FIPv4Description: string;
    FIPv6Description: string;
    FIPv4ActiveEdit: TEdit;
    FIPv6ActiveEdit: TEdit;
    FIpv4: TIPv4;
    FIpv6: TIPv6;
    procedure IPv4Update();
    procedure IPv6Update();
    procedure IPv4UpdateStatus();
    procedure IPv6UpdateStatus();
  end;

var
  UIForm: TUIForm;

implementation {$R *.dfm}

{$REGION 'Form'}

procedure TUIForm.FormCreate(Sender: TObject);
begin
  AboutForm.AboutImage.ImageCollection := ApplicationImageCollection;
  AboutForm.AboutImage.ImageName := 'IPvX';
  HelpFile := TPath.ChangeExtension(ParamStr(0), 'chm');
  FIPVersion := 4;
  FIPv4ActiveEdit := IPv4PrefixEdit;
  FIPv6ActiveEdit := IPv6PrefixEdit;
  FIPv4 := TIPv4.Create;
  FIPv6 := TIPv6.Create;
  IPv6Update;
  IPv4Update;
end;

procedure TUIForm.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
begin
  if (Msg.CharCode = VK_RETURN) then begin
    Msg.CharCode := VK_TAB;
    Handled := False;
  end
  else if ((Msg.CharCode = VK_UP) or (Msg.CharCode = VK_DOWN)) then begin
    SelectNext(ActiveControl, (Msg.CharCode = VK_DOWN), True);
    Handled := True;
  end
  else begin
    Handled := False;
  end;
end;

procedure TUIForm.FormDestroy(Sender: TObject);
begin
  FIPv4.Free;
  FIPv6.Free;
end;

{$ENDREGION}

{$REGION 'Menu'}

procedure TUIForm.ClearMenuItemClick(Sender: TObject);
begin
  case FIPVersion of
    4: begin
      FIPv4.Clear;
      IPv4Update;
      ActiveControl := IPv4PrefixEdit;
    end;
    6: begin
      FIPv6.Clear;
      IPv6Update;
      ActiveControl := IPv6PrefixEdit;
    end;
  end;
  (ActiveControl as TEdit).SelectAll;
end;

procedure TUIForm.ExitMenuItemClick(Sender: TObject);
begin
  Close;
end;

procedure TUIForm.IPv4MenuItemClick(Sender: TObject);
begin
  if (FIPVersion = 6) then begin
    IPv4MenuItem.Checked      := True;
    FIPv6ActiveEdit           := (ActiveControl as TEdit);
    FIPVersion                := 4;
    IPPanel.Caption           := 'IPv4';
    KeyImageA.ImageName       := 'BaseA';
    KeyImageB.ImageName       := 'BaseB';
    KeyImageC.ImageName       := 'BaseC';
    KeyImageD.ImageName       := 'BaseD';
    KeyImageE.ImageName       := 'BaseE';
    KeyImageF.ImageName       := 'BaseF';
    KeyImageColon.ImageName   := 'BaseColon';
    KeyImageColonX2.ImageName := 'BaseColonX2';
    IPv4Panel.Visible         := True;
    IPv6Panel.Visible         := False;
    ActiveControl             := FIPv4ActiveEdit;
    IPv4Update;
    (ActiveControl as TEdit).SelectAll;
  end;
end;

procedure TUIForm.IPv6MenuItemClick(Sender: TObject);
begin
  if (FIPVersion = 4) then begin
    IPv6MenuItem.Checked      := True;
    FIPv4ActiveEdit           := (ActiveControl as TEdit);
    FIPVersion                := 6;
    IPPanel.Caption           := 'IPv6';
    KeyImageA.ImageName       := 'UpA';
    KeyImageB.ImageName       := 'UpB';
    KeyImageC.ImageName       := 'UpC';
    KeyImageD.ImageName       := 'UpD';
    KeyImageE.ImageName       := 'UpE';
    KeyImageF.ImageName       := 'UpF';
    KeyImageColon.ImageName   := 'UpColon';
    KeyImageColonX2.ImageName := 'UpColonX2';
    IPv4Panel.Visible         := False;
    IPv6Panel.Visible         := True;
    ActiveControl             := FIPv6ActiveEdit;
    IPv6Update;
    (ActiveControl as TEdit).SelectAll;
  end;
end;

procedure TUIForm.HelpManuItemClick(Sender: TObject);
begin
  Application.HelpContext(0);
end;

procedure TUIForm.AboutMenuItemClick(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

{$ENDREGION}

{$REGION 'Keypad'}

procedure TUIForm.KeyImage0MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyImage0.ImageName := 'Dn0';
  keybd_event(VK_NUMPAD0, MapVirtualKey(VK_NUMPAD0, 0), 0, 0);
  keybd_event(VK_NUMPAD0, MapVirtualKey(VK_NUMPAD0, 0), KEYEVENTF_KEYUP, 0);
end;

procedure TUIForm.KeyImage0MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyImage0.ImageName := 'Up0';
end;

procedure TUIForm.KeyImage1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyImage1.ImageName := 'Dn1';
  keybd_event(VK_NUMPAD1, MapVirtualKey(VK_NUMPAD1, 0), 0, 0);
  keybd_event(VK_NUMPAD1, MapVirtualKey(VK_NUMPAD1, 0), KEYEVENTF_KEYUP, 0);
end;

procedure TUIForm.KeyImage1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyImage1.ImageName := 'Up1';
end;

procedure TUIForm.KeyImage2MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyImage2.ImageName := 'Dn2';
  keybd_event(VK_NUMPAD2, MapVirtualKey(VK_NUMPAD2, 0), 0, 0);
  keybd_event(VK_NUMPAD2, MapVirtualKey(VK_NUMPAD2, 0), KEYEVENTF_KEYUP, 0);
end;

procedure TUIForm.KeyImage2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyImage2.ImageName := 'Up2';
end;

procedure TUIForm.KeyImage3MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyImage3.ImageName := 'Dn3';
  keybd_event(VK_NUMPAD3, MapVirtualKey(VK_NUMPAD3, 0), 0, 0);
  keybd_event(VK_NUMPAD3, MapVirtualKey(VK_NUMPAD3, 0), KEYEVENTF_KEYUP, 0);
end;

procedure TUIForm.KeyImage3MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyImage3.ImageName := 'Up3';
end;

procedure TUIForm.KeyImage4MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyImage4.ImageName := 'Dn4';
  keybd_event(VK_NUMPAD4, MapVirtualKey(VK_NUMPAD4, 0), 0, 0);
  keybd_event(VK_NUMPAD4, MapVirtualKey(VK_NUMPAD4, 0), KEYEVENTF_KEYUP, 0);
end;

procedure TUIForm.KeyImage4MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyImage4.ImageName := 'Up4';
end;

procedure TUIForm.KeyImage5MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyImage5.ImageName := 'Dn5';
  keybd_event(VK_NUMPAD5, MapVirtualKey(VK_NUMPAD5, 0), 0, 0);
  keybd_event(VK_NUMPAD5, MapVirtualKey(VK_NUMPAD5, 0), KEYEVENTF_KEYUP, 0);
end;

procedure TUIForm.KeyImage5MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyImage5.ImageName := 'Up5';
end;

procedure TUIForm.KeyImage6MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyImage6.ImageName := 'Dn6';
  keybd_event(VK_NUMPAD6, MapVirtualKey(VK_NUMPAD6, 0), 0, 0);
  keybd_event(VK_NUMPAD6, MapVirtualKey(VK_NUMPAD6, 0), KEYEVENTF_KEYUP, 0);
end;

procedure TUIForm.KeyImage6MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyImage6.ImageName := 'Up6';
end;

procedure TUIForm.KeyImage7MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyImage7.ImageName := 'Dn7';
  keybd_event(VK_NUMPAD7, MapVirtualKey(VK_NUMPAD7, 0), 0, 0);
  keybd_event(VK_NUMPAD7, MapVirtualKey(VK_NUMPAD7, 0), KEYEVENTF_KEYUP, 0);
end;

procedure TUIForm.KeyImage7MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyImage7.ImageName := 'Up7';
end;

procedure TUIForm.KeyImage8MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyImage8.ImageName := 'Dn8';
  keybd_event(VK_NUMPAD8, MapVirtualKey(VK_NUMPAD8, 0), 0, 0);
  keybd_event(VK_NUMPAD8, MapVirtualKey(VK_NUMPAD8, 0), KEYEVENTF_KEYUP, 0);
end;

procedure TUIForm.KeyImage8MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyImage8.ImageName := 'Up8';
end;

procedure TUIForm.KeyImage9MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyImage9.ImageName := 'Dn9';
  keybd_event(VK_NUMPAD9, MapVirtualKey(VK_NUMPAD9, 0), 0, 0);
  keybd_event(VK_NUMPAD9, MapVirtualKey(VK_NUMPAD9, 0), KEYEVENTF_KEYUP, 0);
end;

procedure TUIForm.KeyImage9MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyImage9.ImageName := 'Up9';
end;

procedure TUIForm.KeyImageAMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (FIPVersion = 6) then begin
    KeyImageA.ImageName := 'DnA';
    keybd_event(Ord('A'), MapVirtualKey(Ord('A'), 0), 0, 0);
    keybd_event(Ord('A'), MapVirtualKey(Ord('A'), 0), KEYEVENTF_KEYUP, 0);
  end;
end;

procedure TUIForm.KeyImageAMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (FIPVersion = 6) then begin
    KeyImageA.ImageName := 'UpA';
  end;
end;

procedure TUIForm.KeyImageBMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (FIPVersion = 6) then begin
    KeyImageB.ImageName := 'DnB';
    keybd_event(Ord('B'), MapVirtualKey(Ord('B'), 0), 0, 0);
    keybd_event(Ord('B'), MapVirtualKey(Ord('B'), 0), KEYEVENTF_KEYUP, 0);
  end;
end;

procedure TUIForm.KeyImageBMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (FIPVersion = 6) then begin
    KeyImageB.ImageName := 'UpB';
  end;
end;

procedure TUIForm.KeyImageCMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (FIPVersion = 6) then begin
    KeyImageC.ImageName := 'DnC';
    keybd_event(Ord('C'), MapVirtualKey(Ord('C'), 0), 0, 0);
    keybd_event(Ord('C'), MapVirtualKey(Ord('C'), 0), KEYEVENTF_KEYUP, 0);
  end;
end;

procedure TUIForm.KeyImageCMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (FIPVersion = 6) then begin
    KeyImageC.ImageName := 'UpC';
  end;
end;

procedure TUIForm.KeyImageDMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (FIPVersion = 6) then begin
    KeyImageD.ImageName := 'DnD';
    keybd_event(Ord('D'), MapVirtualKey(Ord('D'), 0), 0, 0);
    keybd_event(Ord('D'), MapVirtualKey(Ord('D'), 0), KEYEVENTF_KEYUP, 0);
  end;
end;

procedure TUIForm.KeyImageDMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (FIPVersion = 6) then begin
    KeyImageD.ImageName := 'UpD';
  end;
end;

procedure TUIForm.KeyImageEMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (FIPVersion = 6) then begin
    KeyImageE.ImageName := 'DnE';
    keybd_event(Ord('E'), MapVirtualKey(Ord('E'), 0), 0, 0);
    keybd_event(Ord('E'), MapVirtualKey(Ord('E'), 0), KEYEVENTF_KEYUP, 0);
  end;
end;

procedure TUIForm.KeyImageEMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (FIPVersion = 6) then begin
    KeyImageE.ImageName := 'UpE';
  end;
end;

procedure TUIForm.KeyImageFMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (FIPVersion = 6) then begin
    KeyImageF.ImageName := 'DnF';
    keybd_event(Ord('F'), MapVirtualKey(Ord('F'), 0), 0, 0);
    keybd_event(Ord('F'), MapVirtualKey(Ord('F'), 0), KEYEVENTF_KEYUP, 0);
  end;
end;

procedure TUIForm.KeyImageFMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (FIPVersion = 6) then begin
    KeyImageF.ImageName := 'UpF';
  end;
end;

procedure TUIForm.KeyImageDotMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyImageDot.ImageName := 'DnDot';
  keybd_event(VK_DECIMAL, MapVirtualKey(VK_DECIMAL, 0), 0, 0);
  keybd_event(VK_DECIMAL, MapVirtualKey(VK_DECIMAL, 0), KEYEVENTF_KEYUP, 0);
end;

procedure TUIForm.KeyImageDotMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyImageDot.ImageName := 'UpDot';
end;

procedure TUIForm.KeyImageColonMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (FIPVersion = 6) then begin
    KeyImageColon.ImageName := 'DnColon';
    keybd_event(VK_SHIFT, MapVirtualKey(VK_SHIFT, 0), 0, 0);
    keybd_event(vkSemicolon, MapVirtualKey(vkSemicolon, 0), 0, 0);
    keybd_event(vkSemicolon, MapVirtualKey(vkSemicolon, 0), KEYEVENTF_KEYUP, 0);
    keybd_event(VK_SHIFT, MapVirtualKey(VK_SHIFT, 0), KEYEVENTF_KEYUP, 0);
  end;
end;

procedure TUIForm.KeyImageColonMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (FIPVersion = 6) then begin
    KeyImageColon.ImageName := 'UpColon';
  end;
end;

procedure TUIForm.KeyImageEnterMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyImageEnter.ImageName := 'DnEnter';
  KeyImageEnter.Repaint;
  keybd_event(VK_RETURN, MapVirtualKey(VK_RETURN, 0), 0, 0);
  keybd_event(VK_RETURN, MapVirtualKey(VK_RETURN, 0), KEYEVENTF_KEYUP, 0);
end;

procedure TUIForm.KeyImageEnterMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyImageEnter.ImageName := 'UpEnter';
end;

procedure TUIForm.KeyImageColonX2MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (FIPVersion = 6) then begin
    KeyImageColonX2.ImageName := 'DnColonX2';
    keybd_event(VK_SHIFT, MapVirtualKey(VK_SHIFT, 0), 0, 0);
    keybd_event(vkSemicolon, MapVirtualKey(vkSemicolon, 0), 0, 0);
    keybd_event(vkSemicolon, MapVirtualKey(vkSemicolon, 0), KEYEVENTF_KEYUP, 0);
    keybd_event(vkSemicolon, MapVirtualKey(vkSemicolon, 0), 0, 0);
    keybd_event(vkSemicolon, MapVirtualKey(vkSemicolon, 0), KEYEVENTF_KEYUP, 0);
    keybd_event(VK_SHIFT, MapVirtualKey(VK_SHIFT, 0), KEYEVENTF_KEYUP, 0);
  end;
end;

procedure TUIForm.KeyImageColonX2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (FIPVersion = 6) then begin
    KeyImageColonX2.ImageName := 'UpColonX2';
  end;
end;

procedure TUIForm.KeyImageSlashMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyImageSlash.ImageName := 'DnSlash';
  keybd_event(VK_DIVIDE, MapVirtualKey(VK_DIVIDE, 0), 0, 0);
  keybd_event(VK_DIVIDE, MapVirtualKey(VK_DIVIDE, 0), KEYEVENTF_KEYUP, 0);
end;

procedure TUIForm.KeyImageSlashMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyImageSlash.ImageName := 'UpSlash';
end;

procedure TUIForm.KeyImageBackMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyImageBack.ImageName := 'DnBack';
  keybd_event(VK_BACK, MapVirtualKey(VK_BACK, 0), 0, 0);
  keybd_event(VK_BACK, MapVirtualKey(VK_BACK, 0), KEYEVENTF_KEYUP, 0);
end;

procedure TUIForm.KeyImageBackMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyImageBack.ImageName := 'UpBack';
end;

procedure TUIForm.KeyImageClearMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyImageClear.ImageName := 'DnClr';
  keybd_event(VK_ESCAPE, MapVirtualKey(VK_ESCAPE, 0), 0, 0);
  keybd_event(VK_ESCAPE, MapVirtualKey(VK_ESCAPE, 0), KEYEVENTF_KEYUP, 0);
end;

procedure TUIForm.KeyImageClearMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyImageClear.ImageName := 'UpClr';
end;

{$ENDREGION}

{$REGION 'IPv4'}

procedure TUIForm.IPv4EditExit(Sender: TObject);
begin
  try
    if (Sender = IPv4PrefixEdit) then begin
      FIPv4.Prefix := IPv4PrefixEdit.Text;
      IPv4Update;
    end
    else if (Sender = IPv4NetworkEdit) then begin
      FIPv4.Network := IPv4NetworkEdit.Text;
      IPv4Update;
    end
    else if (Sender = IPv4PrefixLengthEdit) then begin
      FIPv4.NetLength := IPv4PrefixLengthEdit.Text;
      IPv4Update;
    end
    else if (Sender = IPv4AddressEdit) then begin
      FIPv4.Address := IPv4AddressEdit.Text;
      IPv4Update;
    end
    else if (Sender = IPv4NetworkMaskEdit) then begin
      FIPv4.NetMask := IPv4NetworkMaskEdit.Text;
      IPv4Update;
    end
    else if (Sender = IPv4HostMaskEdit) then begin
      FIPv4.HostMask := IPv4HostMaskEdit.Text;
      IPv4Update;
    end
    else if (Sender = IPv4OffsetEdit) then begin
      FIPv4.Offset := IPv4OffsetEdit.Text;
      IPv4Update;
    end
  except
    on E: Exception do begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
      if (Sender as TEdit).CanFocus then begin
        (Sender as TEdit).SetFocus;
        (Sender as TEdit).Undo;
        (Sender as TEdit).SelectAll;
      end;
    end;
  end;
end;

procedure TUIForm.IPv4Update();
begin
  IPv4PrefixEdit.Text := FIPv4.Prefix;
  IPv4NetworkEdit.Text := FIPv4.Network;
  IPv4PrefixLengthEdit.Text := FIPv4.NetLength;
  IPv4AddressEdit.Text := FIPv4.Address;
  IPv4NetworkMaskEdit.Text := FIPv4.NetMask;
  IPv4HostMaskEdit.Text := FIPv4.HostMask;
  IPv4OffsetEdit.Text := FIPv4.Offset;
  IPv4FirstAddressEdit.Text := FIPv4.First;
  IPv4LastAddressEdit.Text := FIPv4.Last;
  IPv4BroadcastAddressEdit.Text := FIPv4.Broadcast;
  IPv4UpdateStatus;
end;

procedure TUIForm.IPv4UpdateStatus();
begin
  if (FIPv4.InRange('240.0.0.0/4')) then begin
    if (FIPv4.InRange('255.255.255.255/32')) Then begin
      FIPv4Cast        := 'Broadcast';
      FIPv4Scope       := 'Link-Local';
      FIPv4Description := 'Limited Broadcast';
    end
    else begin
      FIPv4Cast        := 'Reserved';
      FIPv4Scope       := 'N/A';
      FIPv4Description := 'Reserved';
    end;
  end
  else if (FIPv4.InRange('224.0.0.0/4')) then begin
    FIPv4Cast  := 'Multicast';
    if (FIPv4.InRange('224.0.0.0/16')) then begin
      if (FIPv4.InRange('224.0.0.0/24')) then begin
        FIPv4Scope       := 'Link-Local';
        FIPv4Description := 'Local Network Control Block';
      end
      else if (FIPv4.InRange('224.0.1.0/24')) then begin
        FIPv4Scope       := 'Global';
        FIPv4Description := 'Internetwork Control Block';
      end
      else begin
        FIPv4Scope       := 'Global';
        FIPv4Description := 'AD-HOC Block I';
      end;
    end
    else if (FIPv4.InRange('224.2.0.0/16')) then begin
      FIPv4Scope       := 'Global';
      FIPv4Description := 'SDP/SAP Block';
    end
    else if (FIPv4.InRange('224.3.0.0/16')) then begin
      FIPv4Scope       := 'Global';
      FIPv4Description := 'AD-HOC Block II';
    end
    else if (FIPv4.InRange('224.4.0.0/16')) then begin
      FIPv4Scope       := 'Global';
      FIPv4Description := 'AD-HOC Block II';
    end
    else if (FIPv4.InRange('224.252.0.0/14')) then begin
      FIPv4Scope       := 'Global';
      FIPv4Description := 'DIS Transient Groups';
    end
    else if (FIPv4.InRange('232.0.0.0/8')) then begin
      FIPv4Scope       := 'Global';
      FIPv4Description := 'Source-Specific Multicast Block';
    end
    else if (FIPv4.InRange('233.0.0.0/8')) then begin
      if (FIPv4.InRange('233.252.0.0/14')) then begin
        FIPv4Scope       := 'Global';
        FIPv4Description := 'AD-HOC Block III';
      end
      else begin
        FIPv4Scope       := 'Global';
        FIPv4Description := 'GLOP Block';
      end;
    end
    else if (FIPv4.InRange('234.0.0.0/8')) then begin
      FIPv4Scope       := 'Global';
      FIPv4Description := 'Unicast-Prefix-based IPv4 Multicast Addresses';
    end
    else if (FIPv4.InRange('239.0.0.0/8')) then begin
      FIPv4Scope       := 'Organization-Local';
      FIPv4Description := 'Organization-Local Scope';
    end
    else begin
      FIPv4Scope       := 'Reserved';
      FIPv4Description := 'Reserved';
    end;
  end
  else begin
    FIPv4Cast := 'Unicast';
    if (FIPv4.InRange('0.0.0.0/32')) then begin
      FIPv4Scope       := 'Link-Local';
      FIPv4Description := 'This host on this network';
    end
    else if (FIPv4.InRange('0.0.0.0/0')) then begin
      FIPv4Scope       := 'Link-Local';
      FIPv4Description := 'This network';
    end
    else if (FIPv4.InRange('10.0.0.0/8')) then begin
      FIPv4Scope       := 'Local';
      FIPv4Description := 'Private-Use';
    end
    else if (FIPv4.InRange('100.64.0.0/10')) then begin
      FIPv4Scope       := 'Local';
      FIPv4Description := 'Shared Address Space';
    end
    else if (FIPv4.InRange('127.0.0.0/8')) then begin
      FIPv4Scope       := 'Host-Local';
      FIPv4Description := 'Loopback';
    end
    else if (FIPv4.InRange('169.254.0.0/16')) then begin
      FIPv4Scope       := 'Link-Local';
      FIPv4Description := 'Link-Local';
    end
    else if (FIPv4.InRange('172.16.0.0/12')) then begin
      FIPv4Scope       := 'Local';
      FIPv4Description := 'Private-Use';
    end
    else if (FIPv4.InRange('192.0.0.0/24')) then begin
      if (FIPv4.InRange('192.0.0.0/29')) then begin
        FIPv4Scope       := 'Local';
        FIPv4Description := 'IPv4 Service Continuity Prefix';
      end
      else if (FIPv4.InRange('192.0.0.8/32')) then begin
        FIPv4Scope       := 'Link-Local';
        FIPv4Description := 'IPv4 dummy address';
      end
      else if (FIPv4.InRange('192.0.0.9/32')) then begin
        FIPv4Scope       := 'Global';
        FIPv4Description := 'Port Control Protocol Anycast';
      end
      else if (FIPv4.InRange('192.0.0.10/32')) then begin
        FIPv4Scope       := 'Global';
        FIPv4Description := 'Traversal Using Relays around NAT Anycast';
      end
      else if (FIPv4.InRange('192.0.0.170/31')) then begin
        FIPv4Scope       := 'N/A';
        FIPv4Description := 'NAT64/DNS64 Discovery';
      end
      else begin
        FIPv4Scope       := 'N/A';
        FIPv4Description := 'IETF Protocol Assignments';
      end;
    end
    else if (FIPv4.InRange('192.0.2.0/24')) then begin
      FIPv4Scope       := 'N/A';
      FIPv4Description := 'Documentation (TEST-NET-1)';
    end
    else if (FIPv4.InRange('192.31.196.0/24')) then begin
      FIPv4Scope       := 'Global';
      FIPv4Description := 'AS112-v4';
    end
    else if (FIPv4.InRange('192.52.193.0/24')) then begin
      FIPv4Scope       := 'Global';
      FIPv4Description := 'AMT';
    end
    else if (FIPv4.InRange('192.88.99.0/24')) then begin
      FIPv4Scope       := 'N/A';
      FIPv4Description := 'Deprecated (6to4 Relay Anycast)';
    end
    else if (FIPv4.InRange('192.168.0.0/16')) then begin
      FIPv4Scope       := 'Local';
      FIPv4Description := 'Private-Use';
    end
    else if (FIPv4.InRange('192.175.48.0/24')) then begin
      FIPv4Scope       := 'Global';
      FIPv4Description := 'Direct Delegation AS112 Service';
    end
    else if (FIPv4.InRange('198.18.0.0/15')) then begin
      FIPv4Scope       := 'Local';
      FIPv4Description := 'Benchmarking';
    end
    else if (FIPv4.InRange('198.51.100.0/24')) then begin
      FIPv4Scope       := 'N/A';
      FIPv4Description := 'Documentation (TEST-NET-2)';
    end
    else if (FIPv4.InRange('203.0.113.0/24')) then begin
      FIPv4Scope       := 'N/A';
      FIPv4Description := 'Documentation (TEST-NET-3)';
    end
    else begin
      FIPv4Scope       := 'Global';
      FIPv4Description := 'Public Addresses';
    end;
    if ((FIPv4.NetLength.ToInteger < 31) and (FIPv4.Address = FIPv4.Broadcast)) then begin
      FIPv4Cast        := 'Broadcast';
      FIPv4Scope       := 'Link-Local';
      FIPv4Description := (FIPv4Description + ' - Network Broadcast');
    end
    else if ((FIPv4.NetLength.ToInteger < 31) and (FIPv4.Address = FIPv4.Network)) then begin
      FIPv4Description := (FIPv4Description + ' - Network Address');
    end;
  end;
  StatusCastLabel.Caption        := FIPv4Cast;
  StatusScopeLabel.Caption       := FIPv4Scope;
  StatusDescriptionLabel.Caption := FIPv4Description;
end;

{$ENDREGION}

{$REGION 'IPv6'}

procedure TUIForm.IPv6EditExit(Sender: TObject);
begin
  try
    if (Sender = IPv6PrefixEdit) then begin
      FIPv6.Prefix  := IPv6PrefixEdit.Text;
      IPv6Update;
    end
    else if (Sender = IPv6NetworkEdit) then begin
      FIPv6.Network := IPv6NetworkEdit.Text;
      IPv6Update;
    end
    else if (Sender = IPv6PrefixLengthEdit) then begin
      FIPv6.NetLength := IPv6PrefixLengthEdit.Text;
      IPv6Update;
    end
    else if (Sender = IPv6AddressEdit) then begin
      FIPv6.Address := IPv6AddressEdit.Text;
      IPv6Update;
    end
    else if (Sender = IPv6OffsetEdit) then begin
      FIPv6.Offset := IPv6OffsetEdit.Text;
      IPv6Update;
    end;
  except
    on E: Exception do begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
      if (Sender as TEdit).CanFocus then begin
        (Sender as TEdit).SetFocus;
        (Sender as TEdit).Undo;
        (Sender as TEdit).SelectAll;
      end;
    end;
  end;
end;

procedure TUIForm.IPv6Update();
begin
  IPv6PrefixEdit.Text       := FIPv6.Prefix;
  IPv6NetworkEdit.Text      := FIPv6.Network;
  IPv6PrefixLengthEdit.Text := FIPv6.NetLength;
  IPv6AddressEdit.Text      := FIPv6.Address;
  IPv6OffsetEdit.Text       := FIPv6.Offset;
  IPv6FirstAddressEdit.Text := FIPv6.First;
  IPv6LastAddressEdit.Text  := FIPv6.Last;
  IPv6UpdateStatus;
end;

procedure TUIForm.IPv6UpdateStatus();
var
  c: System.TArray<Char>;
begin
  FIPv6Cast := 'Unicast';
  if (FIPv6.InRange('::/128')) then begin
    FIPv6Scope       := 'Link-Local';
    FIPv6Description := 'Unspecified Address';
  end
  else if (FIPv6.InRange('::1/128')) then begin
    FIPv6Scope       := 'Host-Local';
    FIPv6Description := 'Loopback Address';
  end
  else if (FIPv6.InRange('::ffff:0:0/96')) then begin
    FIPv6Cast        := 'N/A';
    FIPv6Scope       := 'N/A';
    FIPv6Description := 'IPv4-mapped';
  end
  else if (FIPv6.InRange('64:ff9b::/96')) then begin
    FIPv6Scope       := 'Global';
    FIPv6Description := 'IPv4-FIPv6 Translators';
  end
  else if (FIPv6.InRange('64:ff9b:1::/48')) then begin
    FIPv6Scope       := 'Local';
    FIPv6Description := 'IPv4-FIPv6 Translators';
  end
  else if (FIPv6.InRange('100::/64')) then begin
    FIPv6Scope       := 'Local';
    FIPv6Description := 'Discard-Only Address Block';
  end
  else if (FIPv6.InRange('2001::/32')) then begin
    FIPv6Scope       := 'N/A';
    FIPv6Description := 'TEREDO';
  end
  else if (FIPv6.InRange('2001::/23')) then begin
    FIPv6Scope       := 'N/A';
    FIPv6Description := 'IETF Protocol Assignments';
  end
  else if (FIPv6.InRange('2001:1::1/128')) then begin
    FIPv6Scope       := 'Global';
    FIPv6Description := 'Port Control Protocol Anycast';
  end
  else if (FIPv6.InRange('2001:1::2/128')) then begin
    FIPv6Scope       := 'Global';
    FIPv6Description := 'Traversal Using Relays around NAT Anycast';
  end
  else if (FIPv6.InRange('2001:2::/48')) then begin
    FIPv6Scope       := 'Local';
    FIPv6Description := 'Benchmarking';
  end
  else if (FIPv6.InRange('2001:3::/32')) then begin
    FIPv6Scope       := 'Global';
    FIPv6Description := 'AMT';
  end
  else if (FIPv6.InRange('2001:4:112::/48')) then begin
    FIPv6Scope       := 'Global';
    FIPv6Description := 'AS112-v6';
  end
  else if (FIPv6.InRange('2001:10::/28')) then begin
    FIPv6Scope       := 'N/A';
    FIPv6Description := 'Deprecated (previously ORCHID)';
  end
  else if (FIPv6.InRange('2001:20::/28')) then begin
    FIPv6Scope       := 'Global';
    FIPv6Description := 'ORCHIDv2';
  end
  else if (FIPv6.InRange('2001:db8::/32')) then begin
    FIPv6Scope       := 'N/A';
    FIPv6Description := 'Documentation';
  end
  else if (FIPv6.InRange('2002::/16')) then begin
    FIPv6Scope       := 'Local';
    FIPv6Description := '6to4';
  end
  else if (FIPv6.InRange('2620:4f:8000::/48')) then begin
    FIPv6Scope       := 'Global';
    FIPv6Description := 'Direct Delegation AS112 Service';
  end
  else if (FIPv6.InRange('2000::/3')) then begin
    FIPv6Scope       := 'Global';
    FIPv6Description := 'Public Addresses';
  end
  else if (FIPv6.InRange('fc00::/8')) then begin
    FIPv6Scope       := 'Reserved';
    FIPv6Description := 'Unique-Local';
  end
  else if (FIPv6.InRange('fd00::/8')) then begin
    FIPv6Scope       := 'Local';
    FIPv6Description := 'Unique-Local';
  end
  else if (FIPv6.InRange('fe80::/10')) then begin
    FIPv6Scope       := 'Link-Local';
    FIPv6Description := 'Link-Local';
  end
  else if (FIPv6.InRange('ff00::/8')) then begin
    FIPv6Cast := 'Multicast';
    c := FIPv6.Address.ToCharArray;
    case c[3] of
      '0': FIPv6Scope := 'Reserved';
      '1': FIPv6Scope := 'Interface-Local';
      '2': FIPv6Scope := 'Link-Local';
      '3': FIPv6Scope := 'Realm-Local';
      '4': FIPv6Scope := 'Admin-Local';
      '5': FIPv6Scope := 'Site-Local';
      '8': FIPv6Scope := 'Organization-Local';
      'e': FIPv6Scope := 'Global';
      'f': FIPv6Scope := 'Reserved';
    else   FIPv6Scope := 'Unassigned';
    end;
    if (FIPv6Scope <> 'Reserved') then begin
      if FIPv6.InRange(FIPv6.Network + '/24') then begin
        case c[2] of
          '0': FIPv6Description := 'Well-Known';
          '1': FIPv6Description := 'Transient';
          '3': FIPv6Description := 'Unicast Prefix-based';
          '7': FIPv6Description := 'Embedded RP';
          '8': FIPv6Description := 'Well-Known';
          '9': FIPv6Description := 'Transient';
          'b': FIPv6Description := 'Unicast Prefix-based';
          'f': FIPv6Description := 'Embedded RP';
        else   FIPv6Description := 'Invalid Flags';
        end;
      end
      else begin
        FIPv6Description := 'Invalid Flags';
      end;
    end
    else begin
      FIPv6Description := 'Reserved';
    end;
  end
  else begin
    FIPv6Cast        := 'Reserved';
    FIPv6Scope       := 'Reserved';
    FIPv6Description := 'Reserved';
  end;
  StatusCastLabel.Caption        := FIPv6Cast;
  StatusScopeLabel.Caption       := FIPv6Scope;
  StatusDescriptionLabel.Caption := FIPv6Description;
end;

{$ENDREGION}

end.
