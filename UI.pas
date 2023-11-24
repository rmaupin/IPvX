//******************************************************************************
//*                                                                            *
//* File:       UI.pas                                                         *
//*                                                                            *
//******************************************************************************
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
//*              - IANA IPv4 Multicast Address Space Registry                  *
//*              - IANA Internet Protocol Version 6 Address Space              *
//*              - IANA IPv6 Special-Purpose Address Registry                  *
//*              - IANA IPv6 Multicast Address Space Registry                  *
//*              - Various RFCs                                                *
//*                                                                            *
//******************************************************************************
//*                                                                            *
//* Language:   Delphi version 10.4 or later as required for Virtual Images    *
//*                                                                            *
//******************************************************************************
//*                                                                            *
//* Author:     Ron Maupin                                                     *
//*                                                                            *
//******************************************************************************
//*                                                                            *
//* Copyright:  IPvX.exe, UI.pas, IP.pas (c) 2010 - 2023 by Ron Maupin         *
//*             Velthuis.BigIntegers.pas (c) 2015,2016,2017 Rudy Velthuis      *
//*                                                                            *
//******************************************************************************
//*                                                                            *
//* Credits:    Thanks to Rudy Velthuis for the BigInteger library to simplify *
//*             IPv6 128-bit math. IPv6 addresses can be handled as an array   *
//*             of two 64-bit, unsigned integers, or four 32-bit, unsigned     *
//*             integers, but it is simpler and easier to be able to use       *
//*             128-bit integers as that is what an IPv6 address is.           *
//*                                                                            *
//******************************************************************************
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
//******************************************************************************
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
  System.Classes, System.ImageList, System.SysUtils, System.UITypes,
  Vcl.BaseImageCollection, Vcl.Controls, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Forms, Vcl.HtmlHelpViewer,
  Vcl.ImageCollection, Vcl.ImgList, Vcl.Menus, Vcl.StdCtrls, Vcl.VirtualImage, Vcl.VirtualImageList,
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
        HelpMenuItem: TMenuItem;
        N2: TMenuItem;
        AboutMenuItem: TMenuItem;
    KeyPanel: TPanel;
      IPLabel: TLabel;
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
      IPv4AddressEdit: TEdit;
      IPv4AddressLabel: TLabel;
      IPv4NetworkMaskEdit: TEdit;
      IPv4NetworkMaskLabel: TLabel;
      IPv4HostMaskEdit: TEdit;
      IPv4HostMaskLabel: TLabel;
      IPv4OffsetEdit: TEdit;
      IPv4OffsetLabel: TLabel;
      IPv4PrefixEdit: TEdit;
      IPv4PrefixLengthEdit: TEdit;
      IPv4PrefixLengthLabel: TLabel;
      IPv4NetworkEdit: TEdit;
      IPv4NetworkLabel: TLabel;
      IPv4FirstAddressEdit: TEdit;
      IPv4FirstAddressLabel: TLabel;
      IPv4LastAddressEdit: TEdit;
      IPv4LastAddressLabel: TLabel;
      IPv4BroadcastAddressEdit: TEdit;
      IPv4BroadcastAddressLabel: TLabel;
      IPv4HostQuantityEdit: TEdit;
      IPv4HostQuantityLabel: TLabel;
    IPv6Panel: TPanel;
      IPv6AddressEdit: TEdit;
      IPv6AddressLabel: TLabel;
      IPv6OffsetEdit: TEdit;
      IPv6OffsetLabel: TLabel;
      IPv6PrefixEdit: TEdit;
      IPv6PrefixLabel: TLabel;
      IPv6PrefixLengthEdit: TEdit;
      IPv6PrefixLengthLabel: TLabel;
      IPv6NetworkEdit: TEdit;
      IPv6NetworkLabel: TLabel;
      IPv6FirstAddressEdit: TEdit;
      IPv6FirstAddressLabel: TLabel;
      IPv6LastAddressEdit: TEdit;
      IPv6LastAddressLabel: TLabel;
      IPv6HostQuantityEdit: TEdit;
      IPv6HostQuantityLabel: TLabel;
    StatusPanel: TPanel;
      StatusCastPanel: TPanel;
        StatusCastLabel: TLabel;
      StatusScopePanel: TPanel;
        StatusScopeLabel: TLabel;
      StatusDescriptionPanel: TPanel;
        StatusDescriptionLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure ClearMenuItemClick(Sender: TObject);
    procedure ExitMenuItemClick(Sender: TObject);
    procedure IPMenuItemClick(Sender: TObject);
    procedure AboutMenuItemClick(Sender: TObject);
    procedure HelpMenuItemClick(Sender: TObject);
    procedure KeyImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyImageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure IPv4EditExit(Sender: TObject);
    procedure IPv6EditExit(Sender: TObject);
  private
    FAbout: TAboutForm;
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
    FColonX2: Boolean;
    FCopyrights: string;
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
  FAbout := TAboutForm.Create(self);
  FAbout.AboutImage.ImageCollection := ApplicationImageCollection;
  FAbout.AboutImage.ImageName := 'IPvX';
  FIPVersion := 4;
  Width := 478;
  FIPv4ActiveEdit := IPv4AddressEdit;
  FIPv6ActiveEdit := IPv6AddressEdit;
  FIPv4 := TIPv4.Create;
  FIPv6 := TIPv6.Create;
  FColonX2 := False;
  IPv6Update;
  IPv4Update;
  FCopyrights := 'Copyright: UI.pas, IP.pas (c) 2010 - 2023 by Ron Maupin' + #13#10 +
                 'Copyright: Velthuis.BigIntegers.pas (c) 2015,2016,2017 Rudy Velthuis';
end;

procedure TUIForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    vk0, vkNumpad0:       if (not ((ssShift in Shift) or (ssAlt in Shift) or (ssCtrl in Shift))) then begin
                            KeyImage0.ImageName := 'Dn0';
                          end
                          else begin
                            Key := 0;
                          end;
    vk1, vkNumpad1:       if (not ((ssShift in Shift) or (ssAlt in Shift) or (ssCtrl in Shift))) then begin
                            KeyImage1.ImageName := 'Dn1';
                          end
                          else begin
                            Key := 0;
                          end;
    vk2, vkNumpad2:       if (not ((ssShift in Shift) or (ssAlt in Shift) or (ssCtrl in Shift))) then begin
                            KeyImage2.ImageName := 'Dn2';
                          end
                          else begin
                            Key := 0;
                          end;
    vk3, vkNumpad3:       if (not ((ssShift in Shift) or (ssAlt in Shift) or (ssCtrl in Shift))) then begin
                            KeyImage3.ImageName := 'Dn3';
                          end
                          else begin
                            Key := 0;
                          end;
    vk4, vkNumpad4:       if (not ((ssShift in Shift) or (ssAlt in Shift) or (ssCtrl in Shift))) then begin
                            KeyImage4.ImageName := 'Dn4';
                          end
                          else begin
                            Key := 0;
                            if ((ssAlt in Shift) and (not ((ssShift in Shift) or (ssCtrl in Shift)))) then begin
                              IPMenuItemClick(IPv4MenuItem);
                            end;
                          end;
    vk5, vkNumpad5:       if (not ((ssShift in Shift) or (ssAlt in Shift) or (ssCtrl in Shift))) then begin
                            KeyImage5.ImageName := 'Dn5';
                          end
                          else begin
                            Key := 0;
                          end;
    vk6, vkNumpad6:       if (not ((ssShift in Shift) or (ssAlt in Shift) or (ssCtrl in Shift))) then begin
                            KeyImage6.ImageName := 'Dn6';
                          end
                          else begin
                            Key := 0;
                            if ((ssAlt in Shift) and (not ((ssShift in Shift) or (ssCtrl in Shift)))) then begin
                              IPMenuItemClick(IPv6MenuItem);
                            end;
                          end;
    vk7, vkNumpad7:       if (not ((ssShift in Shift) or (ssAlt in Shift) or (ssCtrl in Shift))) then begin
                            KeyImage7.ImageName := 'Dn7';
                          end
                          else begin
                            Key := 0;
                          end;
    vk8, vkNumpad8:       if (not ((ssShift in Shift) or (ssAlt in Shift) or (ssCtrl in Shift))) then begin
                            KeyImage8.ImageName := 'Dn8';
                          end
                          else begin
                            Key := 0;
                          end;
    vk9, vkNumpad9:       if (not ((ssShift in Shift) or (ssAlt in Shift) or (ssCtrl in Shift))) then begin
                            KeyImage9.ImageName := 'Dn9';
                          end
                          else begin
                            Key := 0;
                          end;
    vkA:                  if (not ((ssAlt in Shift) or (ssCtrl in Shift))) then begin
                            if (FIPVersion = 6) then begin
                              KeyImageA.ImageName := 'DnA';
                            end;
                          end
                          else if (ssAlt in Shift) then begin
                            Key := 0;
                            if (not ((ssShift in Shift) or (ssCtrl in Shift))) then begin
                              AboutMenuItemClick(AboutMenuItem);
                            end;
                          end;
    vkB:                  if (not ((ssAlt in Shift) or (ssCtrl in Shift))) then begin
                            KeyImageB.ImageName := 'DnB';
                          end
                          else begin
                            Key := 0;
                          end;
    vkC:                  if (not ((ssAlt in Shift) or (ssCtrl in Shift))) then begin
                            KeyImageC.ImageName := 'DnC';
                          end
                          else if (ssAlt in Shift) then begin
                            Key := 0;
                          end;
    vkD:                  if (not ((ssAlt in Shift) or (ssCtrl in Shift))) then begin
                            KeyImageD.ImageName := 'DnD';
                          end
                          else begin
                            Key := 0;
                          end;
    vkE:                  if (not ((ssAlt in Shift) or (ssCtrl in Shift))) then begin
                            KeyImageE.ImageName := 'DnE';
                          end
                          else begin
                            Key := 0;
                          end;
    vkF:                  if (not ((ssAlt in Shift) or (ssCtrl in Shift))) then begin
                            KeyImageF.ImageName := 'DnF';
                          end
                          else begin
                            Key := 0;
                          end;
    vkPeriod, vkDecimal:  if (not ((ssShift in Shift) or (ssAlt in Shift) or (ssCtrl in Shift))) then begin
                            KeyImageDot.ImageName := 'DnDot';
                          end
                          else begin
                            Key := 0;
                          end;
    vkSemicolon:          if ((ssShift in Shift) and (not ((ssAlt in Shift) or (ssCtrl in Shift)))) then begin
                            if FColonX2 then begin
                              KeyImageColonX2.ImageName := 'DnColonX2';
                            end
                            else begin
                              KeyImageColon.ImageName := 'DnColon';
                            end;
                            FColonX2 := False;
                          end
                          else begin
                            Key := 0;
                          end;
    vkSlash, vkDivide:    if (not ((ssShift in Shift) or (ssAlt in Shift) or (ssCtrl in Shift))) then begin
                            KeyImageSlash.ImageName := 'DnSlash';
                          end
                          else begin
                            Key := 0;
                          end;
    vkBack:               if (not ((ssShift in Shift) or (ssAlt in Shift) or (ssCtrl in Shift))) then begin
                            KeyImageBack.ImageName := 'DnBack';
                          end
                          else begin
                            Key := 0;
                          end;
    vkF1:                 if ((ssShift in Shift) or (ssAlt in Shift) or (ssCtrl in Shift)) then begin
                            Key := 0;
                          end;
    vkInsert:             if ((ssShift in Shift) or (ssAlt in Shift) or (ssCtrl in Shift)) then begin
                            Key := 0;
                          end;
    vkDelete:             if ((ssShift in Shift) or (ssAlt in Shift) or (ssCtrl in Shift)) then begin
                            Key := 0;
                          end;
    vkHome:               if ((ssAlt in Shift) or (ssCtrl in Shift)) then begin
                            Key := 0;
                          end;
    vkEnd:                if ((ssAlt in Shift) or (ssCtrl in Shift)) then begin
                            Key := 0;
                          end;
    vkPrior:              begin
                            Key := 0;
                            if (not ((ssShift in Shift) or (ssAlt in Shift) or (ssCtrl in Shift))) then begin
                              case FIPVersion of
                                4: ActiveControl := IPv4AddressEdit;
                                6: ActiveControl := IPv6AddressEdit;
                              end;
                            end;
                          end;
    vkNext:               begin
                            Key := 0;
                            if (not ((ssShift in Shift) or (ssAlt in Shift) or (ssCtrl in Shift))) then begin
                              case FIPVersion of
                                4: ActiveControl := IPv4HostQuantityEdit;
                                6: ActiveControl := IPv6HostQuantityEdit;
                              end;
                            end;
                          end;
    vkUp:                 begin
                            Key := 0;
                            if (not ((ssAlt in Shift) or (ssCtrl in Shift))) then begin
                              SelectNext(ActiveControl, (ssShift in Shift), True);
                            end;
                          end;
    vkDown:               begin
                            Key := 0;
                            if (not ((ssAlt in Shift) or (ssCtrl in Shift))) then begin
                              SelectNext(ActiveControl, (not (ssShift in Shift)), True);
                            end;
                          end;
    vkLeft:               if ((ssAlt in Shift) or (ssCtrl in Shift)) then begin
                            Key := 0;
                          end;
    vkRight:              if ((ssAlt in Shift) or (ssCtrl in Shift)) then begin
                            Key := 0;
                          end;
    vkH:                  begin
                            Key := 0;
                            if ((ssAlt in Shift) and (not ((ssShift in Shift) or (ssCtrl in Shift)))) then begin
                              HelpMenuItemClick(HelpMenuItem);
                            end;
                          end;
    vkX:                  begin
                            Key := 0;
                            if ((ssAlt in Shift) and (not ((ssShift in Shift) or (ssCtrl in Shift)))) then begin
                              Close;
                            end;
                          end;
  else
    Key := 0;
  end;
end;

procedure TUIForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    '!': Key := #0;
    '@': Key := #0;
    '#': Key := #0;
    '$': Key := #0;
    '%': Key := #0;
    '^': Key := #0;
    '&': Key := #0;
    '*': Key := #0;
    '(': Key := #0;
    ')': Key := #0;
    ';': Key := #0;
    '>': Key := #0;
    '?': Key := #0;
    'A': Key := 'a';
    'B': Key := 'b';
    'C': Key := 'c';
    'D': Key := 'd';
    'E': Key := 'e';
    'F': Key := 'f';
    'H': Key := #0;
    'h': Key := #0;
    'V': Key := #0;
    'v': Key := #0;
    'X': Key := #0;
    'x': Key := #0;
    'Z': Key := #0;
    'z': Key := #0;
  end;
  if (FIPVersion = 4) then begin
    case Key of
      'a': Key := #0;
      'b': Key := #0;
      'c': Key := #0;
      'd': Key := #0;
      'e': Key := #0;
      'f': Key := #0;
    end;
  end;
end;

procedure TUIForm.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
begin
  Handled := True;
  case Msg.CharCode of
    vk0, vkNumpad0:       Handled := False;
    vk1, vkNumpad1:       Handled := False;
    vk2, vkNumpad2:       Handled := False;
    vk3, vkNumpad3:       Handled := False;
    vk4, vkNumpad4:       Handled := False;
    vk5, vkNumpad5:       Handled := False;
    vk6, vkNumpad6:       Handled := False;
    vk7, vkNumpad7:       Handled := False;
    vk8, vkNumpad8:       Handled := False;
    vk9, vkNumpad9:       Handled := False;
    vkA:                  Handled := False;
    vkB:                  if (FIPVersion = 6) then begin
                            Handled := False;
                          end;
    vkC:                  Handled := False;
    vkD:                  if (FIPVersion = 6) then begin
                            Handled := False;
                          end;
    vkE:                  if (FIPVersion = 6) then begin
                            Handled := False;
                          end;
    vkF:                  if (FIPVersion = 6) then begin
                            Handled := False;
                          end;
    vkSlash, vkDivide:    Handled := False;
    vkPeriod, vkDecimal:  Handled := False;
    vkSemicolon:          if (FIPVersion = 6) then begin
                            Handled := False;
                          end;
    vkReturn, vkTab:      begin
                            KeyImageEnter.ImageName := 'DnEnter';
                            Msg.CharCode := vkTab;
                            Handled := False;
                          end;
    vkEscape:             begin
                            KeyImageClear.ImageName := 'DnClr';
                            ClearMenuItemClick(Self);
                          end;
    vkBack:               Handled := False;
    vkF1:                 Handled := False;
    vkHome:               Handled := False;
    vkEnd:                Handled := False;
    vkInsert:             Handled := False;
    vkDelete:             Handled := False;
    vkPrior:              Handled := False;
    vkNext:               Handled := False;
    vkUp:                 Handled := False;
    vkDown:               Handled := False;
    vkLeft:               Handled := False;
    vkRight:              Handled := False;
    vkH:                  Handled := False;
    vkV:                  Handled := False;
    vkX:                  Handled := False;
    vkZ:                  Handled := False;
  end;
end;

procedure TUIForm.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  KeyImage0.ImageName         := 'Up0';
  KeyImage1.ImageName         := 'Up1'; 
  KeyImage2.ImageName         := 'Up2'; 
  KeyImage3.ImageName         := 'Up3'; 
  KeyImage4.ImageName         := 'Up4'; 
  KeyImage5.ImageName         := 'Up5'; 
  KeyImage6.ImageName         := 'Up6'; 
  KeyImage7.ImageName         := 'Up7'; 
  KeyImage8.ImageName         := 'Up8'; 
  KeyImage9.ImageName         := 'Up9'; 
  KeyImageDot.ImageName       := 'UpDot';
  KeyImageSlash.ImageName     := 'UpSlash';
  KeyImageClear.ImageName     := 'UpClr';
  KeyImageBack.ImageName      := 'UpBack';
  KeyImageEnter.ImageName     := 'UpEnter';
  if FIPVersion = 4 then begin
    IPLabel.Caption           := 'IPv4';
    KeyImageA.ImageName       := 'BaseA';
    KeyImageB.ImageName       := 'BaseB';
    KeyImageC.ImageName       := 'BaseC';
    KeyImageD.ImageName       := 'BaseD';
    KeyImageE.ImageName       := 'BaseE';
    KeyImageF.ImageName       := 'BaseF';
    KeyImageColon.ImageName   := 'BaseColon';
    KeyImageColonX2.ImageName := 'BaseColonX2';
  end
  else begin
    IPLabel.Caption           := 'IPv6';
    KeyImageA.ImageName       := 'UpA';
    KeyImageB.ImageName       := 'UpB';
    KeyImageC.ImageName       := 'UpC';
    KeyImageD.ImageName       := 'UpD';
    KeyImageE.ImageName       := 'UpE';
    KeyImageF.ImageName       := 'UpF';
    KeyImageColon.ImageName   := 'UpColon';
    KeyImageColonX2.ImageName := 'UpColonX2';
  end;
end;

procedure TUIForm.FormDestroy(Sender: TObject);
begin
  FAbout.Free;
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
      ActiveControl := IPv4AddressEdit;
    end;
    6: begin
      FIPv6.Clear;
      IPv6Update;
      ActiveControl := IPv6AddressEdit;
    end;
  end;
  (ActiveControl as TEdit).SelectAll;
end;

procedure TUIForm.ExitMenuItemClick(Sender: TObject);
begin
  Close;
end;

procedure TUIForm.IPMenuItemClick(Sender: TObject);
var
  w: Word;
begin
  if (Sender = IPv4MenuItem) then begin
    if (FIPVersion = 6) then begin
      IPv4MenuItem.Checked      := True;
      FIPv6ActiveEdit           := (ActiveControl as TEdit);
      FIPVersion                := 4;
      IPv6Panel.Visible         := False;
      IPv4Panel.Visible         := True;
      Width                     := 480;
      ActiveControl             := FIPv4ActiveEdit;
      IPv4Update;
    end;
  end
  else if (Sender = IPv6MenuItem) then begin
    if (FIPVersion = 4) then begin
      IPv6MenuItem.Checked      := True;
      FIPv4ActiveEdit           := (ActiveControl as TEdit);
      FIPVersion                := 6;
      IPv4Panel.Visible         := False;
      IPv6Panel.Visible         := True;
      Width                     := 960;
      ActiveControl             := FIPv6ActiveEdit;
      IPv6Update;
    end;
  end;
  FormKeyUp(Sender, w, []);
  (ActiveControl as TEdit).SelectAll;
end;

procedure TUIForm.HelpMenuItemClick(Sender: TObject);
begin
  Application.HelpContext(0);
end;

procedure TUIForm.AboutMenuItemClick(Sender: TObject);
begin
  FAbout.ShowModal;
end;

{$ENDREGION}

{$REGION 'Keypad'}

procedure TUIForm.KeyImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if ((Button = mbLeft) and (not ((ssShift in Shift) or (ssAlt in Shift) or (ssCtrl in Shift)))) then begin
    if (Sender = KeyImage0) then begin
      keybd_event(VK_NUMPAD0, MapVirtualKey(VK_NUMPAD0, 0), 0, 0);
    end
    else if (Sender = KeyImage1) then begin
      keybd_event(VK_NUMPAD1, MapVirtualKey(VK_NUMPAD1, 0), 0, 0);
    end
    else if (Sender = KeyImage2) then begin
      keybd_event(VK_NUMPAD2, MapVirtualKey(VK_NUMPAD2, 0), 0, 0);
    end
    else if (Sender = KeyImage3) then begin
      keybd_event(VK_NUMPAD3, MapVirtualKey(VK_NUMPAD3, 0), 0, 0);
    end
    else if (Sender = KeyImage4) then begin
      keybd_event(VK_NUMPAD4, MapVirtualKey(VK_NUMPAD4, 0), 0, 0);
    end
    else if (Sender = KeyImage5) then begin
      keybd_event(VK_NUMPAD5, MapVirtualKey(VK_NUMPAD5, 0), 0, 0);
    end
    else if (Sender = KeyImage6) then begin
      keybd_event(VK_NUMPAD6, MapVirtualKey(VK_NUMPAD6, 0), 0, 0);
    end
    else if (Sender = KeyImage7) then begin
      keybd_event(VK_NUMPAD7, MapVirtualKey(VK_NUMPAD7, 0), 0, 0);
    end
    else if (Sender = KeyImage8) then begin
      keybd_event(VK_NUMPAD8, MapVirtualKey(VK_NUMPAD8, 0), 0, 0);
    end
    else if (Sender = KeyImage9) then begin
      keybd_event(VK_NUMPAD9, MapVirtualKey(VK_NUMPAD9, 0), 0, 0);
    end
    else if (Sender = KeyImageDot) then begin
      keybd_event(VK_DECIMAL, MapVirtualKey(VK_DECIMAL, 0), 0, 0);
    end
    else if (Sender = KeyImageSlash) then begin
      keybd_event(VK_DIVIDE, MapVirtualKey(VK_DIVIDE, 0), 0, 0);
    end
    else if (Sender = KeyImageEnter) then begin
      keybd_event(VK_TAB, MapVirtualKey(VK_TAB, 0), 0, 0);
    end
    else if (Sender = KeyImageClear) then begin
      keybd_event(VK_ESCAPE, MapVirtualKey(VK_ESCAPE, 0), 0, 0);
    end
    else if (Sender = KeyImageBack) then begin
      keybd_event(VK_BACK, MapVirtualKey(VK_BACK, 0), 0, 0);
    end
    else if (FIPVersion = 6) then begin
      if (Sender = KeyImageA) then begin
        keybd_event(Ord('A'), MapVirtualKey(Ord('A'), 0), 0, 0);
      end
      else if (Sender = KeyImageB) then begin
        keybd_event(Ord('B'), MapVirtualKey(Ord('B'), 0), 0, 0);
      end
      else if (Sender = KeyImageC) then begin
        keybd_event(Ord('C'), MapVirtualKey(Ord('C'), 0), 0, 0);
      end
      else if (Sender = KeyImageD) then begin
        keybd_event(Ord('D'), MapVirtualKey(Ord('D'), 0), 0, 0);
      end
      else if (Sender = KeyImageE) then begin
        keybd_event(Ord('E'), MapVirtualKey(Ord('E'), 0), 0, 0);
      end
      else if (Sender = KeyImageF) then begin
        keybd_event(Ord('F'), MapVirtualKey(Ord('F'), 0), 0, 0);
      end
      else if (Sender = KeyImageColon) then begin
        keybd_event(VK_SHIFT, MapVirtualKey(VK_SHIFT, 0), 0, 0);
        keybd_event(vkSemicolon, MapVirtualKey(vkSemicolon, 0), 0, 0);
      end
      else if (Sender = KeyImageColonX2) then begin
        keybd_event(VK_SHIFT, MapVirtualKey(VK_SHIFT, 0), 0, 0);
        FColonX2 := True;
        keybd_event(vkSemicolon, MapVirtualKey(vkSemicolon, 0), 0, 0);
        FColonX2 := True;
        keybd_event(vkSemicolon, MapVirtualKey(vkSemicolon, 0), 0, 0);
      end;
    end;
  end;
end;

procedure TUIForm.KeyImageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Sender = KeyImage0) then begin
    keybd_event(VK_NUMPAD0, MapVirtualKey(VK_NUMPAD0, 0), KEYEVENTF_KEYUP, 0);
  end
  else if (Sender = KeyImage1) then begin
    keybd_event(VK_NUMPAD1, MapVirtualKey(VK_NUMPAD1, 0), KEYEVENTF_KEYUP, 0);
  end
  else if (Sender = KeyImage2) then begin
    keybd_event(VK_NUMPAD2, MapVirtualKey(VK_NUMPAD2, 0), KEYEVENTF_KEYUP, 0);
  end
  else if (Sender = KeyImage3) then begin
    keybd_event(VK_NUMPAD3, MapVirtualKey(VK_NUMPAD3, 0), KEYEVENTF_KEYUP, 0);
  end
  else if (Sender = KeyImage4) then begin
    keybd_event(VK_NUMPAD4, MapVirtualKey(VK_NUMPAD4, 0), KEYEVENTF_KEYUP, 0);
  end
  else if (Sender = KeyImage5) then begin
    keybd_event(VK_NUMPAD5, MapVirtualKey(VK_NUMPAD5, 0), KEYEVENTF_KEYUP, 0);
  end
  else if (Sender = KeyImage6) then begin
    keybd_event(VK_NUMPAD6, MapVirtualKey(VK_NUMPAD6, 0), KEYEVENTF_KEYUP, 0);
  end
  else if (Sender = KeyImage7) then begin
    keybd_event(VK_NUMPAD7, MapVirtualKey(VK_NUMPAD7, 0), KEYEVENTF_KEYUP, 0);
  end
  else if (Sender = KeyImage8) then begin
    keybd_event(VK_NUMPAD8, MapVirtualKey(VK_NUMPAD8, 0), KEYEVENTF_KEYUP, 0);
  end
  else if (Sender = KeyImage9) then begin
    keybd_event(VK_NUMPAD9, MapVirtualKey(VK_NUMPAD9, 0), KEYEVENTF_KEYUP, 0);
  end
  else if (Sender = KeyImageDot) then begin
    keybd_event(VK_DECIMAL, MapVirtualKey(VK_DECIMAL, 0), KEYEVENTF_KEYUP, 0);
  end
  else if (Sender = KeyImageSlash) then begin
    keybd_event(VK_DIVIDE, MapVirtualKey(VK_DIVIDE, 0), KEYEVENTF_KEYUP, 0);
  end
  else if (Sender = KeyImageEnter) then begin
    keybd_event(VK_TAB, MapVirtualKey(VK_TAB, 0), KEYEVENTF_KEYUP, 0);
  end
  else if (Sender = KeyImageClear) then begin
    keybd_event(VK_ESCAPE, MapVirtualKey(VK_ESCAPE, 0), KEYEVENTF_KEYUP, 0);
  end
  else if (Sender = KeyImageBack) then begin
    keybd_event(VK_BACK, MapVirtualKey(VK_BACK, 0), KEYEVENTF_KEYUP, 0);
  end
  else if (FIPVersion = 6) then begin
    if (Sender = KeyImageA) then begin
      keybd_event(Ord('A'), MapVirtualKey(Ord('A'), 0), KEYEVENTF_KEYUP, 0);
    end
    else if (Sender = KeyImageB) then begin
      keybd_event(Ord('B'), MapVirtualKey(Ord('B'), 0), KEYEVENTF_KEYUP, 0);
    end
    else if (Sender = KeyImageC) then begin
      keybd_event(Ord('C'), MapVirtualKey(Ord('C'), 0), KEYEVENTF_KEYUP, 0);
    end
    else if (Sender = KeyImageD) then begin
      keybd_event(Ord('D'), MapVirtualKey(Ord('D'), 0), KEYEVENTF_KEYUP, 0);
    end
    else if (Sender = KeyImageE) then begin
      keybd_event(Ord('E'), MapVirtualKey(Ord('E'), 0), KEYEVENTF_KEYUP, 0);
    end
    else if (Sender = KeyImageF) then begin
      keybd_event(Ord('F'), MapVirtualKey(Ord('F'), 0), KEYEVENTF_KEYUP, 0);
    end
    else if (Sender = KeyImageColon) then begin
      keybd_event(vkSemicolon, MapVirtualKey(vkSemicolon, 0), KEYEVENTF_KEYUP, 0);
      keybd_event(VK_SHIFT, MapVirtualKey(VK_SHIFT, 0), KEYEVENTF_KEYUP, 0);
    end
    else if (Sender = KeyImageColonX2) then begin
      keybd_event(vkSemicolon, MapVirtualKey(vkSemicolon, 0), KEYEVENTF_KEYUP, 0);
      keybd_event(VK_SHIFT, MapVirtualKey(VK_SHIFT, 0), KEYEVENTF_KEYUP, 0);
    end;
  end;
end;

{$ENDREGION}

{$REGION 'IPv4'}

procedure TUIForm.IPv4EditExit(Sender: TObject);
var
  w: Word;
begin
  try
    if (Sender = IPv4AddressEdit) then begin
      FIPv4.Address := IPv4AddressEdit.Text;
    end
    else if (Sender = IPv4NetworkMaskEdit) then begin
      FIPv4.NetMask := IPv4NetworkMaskEdit.Text;
    end
    else if (Sender = IPv4HostMaskEdit) then begin
      FIPv4.HostMask := IPv4HostMaskEdit.Text;
    end
    else if (Sender = IPv4OffsetEdit) then begin
      FIPv4.Offset := IPv4OffsetEdit.Text;
    end
    else if (Sender = IPv4PrefixEdit) then begin
      FIPv4.Prefix := IPv4PrefixEdit.Text;
    end
    else if (Sender = IPv4PrefixLengthEdit) then begin
      FIPv4.NetLength := IPv4PrefixLengthEdit.Text;
    end
    else if (Sender = IPv4NetworkEdit) then begin
      FIPv4.Network := IPv4NetworkEdit.Text;
    end
  except
    on E: Exception do begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
      FormKeyUp(Sender, w, []);
      if (Sender as TEdit).CanFocus then begin
        (Sender as TEdit).SetFocus;
        (Sender as TEdit).Undo;
        (Sender as TEdit).SelectAll;
      end;
    end;
  end;
  IPv4Update;
end;

procedure TUIForm.IPv4Update();
begin
  IPv4AddressEdit.Text          := FIPv4.Address;
  IPv4NetworkMaskEdit.Text      := FIPv4.NetMask;
  IPv4HostMaskEdit.Text         := FIPv4.HostMask;
  IPv4OffsetEdit.Text           := FIPv4.Offset;
  IPv4PrefixEdit.Text           := FIPv4.Prefix;
  IPv4PrefixLengthEdit.Text     := FIPv4.NetLength;
  IPv4NetworkEdit.Text          := FIPv4.Network;
  IPv4FirstAddressEdit.Text     := FIPv4.First;
  IPv4LastAddressEdit.Text      := FIPv4.Last;
  IPv4BroadcastAddressEdit.Text := FIPv4.Broadcast;
  IPv4HostQuantityEdit.Text     := FIPv4.HostQty;
  IPv4UpdateStatus;
end;

procedure TUIForm.IPv4UpdateStatus();
begin
  if TIPv4.IsUnicast(FIPv4.Address) then begin
    FIPv4Cast := 'Unicast';
    if ((FIPv4.Address = FIPv4.Network) and (FIPv4.NetLength.ToInteger < 31)) then begin
      FIPv4Scope       := 'Link-Local';
      FIPv4Description := 'Network Address';
    end
    else if ((FIPv4.Address = FIPv4.Broadcast) and (FIPv4.NetLength.ToInteger < 31)) then begin
      FIPv4Cast        := 'Broadcast';
      FIPv4Scope       := 'Link-Local';
      FIPv4Description := 'Network Broadcast';
    end
    else begin
      if TIPv4.IsInRange(FIPv4.Address, '0.0.0.0/32') then begin
        FIPv4Scope       := 'Link-Local';
        FIPv4Description := 'This host on this network';
      end
      else if TIPv4.IsInRange(FIPv4.Address, '0.0.0.0/8') then begin
        FIPv4Scope       := 'Link-Local';
        FIPv4Description := 'This network';
      end
      else if TIPv4.IsInRange(FIPv4.Address, '10.0.0.0/8') then begin
        FIPv4Scope       := 'Organization-Local';
        FIPv4Description := 'Private-Use';
      end
      else if TIPv4.IsInRange(FIPv4.Address, '100.64.0.0/10') then begin
        FIPv4Scope       := 'Organization-Local';
        FIPv4Description := 'ISP Shared Address Space';
      end
      else if TIPv4.IsInRange(FIPv4.Address, '127.0.0.0/8') then begin
        FIPv4Scope       := 'Host-Local';
        FIPv4Description := 'Loopback';
      end
      else if TIPv4.IsInRange(FIPv4.Address, '169.254.0.0/16') then begin
        FIPv4Scope       := 'Link-Local';
        FIPv4Description := 'Link-Local';
      end
      else if TIPv4.IsInRange(FIPv4.Address, '172.16.0.0/12') then begin
        FIPv4Scope       := 'Organization-Local';
        FIPv4Description := 'Private-Use';
      end
      else if TIPv4.IsInRange(FIPv4.Address, '192.0.0.0/24') then begin
        if TIPv4.IsInRange(FIPv4.Address, '192.0.0.0/29') then begin
          FIPv4Scope       := 'Organization-Local';
          FIPv4Description := 'IPv4 Service Continuity Prefix';
        end
        else if TIPv4.IsInRange(FIPv4.Address, '192.0.0.8/32') then begin
          FIPv4Scope       := 'N/A';
          FIPv4Description := 'IPv4 dummy address';
        end
        else if TIPv4.IsInRange(FIPv4.Address, '192.0.0.9/32') then begin
          FIPv4Scope       := 'Global';
          FIPv4Description := 'Port Control Protocol Anycast';
        end
        else if TIPv4.IsInRange(FIPv4.Address, '192.0.0.10/32') then begin
          FIPv4Scope       := 'Global';
          FIPv4Description := 'Traversal Using Relays around NAT Anycast';
        end
        else if TIPv4.IsInRange(FIPv4.Address, '192.0.0.170/31') then begin
          FIPv4Scope       := 'N/A';
          FIPv4Description := 'NAT64/DNS64 Discovery';
        end
        else begin
          FIPv4Scope       := 'Reserved';
          FIPv4Description := 'IETF Protocol Assignments';
        end;
      end
      else if TIPv4.IsInRange(FIPv4.Address, '192.0.2.0/24') then begin
        FIPv4Scope       := 'Reserved';
        FIPv4Description := 'Documentation (TEST-NET-1)';
      end
      else if TIPv4.IsInRange(FIPv4.Address, '192.31.196.0/24') then begin
        FIPv4Scope       := 'Global';
        FIPv4Description := 'AS112-v4';
      end
      else if TIPv4.IsInRange(FIPv4.Address, '192.52.193.0/24') then begin
        FIPv4Scope       := 'Global';
        FIPv4Description := 'AMT';
      end
      else if TIPv4.IsInRange(FIPv4.Address, '192.168.0.0/16') then begin
        FIPv4Scope       := 'Organization-Local';
        FIPv4Description := 'Private-Use';
      end
      else if TIPv4.IsInRange(FIPv4.Address, '192.175.48.0/24') then begin
        FIPv4Scope       := 'Global';
        FIPv4Description := 'Direct Delegation AS112 Service';
      end
      else if TIPv4.IsInRange(FIPv4.Address, '198.18.0.0/15') then begin
        FIPv4Scope       := 'Organization-Local';
        FIPv4Description := 'Benchmarking';
      end
      else if TIPv4.IsInRange(FIPv4.Address, '198.51.100.0/24') then begin
        FIPv4Scope       := 'Reserved';
        FIPv4Description := 'Documentation (TEST-NET-2)';
      end
      else if TIPv4.IsInRange(FIPv4.Address, '203.0.113.0/24') then begin
        FIPv4Scope       := 'Reserved';
        FIPv4Description := 'Documentation (TEST-NET-3)';
      end
      else begin
        FIPv4Scope       := 'Global';
        FIPv4Description := 'Public Addresses';
      end;
    end;
  end
  else if TIPv4.IsMulticast(FIPv4.Address) then begin
    FIPv4Cast  := 'Multicast';
    if TIPv4.IsInRange(FIPv4.Address, '224.0.0.0/16') then begin
      if TIPv4.IsInRange(FIPv4.Address, '224.0.0.0/24') then begin
        FIPv4Scope       := 'Link-Local';
        FIPv4Description := 'Local Network Control Block';
      end
      else if TIPv4.IsInRange(FIPv4.Address, '224.0.1.0/24') then begin
        FIPv4Scope       := 'Global';
        FIPv4Description := 'Internetwork Control Block';
      end
      else begin
        FIPv4Scope       := 'Global';
        FIPv4Description := 'AD-HOC Block I';
      end;
    end
    else if TIPv4.IsInRange(FIPv4.Address, '224.2.0.0/16') then begin
      FIPv4Scope       := 'Global';
      FIPv4Description := 'SDP/SAP Block';
    end
    else if TIPv4.IsInRange(FIPv4.Address, '224.3.0.0/15') then begin
      FIPv4Scope       := 'Global';
      FIPv4Description := 'AD-HOC Block II';
    end
    else if TIPv4.IsInRange(FIPv4.Address, '224.252.0.0/14') then begin
      FIPv4Scope       := 'Global';
      FIPv4Description := 'DIS Transient Groups';
    end
    else if TIPv4.IsInRange(FIPv4.Address, '232.0.0.0/8') then begin
      FIPv4Scope       := 'Global';
      FIPv4Description := 'Source-Specific Multicast Block';
    end
    else if TIPv4.IsInRange(FIPv4.Address, '233.0.0.0/8') then begin
      FIPv4Scope       := 'Global';
      if TIPv4.IsInRange(FIPv4.Address, '233.252.0.0/14') then begin
        FIPv4Description := 'AD-HOC Block III';
      end
      else begin
        FIPv4Description := 'GLOP Block';
      end;
    end
    else if TIPv4.IsInRange(FIPv4.Address, '234.0.0.0/8') then begin
      FIPv4Scope       := 'Global';
      FIPv4Description := 'Unicast-Prefix-based';
    end
    else if TIPv4.IsInRange(FIPv4.Address, '239.0.0.0/8') then begin
      FIPv4Scope       := 'Organization-Local';
      FIPv4Description := 'Organization-Local Scope';
    end
    else begin
      FIPv4Scope       := 'Reserved';
      FIPv4Description := 'Reserved';
    end;
  end
  else if TIPv4.IsReserved(FIPv4.Address) then begin
    if (FIPv4.Address = '255.255.255.255') then begin
      FIPv4Cast        := 'Broadcast';
      FIPv4Scope       := 'Link-Local';
      FIPv4Description := 'Limited Broadcast';
    end
    else begin
      FIPv4Cast        := 'Reserved';
      FIPv4Scope       := 'Reserved';
      FIPv4Description := 'Reserved';
    end;
  end;
  StatusCastLabel.Caption        := FIPv4Cast;
  StatusScopeLabel.Caption       := FIPv4Scope;
  StatusDescriptionLabel.Caption := FIPv4Description;
end;

{$ENDREGION}

{$REGION 'IPv6'}

procedure TUIForm.IPv6EditExit(Sender: TObject);
var
  w: Word;
begin
  try
    if (Sender = IPv6AddressEdit) then begin
      FIPv6.Address := IPv6AddressEdit.Text;
    end
    else if (Sender = IPv6OffsetEdit) then begin
      FIPv6.Offset := IPv6OffsetEdit.Text;
    end
    else if (Sender = IPv6PrefixEdit) then begin
      FIPv6.Prefix  := IPv6PrefixEdit.Text;
    end
    else if (Sender = IPv6PrefixLengthEdit) then begin
      FIPv6.NetLength := IPv6PrefixLengthEdit.Text;
    end
    else if (Sender = IPv6NetworkEdit) then begin
      FIPv6.Network := IPv6NetworkEdit.Text;
    end;
  except
    on E: Exception do begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
      FormKeyUp(Sender, w, []);
      if (Sender as TEdit).CanFocus then begin
        (Sender as TEdit).SetFocus;
        (Sender as TEdit).Undo;
        (Sender as TEdit).SelectAll;
      end;
    end;
  end;
  IPv6Update;
end;

procedure TUIForm.IPv6Update();
begin
  IPv6AddressEdit.Text      := FIPv6.Address;
  IPv6OffsetEdit.Text       := FIPv6.Offset;
  IPv6PrefixEdit.Text       := FIPv6.Prefix;
  IPv6PrefixLengthEdit.Text := FIPv6.NetLength;
  IPv6NetworkEdit.Text      := FIPv6.Network;
  IPv6FirstAddressEdit.Text := FIPv6.First;
  IPv6LastAddressEdit.Text  := FIPv6.Last;
  IPv6HostQuantityEdit.Text := FIPv6.HostQty;
  IPv6UpdateStatus;
end;

procedure TUIForm.IPv6UpdateStatus();
var
  c: System.TArray<Char>;
begin
  if TIPv6.IsUnicast(FIPv6.Address) then begin
    FIPv6Cast := 'Unicast';
    if TIPv6.IsInRange(FIPv6.Address, '2000::/3') then begin
      if TIPv6.IsInRange(FIPv6.Address, '2001::/23') then begin
        if TIPv6.IsInRange(FIPv6.Address, '2001::/32') then begin
          FIPv6Scope       := 'Oranization-Local';
          FIPv6Description := 'TEREDO';
        end
        else begin
          FIPv6Scope       := 'Reserved';
          FIPv6Description := 'IETF Protocol Assignments';
        end;
      end
      else if TIPv6.IsInRange(FIPv6.Address, '2001:1::1/128') then begin
        FIPv6Scope       := 'Global';
        FIPv6Description := 'Port Control Protocol Anycast';
      end
      else if TIPv6.IsInRange(FIPv6.Address, '2001:1::2/128') then begin
        FIPv6Scope       := 'Global';
        FIPv6Description := 'Traversal Using Relays around NAT Anycast';
      end
      else if TIPv6.IsInRange(FIPv6.Address, '2001:2::/48') then begin
        FIPv6Scope       := 'Organization-Local';
        FIPv6Description := 'Benchmarking';
      end
      else if TIPv6.IsInRange(FIPv6.Address, '2001:3::/32') then begin
        FIPv6Scope       := 'Global';
        FIPv6Description := 'AMT';
      end
      else if TIPv6.IsInRange(FIPv6.Address, '2001:4:112::/48') then begin
        FIPv6Scope       := 'Global';
        FIPv6Description := 'AS112-v6';
      end
      else if TIPv6.IsInRange(FIPv6.Address, '2001:20::/28') then begin
        FIPv6Scope       := 'Global';
        FIPv6Description := 'ORCHIDv2';
      end
      else if TIPv6.IsInRange(FIPv6.Address, '2001:db8::/32') then begin
        FIPv6Scope       := 'Reserved';
        FIPv6Description := 'Documentation';
      end
      else if TIPv6.IsInRange(FIPv6.Address, '2002::/16') then begin
        FIPv6Scope       := 'Organization-Local';
        FIPv6Description := '6to4';
      end
      else if TIPv6.IsInRange(FIPv6.Address, '2620:4f:8000::/48') then begin
        FIPv6Scope       := 'Global';
        FIPv6Description := 'Direct Delegation AS112 Service';
      end
      else begin
        FIPv6Scope       := 'Global';
        FIPv6Description := 'Public Addresses';
      end;
    end
    else if TIPv6.IsInRange(FIPv6.Address, 'fc00::/8') then begin
      FIPv6Scope       := 'Reserved';
      FIPv6Description := 'Unique-Local';
    end
    else if TIPv6.IsInRange(FIPv6.Address, 'fd00::/8') then begin
      FIPv6Scope       := 'Organization-Local';
      FIPv6Description := 'Unique-Local';
    end
    else if TIPv6.IsInRange(FIPv6.Address, 'fe80::/10') then begin
      FIPv6Scope       := 'Link-Local';
      FIPv6Description := 'Link-Local';
    end;
  end
  else if TIPv6.IsMulticast(FIPv6.Address) then begin
    FIPv6Cast := 'Multicast';
    c := TIPv6.Expand(FIPv6.Address).ToCharArray;
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
    else
      FIPv6Scope := 'Unassigned';
    end;
    case c[2] of
      '0': FIPv6Description := 'Well-Known';
      '1': FIPv6Description := 'Transient';
      '3': FIPv6Description := 'Unicast Prefix-based';
      '7': FIPv6Description := 'Embedded RP';
      '8': FIPv6Description := 'Well-Known';
      '9': FIPv6Description := 'Transient';
      'b': FIPv6Description := 'Unicast Prefix-based';
      'f': FIPv6Description := 'Embedded RP';
    else
      FIPv6Description := 'Invalid Flags';
    end;
    if (c[5] <> '0') then begin
      FIPv6Description := 'Invalid Flags';
    end
    else if ((c[6] <> '0') and (not ((c[2] = '7') or (c[2] = 'f')))) then begin
      FIPv6Description := 'Reserved';
    end;
  end
  else begin
    FIPv6Cast := 'Reserved';
    if TIPv6.IsInRange(FIPv6.Address, '::/128') then begin
      FIPv6Scope       := 'Link-Local';
      FIPv6Description := 'Unspecified Address';
    end
    else if TIPv6.IsInRange(FIPv6.Address, '::1/128') then begin
      FIPv6Scope       := 'Host-Local';
      FIPv6Description := 'Loopback Address';
    end
    else if TIPv6.IsInRange(FIPv6.Address, '::ffff:0:0/96') then begin
      FIPv6Scope       := 'N/A';
      FIPv6Description := 'IPv4-mapped';
    end
    else if (TIPv6.IsInRange(FIPv6.Address, '64:ff9b::/96')) then begin
      FIPv6Scope       := 'Global';
      FIPv6Description := 'IPv4-FIPv6 Translators';
    end
    else if (TIPv6.IsInRange(FIPv6.Address, '64:ff9b:1::/48')) then begin
      FIPv6Scope       := 'Organization-Local';
      FIPv6Description := 'IPv4-FIPv6 Translators';
    end
    else if (TIPv6.IsInRange(FIPv6.Address, '100::/64')) then begin
      FIPv6Scope       := 'Organization-Local';
      FIPv6Description := 'Discard-Only Address Block';
    end
    else begin
      FIPv6Scope       := 'Reserved';
      FIPv6Description := 'Reserved';
    end;
  end;
  StatusCastLabel.Caption        := FIPv6Cast;
  StatusScopeLabel.Caption       := FIPv6Scope;
  StatusDescriptionLabel.Caption := FIPv6Description;
end;

{$ENDREGION}

end.
