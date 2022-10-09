//******************************************************************************
//*                                                                            *
//* File:       IP.pas                                                         *
//*                                                                            *
//******************************************************************************
//*                                                                            *
//* Function:   A library with IPv4 and IPv6 classes that have properties and  *
//*             functions specific to each IP, and it defines an IP Exception. *
//*             The library gets and sets the IP information as strings, but   *
//*             the data are stored internally as integers: 32-bit, unsigned   *
//*             integers for IPv4, and 128-bit, unsigned integers for IPv6.    *
//*             Only the address and mask are stored in the objects; all other *
//*             values are calculated when they are referenced.                *
//*                                                                            *
//*             Attempting to write invalid values, or if the resulting full   *
//*             network range derived from the address and mask does not fall  *
//*             entirely within one of three ranges (unicast, multicast, or    *
//*             reserved), an EIPError exception will result and the values    *
//*             stored in the object will remain unchanged.                    *
//*                                                                            *
//*             Uses the BigIntegers library by Rudy Velthuis for IPv6:        *
//*             (1) https://github.com/rvelthuis/DelphiBigNumbers              *
//*             (2) http://www.rvelthuis.de/programs/bigintegers.html          *
//*                                                                            *
//******************************************************************************
//*                                                                            *
//* Background: IP addresses are actually unsigned integers (32-bit for IPv4   *
//*             and 128-bit for IPv6), but people want to use the text formats *
//*             to view, enter, and manipulate IP addressing. It is the latter *
//*             that causes problems because IP math cannot be reliably done   *
//*             with the text representations of either IP because divisions   *
//*             may happen in the middle of IPv4 octets or IPv6 hexadecimal    *
//*             fields. This is particularly difficult for the IPv4 decimal    *
//*             text representation because conversion between decimal and     *
//*             binary is not natural as it is between hexadecimal and binary. *
//*                                                                            *
//*             I am not sure why, but I have observed many programmers go far *
//*             out of the way to avoid conversion to unsigned integers before *
//*             performing IP math, trying to do it via text manipulation, and *
//*             that is difficult and fraught with mistakes. My goal with this *
//*             library is to hide the IP math behind object properties,       *
//*             allowing the programmers to benefit from proper IP math while  *
//*             using the text representations of IP addressing.               *
//*                                                                            *
//******************************************************************************
//*                                                                            *
//* Language:   Delphi version XE2 or later as required for BigInteger         *
//*                                                                            *
//******************************************************************************
//*                                                                            *
//* Author:     Ron Maupin                                                     *
//*                                                                            *
//******************************************************************************
//*                                                                            *
//* Copyright:  IP.pas (c) 2010 - 2022 by Ron Maupin                           *
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

unit IP;

interface

uses
  System.RegularExpressionsCore, System.SysUtils, Velthuis.BigIntegers;

type

  EIPError = class(Exception);  // Defines the IP exception.

{$REGION 'IPv4 Class'}

//******************************************************************************
//*                                                                            *
//* IPv4: An IPv4 object only stores a 32-bit unsigned integer for the IPv4    *
//*       address and a 32-bit unsigned integer for the IPv4 mask.             *
//*                                                                            *
//*       IPv4 address and mask strings are read and written in the IPv4       *
//*       common dotted-decimal notation (leading zeroes are not permitted in  *
//*       the octets).                                                         *
//*                                                                            *
//*       There are three public methods:                                      *
//*                                                                            *
//*         Create                                                             *
//*           Default address 0.0.0.0 and mask 255.255.255.255, or with a      *
//*           specific address and mask using either CIDR ('x.x.x.x/y') or     *
//*           explicit mask ('x.x.x.x', 'z.z.z.z').                            *
//*                                                                            *
//*         Clear                                                              *
//*           Resets address to 0.0.0.0 and mask to 255.255.255.255.           *
//*                                                                            *
//*         Destroy                                                            *
//*           Destroys the IPv4 object.                                        *
//*                                                                            *
//*       There are four public class boolean functions:                       *
//*                                                                            *
//*         IsUnicast                                                          *
//*           Returns True if the string address parameter falls within the    *
//*           Unicast address range, otherwise returns False.                  *
//*                                                                            *
//*         IsMulticast                                                        *
//*           Returns True if the string address parameter falls within the    *
//*           Multiicast address range, otherwise returns False.               *
//*                                                                            *
//*         IsReserved                                                         *
//*           Returns True if the string address parameter falls within the    *
//*           Reserved address range, otherwise returns False.                 *
//*                                                                            *
//*         IsInRange                                                          *
//*           Returns True if the string address parameter falls within the    *
//*           string prefix parameter, otherwise returns False.                *
//*                                                                            *
//*       There are seven read/write properties:                               *
//*                                                                            *
//*         Address                                                            *
//*           GET string of address value.                                     *
//*           SET address value to new address parameter that may include the  *
//*               mask length that sets mask value).                           *
//*                                                                            *
//*         NetMask                                                            *
//*           GET string of mask value.                                        *
//*           SET mask value to new mask parameter.                            *
//*                                                                            *
//*         HostMask                                                           *
//*           GET string of inverse mask value.                                *
//*             [NOT mask]                                                     *
//*           SET mask value to inverse of new host mask.                      *
//*             [NOT host mask]                                                *
//*                                                                            *
//*         Offset                                                             *
//*           GET integer string of offset from address and mask values.       *
//*             [address AND [NOT mask]]                                       *
//*           SET address to network + offset.                                 *
//*             [[address AND mask] OR offset]                                 *
//*                                                                            *
//*         Prefix                                                             *
//*           GET string prefix from address and mask values.                  *
//*             [address AND mask]/[mask length]                               *
//*           SET address to new prefix parameter + new offset.                *
//*             [[prefix AND new mask] OR [address AND new mask]]              *
//*                                                                            *
//*         NetLength                                                          *
//*           GET integer string of mask length.                               *
//*             [count high-order mask 1 bits]                                 *
//*           SET mask value to high-order net length 1 bits.                  *
//*             [high-order net length 1 bits]                                 *
//*                                                                            *
//*         Network                                                            *
//*           GET string network from address and mask values.                 *
//*             [address AND mask]                                             *
//*           SET address to new network + address offset                      *
//*             [new network OR [address AND [NOT mask]]]                      *
//*                                                                            *
//*       There are four read-only properties:                                 *
//*                                                                            *
//*         First                                                              *
//*           GET string first usable address, network + 1 unless mask >= 31   *
//*               or Muticast or Reserved then network.                        *
//*             [[address AND mask] + 1] or [address AND mask]                 *
//*                                                                            *
//*         Last                                                               *
//*           GET string last usable address, broadcast - 1 unless mask >= 31  *
//*               or Muticast or Reserved then broadcast.                      *
//*             [[address OR [NOT mask]] - 1] or [address OR [NOT mask]]       *
//*                                                                            *
//*         Broadcast                                                          *
//*           GET string broadcast address unless Multicast or Reserved.       *
//*             [address OR [NOT mask]] or N/A                                 *
//*                                                                            *
//*         HostQty                                                            *
//*           GET integer string of usable address quantity, host mask - 1     *
//*               unless mask >= 31 or Muticast or Reserved then host mask + 1 *
//*             [[NOT mask] - 1] or [[NOT mask] + 1]                           *
//*                                                                            *
//******************************************************************************

  TIPv4 = class(TObject)
    private
      type
        TAddr = UInt32;
      var
        FAddr: TAddr;
        FMask: TAddr;
      class function AddrToStr(AAddress: TAddr): string;
      class function StrToAddr(AString: string): TAddr;
      class function MaskToLeng(AMask: TAddr): Integer;
      class function LengToMask(ALength: string): TAddr;
      class function ValidateMask(const AAddress, AMask: TAddr): Boolean;
      function GetAddress(): string;
      procedure SetAddress(const AAddress: string);
      function GetNetMask(): string;
      procedure SetNetMask(const ANetMask: string);
      function GetHostMask(): string;
      function GetOffset(): string;
      procedure SetOffset(const AOffset: string);
      procedure SetHostMask(const AHostMask: string);
      function GetPrefix(): string;
      procedure SetPrefix(const APrefix: string);
      function GetNetLength(): string;
      procedure SetNetLength(const ANetLength: string);
      function GetNetwork(): string;
      procedure SetNetwork(const ANetwork: string);
      function GetFirst(): string;
      function GetLast(): string;
      function GetBroadcast(): string;
      function GetHostQty(): string;
    public
      constructor Create(); overload;
      constructor Create(const AAddress: string); overload;
      constructor Create(const AAddress, ANetMask: string); overload;
      procedure Clear();
      class function IsUnicast(const AAddress: string): Boolean; static;
      class function IsMulticast(const AAddress: string): Boolean; static;
      class function IsReserved(const AAddress: string): Boolean; static;
      class function IsInRange(const AAddress, APrefix: string): Boolean; static;
      destructor Destroy(); override;
      property Address:   string read GetAddress   write SetAddress;
      property NetMask:   string read GetNetMask   write SetNetMask;
      property HostMask:  string read GetHostMask  write SetHostMask;
      property Offset:    string read GetOffset    write SetOffset;
      property Prefix:    string read GetPrefix    write SetPrefix;
      property NetLength: string read GetNetLength write SetNetLength;
      property Network:   string read GetNetwork   write SetNetwork;
      property First:     string read GetFirst;
      property Last:      string read GetLast;
      property Broadcast: string read GetBroadcast;
      property HostQty:   string read GetHostQty;
  end;

{$ENDREGION}

{$REGION 'IPv6 Class'}

//******************************************************************************
//*                                                                            *
//* IPv6: An IPv6 object only stores a 128-bit unsigned integer for the IPv6   *
//*       address and a 128-bit unsigned integer for the IPv6 mask.            *
//*                                                                            *
//*       IPv6 address strings may be written in any RFC 4291 IP Version 6     *
//*       Addressing Architecture, Section 2.2. Text Representation of         *
//*       Addresses conventional format (1), but are only read in the RFC 5952 *
//*       A Recommendation for IPv6 Address Text Representation canonical      *
//*       format (2).                                                          *
//*                                                                            *
//*        (1) https://www.rfc-editor.org/rfc/rfc4291.html#section-2.2         *
//*        (2) https://www.rfc-editor.org/rfc/rfc5952.html                     *
//*                                                                            *
//*       Create has two overloaded methods. An object may be created with     *
//*       default 0:0:0:0:0:0:0:0 for the address and                          *
//*       ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff for the mask, or it may be   *
//*       created with a specific address and mask using CIDR notation         *
//*       ('x:x:x:x:x:x:x:x/y').                                               *
//*                                                                            *
//*       There are three public methods:                                      *
//*                                                                            *
//*         Create                                                             *
//*           Default 0:0:0:0:0:0:0:0 address and mask                         *
//*           ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff, or with a specific      *
//*           address and mask using CIDR ('x:x:x:x:x:x:x:x/y').               *
//*                                                                            *
//*         Clear                                                              *
//*           Resets address to 0:0:0:0:0:0:0:0 and mask to                    *
//*           ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff.                         *
//*                                                                            *
//*         Destroy                                                            *
//*           Destroys the IPv4 object.                                        *
//*                                                                            *
//*       There are six public class boolean functions:                        *
//*                                                                            *
//*         IsUnicast                                                          *
//*           Returns True if the string address parameter falls within a      *
//*           Unicast address range, otherwise returns False.                  *
//*                                                                            *
//*         IsMulticast                                                        *
//*           Returns True if the string address parameter falls within the    *
//*           Multiicast address range, otherwise returns False.               *
//*                                                                            *
//*         IsReserved                                                         *
//*           Returns True if the string address parameter falls within a      *
//*           Reserved address range, otherwise returns False.                 *
//*                                                                            *
//*         IsInRange                                                          *
//*           Returns True if the string address parameter falls within the    *
//*           string prefix parameter, otherwise returns False.                *
//*                                                                            *
//*         Expand                                                             *
//*           Returns a fully expanded (eight four-digit hexadecimal fields)   *
//*           string address from a string address parameter.                  *
//*                                                                            *
//*         Compress                                                           *
//*           Returns an RFC 5952 canonical string address from a string       *
//*           address parameter.                                               *
//*                                                                            *
//*       There are five read/write properties:                                *
//*                                                                            *
//*         Address                                                            *
//*           GET string of address value.                                     *
//*           SET address value to new address parameter that may include the  *
//*               mask length that sets mask value).                           *
//*                                                                            *
//*         Offset                                                             *
//*           GET integer string of offset from address and mask values.       *
//*             [address AND [NOT mask]]                                       *
//*           SET address to network + offset.                                 *
//*             [[address AND mask] OR offset]                                 *
//*                                                                            *
//*         Prefix                                                             *
//*           GET string prefix from address and mask values.                  *
//*             [address AND mask]/[mask length]                               *
//*           SET address to new prefix parameter + new offset.                *
//*             [[prefix AND new mask] OR [address AND new mask]]              *
//*                                                                            *
//*         NetLength                                                          *
//*           GET integer string of mask length.                               *
//*             [count high-order mask 1 bits]                                 *
//*           SET mask value to high-order net length 1 bits.                  *
//*             [high-order net length 1 bits]                                 *
//*                                                                            *
//*         Network                                                            *
//*           GET string network from address and mask values.                 *
//*             [address AND mask]                                             *
//*           SET address to new network + address offset                      *
//*             [new network OR [address AND [NOT mask]]]                      *
//*                                                                            *
//*       There are three read-only properties:                                *
//*                                                                            *
//*         First                                                              *
//*           GET string first host address.                                   *
//*             [address AND mask]                                             *
//*                                                                            *
//*         Last                                                               *
//*           GET string last host address.                                    *
//*             [address OR [NOT mask]]                                        *
//*                                                                            *
//*         HostQty                                                            *
//*           GET integer string of host address quantity.                     *
//*             [[NOT mask] + 1]                                               *
//*                                                                            *
//******************************************************************************

  TIPv6 = class(TObject)
    private
      type
        TAddr = BigInteger;
      var
        FAddr: TAddr;
        FMask: TAddr;
      class function AddrToStr(AAddress: TAddr): string;
      class function StrToAddr(AString: string): TAddr;
      class function MaskToLeng(AMask: TAddr): Integer;
      class function LengToMask(ALength: string): TAddr;
      class function ValidateMask(const AAddress, AMask: TAddr): Boolean;
      function GetAddress(): string;
      procedure SetAddress(const AAddress: string);
      function GetOffset(): string;
      procedure SetOffset(const AOffset: string);
      function GetPrefix(): string;
      procedure SetPrefix(const APrefix: string);
      function GetNetLength(): string;
      procedure SetNetLength(const ANetLength: string);
      function GetNetwork(): string;
      procedure SetNetwork(const ANetwork: string);
      function GetFirst(): string;
      function GetLast(): string;
      function GetHostQty(): string;
    public
      class function IsUnicast(const AAddress: string): Boolean; static;
      class function IsMulticast(const AAddress: string): Boolean; static;
      class function IsReserved(const AAddress: string): Boolean; static;
      class function IsInRange(const AAddress, APrefix: string): Boolean; static;
      class function Expand(const AAddress: string): string;
      class function Compress(const AAddress: string): string;
      constructor Create();                                 overload;
      constructor Create(const AAddress: string);           overload;
      procedure Clear();
      destructor Destroy(); override;
      property Address:   string read GetAddress   write SetAddress;
      property Offset:    string read GetOffset    write SetOffset;
      property Prefix:    string read GetPrefix    write SetPrefix;
      property NetLength: string read GetNetLength write SetNetLength;
      property Network:   string read GetNetwork   write SetNetwork;
      property First:     string read GetFirst;
      property Last:      string read GetLast;
      property HostQty:   string read GetHostQty;
  end;

{$ENDREGION}

implementation

{$REGION 'IPv4 Methods'}

//******************************************************************************
//******************************************************************************
//*                                                                           **
//*                    IIIIII  PPPPPP                 44                      **
//*                      II    PP   PP               444                      **
//*                      II    PP   PP              4444                      **
//*                      II    PPPPPP   vv    vv   44 44                      **
//*                      II    PP        vv  vv   44444444                    **
//*                      II    PP         vvvv        44                      **
//*                    IIIIII  PP          vv         44                      **
//*                                                                           **
//******************************************************************************
//******************************************************************************

var
  IPv4RegEx: TPerlRegEx;

{$REGION 'IPv4 Private Class Methods'}

//*************************************
//*****  IPv4 Address to String   *****
//*************************************

class function TIPv4.AddrToStr(AAddress: TAddr): string;
begin
  Result := (((AAddress and TAddr($FF000000)) shr 24).ToString + '.' +
             ((AAddress and TAddr($00FF0000)) shr 16).ToString + '.' +
             ((AAddress and TAddr($0000FF00)) shr 08).ToString + '.' +
              (AAddress and TAddr($000000FF)).ToString);
end;

//*************************************
//*****  IPv4 String to Address   *****
//*************************************

class function TIPv4.StrToAddr(AString: string): TAddr;
var
  i: Integer;
begin
  IPv4RegEx.Subject := AString;
  if IPv4RegEx.Match then begin
    if (IPv4RegEx.Groups[5] = '') then begin
      Result := 0;
      for i := 1 to 4 do begin
        Result := (Result shl 8);
        Result := (Result or StrToUInt(IPv4RegEx.Groups[i]));
      end;
    end
    else begin
      raise EIPError.Create('[%IPV4-ERROR-ADDRESS: ' + AString + ' bad address format]');
    end;
  end
  else begin
    raise EIPError.Create('[%IPV4-ERROR-ADDRESS: ' + AString + ' bad address format]');
  end;
end;

//*************************************
//*****    IPv4 Mask to Length    *****
//*************************************

class function TIPv4.MaskToLeng(AMask: TAddr): Integer;
begin
  case AMask of
    $00000000: Result :=  0;
    $80000000: Result :=  1;
    $C0000000: Result :=  2;
    $E0000000: Result :=  3;
    $F0000000: Result :=  4;
    $F8000000: Result :=  5;
    $FC000000: Result :=  6;
    $FE000000: Result :=  7;
    $FF000000: Result :=  8;
    $FF800000: Result :=  9;
    $FFC00000: Result := 10;
    $FFE00000: Result := 11;
    $FFF00000: Result := 12;
    $FFF80000: Result := 13;
    $FFFC0000: Result := 14;
    $FFFE0000: Result := 15;
    $FFFF0000: Result := 16;
    $FFFF8000: Result := 17;
    $FFFFC000: Result := 18;
    $FFFFE000: Result := 19;
    $FFFFF000: Result := 20;
    $FFFFF800: Result := 21;
    $FFFFFC00: Result := 22;
    $FFFFFE00: Result := 23;
    $FFFFFF00: Result := 24;
    $FFFFFF80: Result := 25;
    $FFFFFFC0: Result := 26;
    $FFFFFFE0: Result := 27;
    $FFFFFFF0: Result := 28;
    $FFFFFFF8: Result := 29;
    $FFFFFFFC: Result := 30;
    $FFFFFFFE: Result := 31;
    $FFFFFFFF: Result := 32;
  else
    raise EIPError.Create('[%IPV4-ERROR-MASK: ' + AddrToStr(AMask) + ' bad mask format]');
  end;
end;

//*************************************
//*****    IPv4 Length to Mask    *****
//*************************************

class function TIPv4.LengToMask(ALength: string): TAddr;
var
  i: Integer;
begin
  if TryStrToInt(ALength, i) then begin
    case i of
       0: Result := $00000000;
       1: Result := $80000000;
       2: Result := $C0000000;
       3: Result := $E0000000;
       4: Result := $F0000000;
       5: Result := $F8000000;
       6: Result := $FC000000;
       7: Result := $FE000000;
       8: Result := $FF000000;
       9: Result := $FF800000;
      10: Result := $FFC00000;
      11: Result := $FFE00000;
      12: Result := $FFF00000;
      13: Result := $FFF80000;
      14: Result := $FFFC0000;
      15: Result := $FFFE0000;
      16: Result := $FFFF0000;
      17: Result := $FFFF8000;
      18: Result := $FFFFC000;
      19: Result := $FFFFE000;
      20: Result := $FFFFF000;
      21: Result := $FFFFF800;
      22: Result := $FFFFFC00;
      23: Result := $FFFFFE00;
      24: Result := $FFFFFF00;
      25: Result := $FFFFFF80;
      26: Result := $FFFFFFC0;
      27: Result := $FFFFFFE0;
      28: Result := $FFFFFFF0;
      29: Result := $FFFFFFF8;
      30: Result := $FFFFFFFC;
      31: Result := $FFFFFFFE;
      32: Result := $FFFFFFFF;
    else
      raise EIPError.Create('[%IPV4-ERROR-LENGTH: ' + ALength + ' bad range]');
    end;
  end
  else begin
    raise EIPError.Create('[%IPV4-ERROR-LENGTH: ' + ALength + ' bad integer]');
  end;
end;

//*************************************
//*****    IPv4 Validate Mask     *****
//*************************************

class function TIPv4.ValidateMask(const AAddress, AMask: TAddr): Boolean;
var
	a, b, m: TAddr;
begin
  a := AAddress;
	b := ((AAddress or (not AMask)));
	m := AMask;
  if ((a < $E0000000) and (b >= $E0000000)) then begin
    raise EIPError.Create('[%IPV4-ERROR-LENGTH: ' + AddrToStr(a) + '/' + MaskToLeng(m).ToString + ' bad Unicast range]');
  end
  else if ((a >= $E0000000) and (a < $F0000000) and (m < $F0000000)) then begin
    raise EIPError.Create('[%IPV4-ERROR-LENGTH: ' + AddrToStr(a) + '/' + MaskToLeng(m).ToString + ' bad Multicast range]');
  end
  else if ((a >= $F0000000) and (m < $F0000000)) then begin
    raise EIPError.Create('[%IPV4-ERROR-LENGTH: ' + AddrToStr(a) + '/' + MaskToLeng(m).ToString + ' bad Reserved range]');
  end
  else begin
    Result := True;
  end;
end;

{$ENDREGION}

{$REGION 'IPv4 Private Methods'}

//*************************************
//*****       IPv4 Address        *****
//*************************************

function TIPv4.GetAddress(): string;
begin
  Result := AddrToStr(FAddr);
end;

procedure TIPv4.SetAddress(const AAddress: string);
var
  a, m: TAddr;
  s: TArray<string>;
begin
  if (AAddress > '') then begin
    s := AAddress.Split(['/']);
    a := StrToAddr(s[0]);
    if (Length(s) > 1) then begin
      m := LengToMask(s[1]);
    end
    else begin
      m := FMask;
    end;
    if ValidateMask(a, m) then begin
      FAddr := a;
      FMask := m;
    end;
  end
  else begin
    raise EIPError.Create('[%IPV4-ERROR-ADDRESS: no address]');
  end;
end;

//*************************************
//*****     IPv4 Network Mask     *****
//*************************************

function TIPv4.GetNetMask(): string;
begin
  Result := AddrToStr(FMask);
end;

procedure TIPv4.SetNetMask(const ANetMask: string);
var
  a, m: TAddr;
  s: TArray<string>;
begin
  if (ANetMask > '') then begin
    s := ANetMask.Split(['/']);
    if (Length(s) = 1) then begin
      a := FAddr;
      m := LengToMask(MaskToLeng(StrToAddr(ANetMask)).ToString);
      if ValidateMask(a, m) then begin
        FMask := m;
      end;
    end
    else begin
      raise EIPError.Create('[%IPV4-ERROR-MASK: ' + ANetMask + ' bad format]');
    end;
    end
  else begin
    raise EIPError.Create('[%IPV4-ERROR-MASK: no mask]');
  end;
end;

//*************************************
//*****      IPv4 Host Mask       *****
//*************************************

function TIPv4.GetHostMask(): string;
begin
  Result := AddrToStr(not FMask);
end;

procedure TIPv4.SetHostMask(const AHostMask: string);
var
  a, m: TAddr;
  s: TArray<string>;
begin
  if (AHostMask > '') then begin
    s := AHostMask.Split(['/']);
    if (Length(s) = 1) then begin
      a := FAddr;
      m := LengToMask(MaskToLeng(not StrToAddr(AHostMask)).ToString);
      if ValidateMask(a, m) then begin
        FMask := m;
      end;
    end
    else begin
      raise EIPError.Create('[%IPV4-ERROR-MASK: ' + AHostMask + ' bad format]');
    end;
  end
  else begin
    raise EIPError.Create('[%IPV4-ERROR-MASK: no mask]');
  end;
end;

//*************************************
//*****    IPv4 Address Offset    *****
//*************************************

function TIPv4.GetOffset(): string;
begin
  Result := (FAddr and (not FMask)).ToString;
end;

procedure TIPv4.SetOffset(const AOffset: string);
var
  o: TAddr;
begin
  if TryStrToUInt(AOffset, o) then begin
    if (o <= (not FMask)) then begin
      FAddr := ((FAddr and FMask) or o);
    end
    else begin
      raise EIPError.Create('[%IPV4-ERROR-OFFSET: ' + AOffset + ' outside of range]');
    end;
  end
  else begin
    raise EIPError.Create('[%IPV4-ERROR-OFFSET: ' + AOffset + ' bad integer]');
  end;
end;

//*************************************
//*****        IPv4 Prefix        *****
//*************************************

function TIPv4.GetPrefix(): string;
begin
  Result := (AddrToStr(FAddr and FMask) + '/' + MaskToLeng(FMask).ToString);
end;

procedure TIPv4.SetPrefix(const APrefix: string);
var
  a, m: TAddr;
  s: TArray<string>;
begin
  if (APrefix > '') then begin
    s := APrefix.Split(['/']);
    if (Length(s) > 1) then begin
      a := StrToAddr(s[0]);
      m := LengToMask(s[1]);
      if ValidateMask(a, m) then begin
        if (a = (a and m)) then begin
          FAddr := ((a and m) or (FAddr and (not m)));
          FMask := m;
        end
        else begin
          raise EIPError.Create('[%IPV4-ERROR-PREFIX: ' + APrefix + ' bad prefix range]');
        end;
      end;
    end
    else begin
      raise EIPError.Create('[%IPV4-ERROR-PREFIX: ' + APrefix + ' bad format]');
    end;
  end
  else begin
    raise EIPError.Create('[%IPV4-ERROR-PREFIX: no prefix]');
  end;
end;

//*************************************
//*****    IPv4 Network Length    *****
//*************************************

function TIPv4.GetNetLength(): string;
begin
  Result := MaskToLeng(FMask).ToString;
end;

procedure TIPv4.SetNetLength(const ANetLength: string);
var
  a, m: TAddr;
begin
  a := FAddr;
  m := LengToMask(ANetLength);
  if ValidateMask(a, m) then begin
    FMask := m;
  end;
end;

//*************************************
//*****       IPv4 Network        *****
//*************************************

function TIPv4.GetNetwork(): string;
begin
  Result := AddrToStr(FAddr and FMask);
end;

procedure TIPv4.SetNetwork(const ANetwork: string);
var
  a, m: TAddr;
  s: TArray<string>;
begin
  if (ANetwork > '') then begin
    s := ANetwork.Split(['/']);
    if (Length(s) = 1) then begin
      a := StrToAddr(s[0]);
      m := FMask;
      if ValidateMask(a, m) then begin
        if (a = (a and m)) then begin
          FAddr := ((a and m) or (FAddr and (not m)));
        end
        else begin
          raise EIPError.Create('[%IPV4-ERROR-NETWORK: ' + ANetwork + ' bad network range]');
        end;
      end;
    end
    else begin
      raise EIPError.Create('[%IPV4-ERROR-NETWORK: ' + ANetwork + ' bad format]');
    end;
  end
  else begin
    raise EIPError.Create('[%IPV4-ERROR-NETWORK: no network]');
  end;
end;

//*************************************
//***** IPv4 First Usable Address *****
//*************************************

function TIPv4.GetFirst(): string;
var
  a: TAddr;
begin
  a := (FAddr and FMask);
  if ((a < $E0000000) and (FMask < $FFFFFFFE)) then begin
    a := (a or $00000001);
  end;
  Result := AddrToStr(a);
end;

//*************************************
//***** IPv4 Last Usable Address  *****
//*************************************

function TIPv4.GetLast(): string;
var
  a: TAddr;
begin
  a := (FAddr or (not FMask));
  if ((a < $E0000000) and (FMask < $FFFFFFFE)) then begin
    a := (a and $FFFFFFFE);
  end;
  Result := AddrToStr(a);
end;

//*************************************
//*****  IPv4 Broadcast Address   *****
//*************************************

function TIPv4.GetBroadcast(): string;
var
  a: TAddr;
begin
  a := (FAddr or (not FMask));
  if (a < $E0000000) then begin
    Result := AddrToStr(a);
  end
  else begin
    Result := 'N/A';
  end;
end;

//*************************************
//*****    IPv4 Host Quantity     *****
//*************************************

function TIPv4.GetHostQty(): string;
var
  q: UInt64;
begin
  q := ((not Fmask) + 1);
  if (((FAddr or (not FMask)) < $E0000000) and (FMask < $FFFFFFFE)) then begin
    Result := (q - 2).ToString;
  end
  else begin
    Result := q.ToString;
  end;
end;

{$ENDREGION}

{$REGION 'IPv4 Public Class Methods'}

//*************************************
//*****   IPv4 Unicast Address    *****
//*************************************

class function TIPv4.IsUnicast(const AAddress: string): Boolean;
begin
  Result := (StrToAddr(AAddress) < $E0000000);
end;

//*************************************
//*****  IPv4 Multicast Address   *****
//*************************************

class function TIPv4.IsMulticast(const AAddress: string): Boolean;
var
  a: TAddr;
begin
  a := StrToAddr(AAddress);
  Result := ((a >= $E0000000) and (a < $F0000000));
end;

//*************************************
//*****   IPv4 Reserved Address   *****
//*************************************

class function TIPv4.IsReserved(const AAddress: string): Boolean;
begin
  Result := (StrToAddr(AAddress) >= $F0000000);
end;

//*************************************
//*****   IPv4 Address in Range   *****
//*************************************

class function TIPv4.IsInRange(const AAddress, APrefix: string): Boolean;
var
  a, m, p: TAddr;
  s: TArray<string>;
begin
  if (AAddress > '') then begin
    if (APrefix > '') then begin
      s := APrefix.Split(['/']);
      if (Length(s) > 1) then begin
        a := StrToAddr(AAddress);
        p := StrToAddr(s[0]);
        m := LengToMask(s[1]);
        Result := ((a and m) = (p and m));
      end
      else begin
        raise EIPError.Create('[%IPV4-ERROR-PREFIX: ' + APrefix + ' bad format]');
      end;
    end
    else begin
      raise EIPError.Create('[%IPV4-ERROR-PREFIX: no prefix]');
    end;
  end
  else begin
    raise EIPError.Create('[%IPV4-ERROR-ADDRESS: no address]');
  end;
end;

{$ENDREGION}

{$REGION 'IPv4 Public Methods'}

//*************************************
//*****     IPv4 Constructors     *****
//*************************************

constructor TIPv4.Create();
begin
  inherited;
  Clear;
end;

constructor TIPv4.Create(const AAddress: string);
begin
  Create;
  try
    SetAddress(AAddress);
  except
    Clear;
    raise;
  end;
end;

constructor TIPv4.Create(const AAddress, ANetMask: string);
begin
  Create;
  try
    SetAddress(AAddress);
    SetNetMask(ANetMask);
  except
    Clear;
    raise;
  end;
end;

//*************************************
//***** IPv4 Clear Address & Mask *****
//*************************************

procedure TIPv4.Clear();
begin
  FAddr := $00000000;
  FMask := $FFFFFFFF;
end;

//*************************************
//*****      IPv4 Destructor      *****
//*************************************

destructor TIPv4.Destroy();
begin
  inherited;
end;

{$ENDREGION}

{$ENDREGION}

{$REGION 'IPv6 Methods'}

//******************************************************************************
//******************************************************************************
//*                                                                           **
//*                    IIIIII  PPPPPP              666666                     **
//*                      II    PP   PP            66    66                    **
//*                      II    PP   PP            66                          **
//*                      II    PPPPPP   vv    vv  6666666                     **
//*                      II    PP        vv  vv   66    66                    **
//*                      II    PP         vvvv    66    66                    **
//*                    IIIIII  PP          vv      666666                     **
//*                                                                           **
//******************************************************************************
//******************************************************************************

var
  IPv6RegEx: TPerlRegEx;

{$REGION 'IPv6 Private Class Methods'}

//*************************************
//*****  IPv6 Address to String   *****
//*************************************

class function TIPv6.AddrToStr(AAddress: TAddr): string;
begin
  Result := (((AAddress and TAddr('$FFFF0000000000000000000000000000')) shr 112).ToHexString + ':' +
             ((AAddress and TAddr('$0000FFFF000000000000000000000000')) shr  96).ToHexString + ':' +
             ((AAddress and TAddr('$00000000FFFF00000000000000000000')) shr  80).ToHexString + ':' +
             ((AAddress and TAddr('$000000000000FFFF0000000000000000')) shr  64).ToHexString + ':' +
             ((AAddress and TAddr('$0000000000000000FFFF000000000000')) shr  48).ToHexString + ':' +
             ((AAddress and TAddr('$00000000000000000000FFFF00000000')) shr  32).ToHexString + ':' +
             ((AAddress and TAddr('$000000000000000000000000FFFF0000')) shr  16).ToHexString + ':' +
              (AAddress and TAddr('$0000000000000000000000000000FFFF')).ToHexString);
end;

//*************************************
//*****  IPv6 String to Address   *****
//*************************************

class function TIPv6.StrToAddr(AString: string): TAddr;
var
  i: Integer;
  a: TArray<string>;
  s: TArray<string>;
begin
  s := Expand(AString).Split(['/']);
  if (Length(s) = 1) then begin
    a := s[0].Split([':']);
    Result := 0;
    for i := 0 to 7 do begin
      Result := (Result shl 16);
      Result := (Result or ('$' + a[i]).ToInteger);
    end;
  end
  else begin
    raise EIPError.Create('[%IPV6-ERROR-ADDRESS: ' + AString + ' bad address format]');
  end;
end;

//*************************************
//*****    IPv6 Mask to Length    *****
//*************************************

class function TIPv6.MaskToLeng(AMask: TAddr): Integer;
var
  m: TAddr;
begin
  Result := 0;
  m := AMask;
  while (m > 0) do begin
    Result := (Result + 1);
    m := ((m shl 1) and TAddr('$0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'));
  end;
end;

//*************************************
//*****    IPv6 Length to Mask    *****
//*************************************

class function TIPv6.LengToMask(ALength: string): TAddr;
var
  i: Integer;
begin
  if TryStrToInt(ALength, i) then begin
    if ((i >= 0) and (i <= 128)) then begin
      Result := ((TAddr('$0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF') shl (128 - i)) and
                  TAddr('$0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'));
    end
    else begin
      raise EIPError.Create('[%IPV6-ERROR-LENGTH: ' + ALength + ' bad range]');
    end;
  end
  else begin
    raise EIPError.Create('[%IPV6-ERROR-LENGTH: ' + ALength + ' bad integer]');
  end;
end;

//*************************************
//*****    IPv6 Validate Mask     *****
//*************************************

class function TIPv6.ValidateMask(const AAddress,  AMask: TAddr): Boolean;
var
  a, b, m, n: TAddr;
begin
  a := AAddress;
  b := ((AAddress or (TAddr('$0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF') - AMask)));
  m := AMask;
  n := (AAddress and AMask);
  if ((a < TAddr('$020000000000000000000000000000000')) and (b >= TAddr('$020000000000000000000000000000000'))) then begin
    raise EIPError.Create('[%IPV6-ERROR-LENGTH: ' + AddrToStr(a) + '/' + MaskToLeng(m).ToString + ' bad Reserved range]');
  end
  else if (((a >= TAddr('$020000000000000000000000000000000')) and (a < TAddr('$040000000000000000000000000000000'))) and ((n < TAddr('$020000000000000000000000000000000')) or (b >= TAddr('$040000000000000000000000000000000')))) then begin
    raise EIPError.Create('[%IPV6-ERROR-LENGTH: ' + AddrToStr(a) + '/' + MaskToLeng(m).ToString + ' bad Global range]');
  end
  else if (((a >= TAddr('$040000000000000000000000000000000')) and (a < TAddr('$0FC000000000000000000000000000000'))) and ((n < TAddr('$040000000000000000000000000000000')) or (b >= TAddr('$0FC000000000000000000000000000000')))) then begin
    raise EIPError.Create('[%IPV6-ERROR-LENGTH: ' + AddrToStr(a) + '/' + MaskToLeng(m).ToString + ' bad Reserved range]');
  end
  else if (((a >= TAddr('$0FC000000000000000000000000000000')) and (a < TAddr('$0FE000000000000000000000000000000'))) and ((n < TAddr('$0FC000000000000000000000000000000')) or (b >= TAddr('$0FE000000000000000000000000000000')))) then begin
    raise EIPError.Create('[%IPV6-ERROR-LENGTH: ' + AddrToStr(a) + '/' + MaskToLeng(m).ToString + ' bad Unique-Local range]');
  end
  else if (((a >= TAddr('$0FE000000000000000000000000000000')) and (a < TAddr('$0FE800000000000000000000000000000'))) and ((n < TAddr('$0FE000000000000000000000000000000')) or (b >= TAddr('$0FE800000000000000000000000000000')))) then begin
    raise EIPError.Create('[%IPV6-ERROR-LENGTH: ' + AddrToStr(a) + '/' + MaskToLeng(m).ToString + ' bad Reserved range]');
  end
  else if (((a >= TAddr('$0FE800000000000000000000000000000')) and (a < TAddr('$0FEC00000000000000000000000000000'))) and ((n < TAddr('$0FE800000000000000000000000000000')) or (b >= TAddr('$0FEC00000000000000000000000000000')))) then begin
    raise EIPError.Create('[%IPV6-ERROR-LENGTH: ' + AddrToStr(a) + '/' + MaskToLeng(m).ToString + ' bad Link-Local range]');
  end
  else if (((a >= TAddr('$0FEC00000000000000000000000000000')) and (a < TAddr('$0FF000000000000000000000000000000'))) and ((n < TAddr('$0FEC00000000000000000000000000000')) or (b >= TAddr('$0FF000000000000000000000000000000')))) then begin
    raise EIPError.Create('[%IPV6-ERROR-LENGTH: ' + AddrToStr(a) + '/' + MaskToLeng(m).ToString + ' bad Reserved range]');
  end
  else if ((a >= TAddr('$0FF000000000000000000000000000000')) and (n < TAddr('$0FF000000000000000000000000000000'))) then begin
    raise EIPError.Create('[%IPV6-ERROR-LENGTH: ' + AddrToStr(a) + '/' + MaskToLeng(m).ToString + ' bad Multicast range]');
  end
  else begin
    Result := True;
  end;
end;

{$ENDREGION}

{$REGION 'IPv6 Private Methods'}

//*************************************
//*****       IPv6 Address        *****
//*************************************

function TIPv6.GetAddress(): string;
begin
  Result := Compress(AddrToStr(FAddr));
end;

procedure TIPv6.SetAddress(const AAddress: string);
var
  a, m: TAddr;
  s: TArray<string>;
begin
  if (AAddress > '') then begin
    s := AAddress.Split(['/']);
    a := StrToAddr(s[0]);
    if (Length(s) > 1) then begin
      m := LengToMask(s[1]);
    end
    else begin
      m := FMask;
    end;
    FAddr := a;
    FMask := m;
  end
  else begin
    raise EIPError.Create('[%IPV6-ERROR-ADDRESS: no address]');
  end;
end;

//*************************************
//*****    IPv6 Address Offset    *****
//*************************************

function TIPv6.GetOffset(): string;
begin
  Result := (FAddr and (TAddr('$0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF') - FMask)).ToDecimalString;
end;

procedure TIPv6.SetOffset(const AOffset: string);
var
  o: TAddr;
begin
  try
    o := TAddr('0d' + AOffset);
    if ((o >= 0) and (o <= (TAddr('$0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF') - FMask))) then begin
      FAddr := ((FAddr and FMask) or o);
    end
    else begin
      raise EIPError.Create('[%IPV6-ERROR-OFFSET: ' + AOffset + ' outside of range]');
    end;
  except
    raise EIPError.Create('[%IPV6-ERROR-OFFSET: ' + AOffset + ' bad integer]');
  end;
end;

//*************************************
//*****        IPv6 Prefix        *****
//*************************************

function TIPv6.GetPrefix(): string;
begin
  Result := Compress(AddrToStr(FAddr and FMask) + '/' + MaskToLeng(FMask).ToString);
end;

procedure TIPv6.SetPrefix(const APrefix: string);
var
  a, m: TAddr;
  s: TArray<string>;
begin
  if (APrefix > '') then begin
    s := APrefix.Split(['/']);
    if (Length(s) > 1) then begin
      a := StrToAddr(s[0]);
      m := LengToMask(s[1]);
      if ValidateMask(a, m) then begin
        if (a = (a and m)) then begin
          FAddr := ((a and m) or (FAddr and (TAddr('$0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF') - m)));
          FMask := m;
        end
        else begin
          raise EIPError.Create('[%IPV6-ERROR-PREFIX: ' + APrefix + ' bad prefix range]');
        end;
      end;
    end
    else begin
      raise EIPError.Create('[%IPV6-ERROR-PREFIX: ' + APrefix + ' bad format]');
    end;
  end
  else begin
    raise EIPError.Create('[%IPV6-ERROR-PREFIX: no prefix]');
  end;
end;

//*************************************
//*****    IPv6 Network Length    *****
//*************************************

function TIPv6.GetNetLength(): string;
begin
  Result := MaskToLeng(FMask).ToString;
end;

procedure TIPv6.SetNetLength(const ANetLength: string);
var
  a, m: TAddr;
begin
  a := FAddr;
  m := LengToMask(ANetLength);
  if ValidateMask(a, m) then begin
    FMask := m;
  end;
end;

//*************************************
//*****       IPv6 Network        *****
//*************************************

function TIPv6.GetNetwork(): string;
begin
  Result := Compress(AddrToStr(FAddr and FMask));
end;

procedure TIPv6.SetNetwork(const ANetwork: string);
var
  a, m: TAddr;
  s: TArray<string>;
begin
  if (ANetwork > '') then begin
    s := ANetwork.Split(['/']);
    if (Length(s) = 1) then begin
      a := StrToAddr(s[0]);
      m := FMask;
      if ValidateMask(a, m) then begin
        if (a = (a and m)) then begin
          FAddr := ((a and m) or (FAddr and (TAddr('$0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF') - m)));
        end
        else begin
          raise EIPError.Create('[%IPV6-ERROR-NETWORK: ' + ANetwork + ' bad network range]');
        end;
      end;
    end
    else begin
      raise EIPError.Create('[%IPV6-ERROR-NETWORK: ' + ANetwork + ' bad format]');
    end;
  end
  else begin
    raise EIPError.Create('[%IPV6-ERROR-NETWORK: no network]');
  end;
end;

//*************************************
//***** IPv6 First Usable Address *****
//*************************************

function TIPv6.GetFirst(): string;
begin
  Result := Compress(AddrToStr(FAddr and FMask));
end;

//*************************************
//***** IPv6 Last Usable Address  *****
//*************************************

function TIPv6.GetLast(): string;
begin
  Result := Compress(AddrToStr((FAddr and FMask) or (TAddr('$0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF') - FMask)));
end;

//*************************************
//*****    IPv6 Host Quantity     *****
//*************************************

function TIPv6.GetHostQty(): string;
var
  q: BigInteger;
begin
  q := ((TAddr('$0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF') - Fmask) + 1);
  Result := q.ToDecimalString;
end;

{$ENDREGION}

{$REGION 'IPv6 Public Class Methods'}

//*************************************
//*****   IPv6 Unicast Address    *****
//*************************************

class function TIPv6.IsUnicast(const AAddress: string): Boolean;
var
  a: TAddr;
begin
  a := StrToAddr(AAddress);
  Result := (((a >= '$020000000000000000000000000000000') and (a <= '$03FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF')) or
             ((a >= '$0FC000000000000000000000000000000') and (a <= '$0FDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF')) or
             ((a >= '$0FE800000000000000000000000000000') and (a <= '$0FEBFFFFFFFFFFFFFFFFFFFFFFFFFFFFF')));
end;

//*************************************
//*****  IPv6 Multicast Address   *****
//*************************************

class function TIPv6.IsMulticast(const AAddress: string): Boolean;
var
  a: TAddr;
begin
  a := StrToAddr(AAddress);
  Result := (a >= '$0FF000000000000000000000000000000');
end;

//*************************************
//*****   IPv6 Reserved Address   *****
//*************************************

class function TIPv6.IsReserved(const AAddress: string): Boolean;
var
  a: TAddr;
begin
  a := StrToAddr(AAddress);
  Result := (((a <  '$020000000000000000000000000000000'))                                                or
             ((a >= '$040000000000000000000000000000000') and (a < '$0FC000000000000000000000000000000')) or
             ((a >= '$0FE000000000000000000000000000000') and (a < '$0FE800000000000000000000000000000')) or
             ((a >= '$0FEC00000000000000000000000000000') and (a < '$0FF000000000000000000000000000000')));
end;

//*************************************
//*****   IPv6 Address in Range   *****
//*************************************

class function TIPv6.IsInRange(const AAddress, APrefix: string): Boolean;
var
  a, m, p: TAddr;
  s: TArray<string>;
begin
  if (AAddress > '') then begin
    if (APrefix > '') then begin
      s := APrefix.Split(['/']);
      if (Length(s) > 1) then begin
        a := StrToAddr(AAddress);
        p := StrToAddr(s[0]);
        m := LengToMask(s[1]);
        Result := ((a and m) = (p and m));
      end
      else begin
        raise EIPError.Create('[%IPV6-ERROR-PREFIX: ' + APrefix + ' bad format]');
      end;
    end
    else begin
      raise EIPError.Create('[%IPV6-ERROR-PREFIX: no prefix]');
    end;
  end
  else begin
    raise EIPError.Create('[%IPV6-ERROR-ADDRESS: no address]');
  end;
end;

//*************************************
//*****    IPv6 Expand Address    *****
//*************************************

class function TIPv6.Expand(const AAddress: string): string;
var
  i: Integer;
  a: string;
  s: TArray<String>;
begin
  IPv6RegEx.Subject := AAddress;
  if IPv6RegEx.Match then begin
    if (IPv6RegEx.Groups[1] > '') then begin
      a := IPv6RegEx.Groups[2] +
           IntToHex(((IPv6RegEx.Groups[4].ToInteger shl 8) or IPv6RegEx.Groups[5].ToInteger), 1) +
           ':'                                                                                           +
           IntToHex(((IPv6RegEx.Groups[6].ToInteger shl 8) or IPv6RegEx.Groups[7].ToInteger), 1);
    end
    else begin
      a := IPv6RegEx.Groups[8];
    end;
    if a.Contains('::') then begin
      case a.CountChar(':') of
        2: begin
          if (a = '::') then begin
            a := '0:0:0:0:0:0:0:0';
          end
          else if (a.StartsWith('::')) then begin
            a := a.Replace('::', '0:0:0:0:0:0:0:');
          end
          else if (a.EndsWith('::')) then begin
            a := a.Replace('::', ':0:0:0:0:0:0:0');
          end
          else begin
            a := a.Replace('::', ':0:0:0:0:0:0:');
          end;
        end;
        3: begin
          if (a.StartsWith('::')) then begin
            a := a.Replace('::', '0:0:0:0:0:0:');
          end
          else if (a.EndsWith('::')) then begin
            a := a.Replace('::', ':0:0:0:0:0:0');
          end
          else begin
            a := a.Replace('::', ':0:0:0:0:0:');
          end;
        end;
        4: begin
          if (a.StartsWith('::')) then begin
            a := a.Replace('::', '0:0:0:0:0:');
          end
          else if (a.EndsWith('::')) then begin
            a := a.Replace('::', ':0:0:0:0:0');
          end
          else begin
            a := a.Replace('::', ':0:0:0:0:');
          end;
        end;
        5: begin
          if (a.StartsWith('::')) then begin
            a := a.Replace('::', '0:0:0:0:');
          end
          else if (a.EndsWith('::')) then begin
            a := a.Replace('::', ':0:0:0:0');
          end
          else begin
            a := a.Replace('::', ':0:0:0:');
          end;
        end;
        6: begin
          if (a.StartsWith('::')) then begin
            a := a.Replace('::', '0:0:0:');
          end
          else if (a.EndsWith('::')) then begin
            a := a.Replace('::', ':0:0:0');
          end
          else begin
            a := a.Replace('::', ':0:0:');
          end;
        end;
        7: begin
          if (a.StartsWith('::')) then begin
            a := a.Replace('::', '0:0:');
          end
          else if (a.EndsWith('::')) then begin
            a := a.Replace('::', ':0:0');
          end
          else begin
            a := a.Replace('::', ':0:');
          end;
        end;
      end;
    end;
    s := a.Split([':']);
    Result := '';
    for i := 0 to 7 do begin
      Result := (Result + IntToHex(('$' + s[i]).ToInteger, 4) + ':');
    end;
    Result := Result.Remove(Length(Result));
    Result := Result.ToLower;
    if (IPv6RegEx.Groups[9] > '') then begin
      Result := (Result + '/' + IPv6RegEx.Groups[9]);
    end;
  end
  else begin
    raise EIPError.Create('[%IPV6-ERROR-ADDRESS: bad format]');
  end;
end;

//*************************************
//*****   IPv6 Compress Address   *****
//*************************************

class function TIPv6.Compress(const AAddress: string): string;
var
  i: Integer;
  u: UInt32;
  a: TArray<String>;
  s: TArray<String>;
begin
  s := Expand(AAddress).Split(['/']);
  a := s[0].Split([':']);
  for i := 0 to 7 do begin
    a[i] := IntToHex(('$' + a[i]).ToInteger, 1).ToLower;
  end;
  Result := '';
  for i := 0 to 5 do begin
    Result := (Result + a[i] + ':');
  end;
  if (Result = '0:0:0:0:0:ffff:') then begin
    u := ((UInt32(('$' + a[6]).ToInteger) shl 16) or UInt32(('$' + a[7]).ToInteger));
    Result := (Result +
              ((u shr 24).ToString         + '.' +
              ((u shl 08) shr 24).ToString + '.' +
              ((u shl 16) shr 24).ToString + '.' +
              ((u shl 24) shr 24).ToString));
  end
  else begin
    Result := (Result + a[6] + ':' + a[7]);
  end;
  if (Result = '0:0:0:0:0:0:0:0') then begin
    Result := '::';
  end
  else if Result.StartsWith('0:0:0:0:0:0:0:') then begin
    Result := Result.Replace('0:0:0:0:0:0:0:', '::');
  end
  else if Result.EndsWith(':0:0:0:0:0:0:0') then begin
    Result := Result.Replace(':0:0:0:0:0:0:0', '::');
  end
  else if Result.StartsWith('0:0:0:0:0:0:') then begin
    Result := Result.Replace('0:0:0:0:0:0:', '::');
  end
  else if Result.Contains(':0:0:0:0:0:0:') then begin
    Result := Result.Replace(':0:0:0:0:0:0:', '::');
  end
  else if Result.EndsWith(':0:0:0:0:0:0') then begin
    Result := Result.Replace(':0:0:0:0:0:0', '::');
  end
  else if Result.StartsWith('0:0:0:0:0:') then begin
    Result := Result.Replace('0:0:0:0:0:', '::');
  end
  else if Result.Contains(':0:0:0:0:0:') then begin
    Result := Result.Replace(':0:0:0:0:0:', '::');
  end
  else if Result.EndsWith(':0:0:0:0:0') then begin
    Result := Result.Replace(':0:0:0:0:0', '::');
  end
  else if Result.StartsWith('0:0:0:0:') then begin
    Result := Result.Replace('0:0:0:0:', '::');
  end
  else if Result.Contains(':0:0:0:0:') then begin
    Result := Result.Replace(':0:0:0:0:', '::');
  end
  else if Result.EndsWith(':0:0:0:0') then begin
    Result := Result.Replace(':0:0:0:0', '::');
  end
  else if Result.StartsWith('0:0:0:') then begin
    Result := Result.Replace('0:0:0:', '::');
  end
  else if Result.Contains(':0:0:0:') then begin
    Result := Result.Replace(':0:0:0:', '::');
  end
  else if Result.EndsWith(':0:0:0') then begin
    Result := Result.Replace(':0:0:0', '::');
  end
  else if Result.StartsWith('0:0:') then begin
    Result := Result.Replace('0:0:', '::');
  end
  else if Result.Contains(':0:0:') then begin
    Result := Result.Replace(':0:0:', '::');
  end
  else if Result.EndsWith(':0:0') then begin
    Result := Result.Replace(':0:0', '::');
  end;
  if (Length(s) > 1) then begin
    Result := (Result + '/' + s[1]);
  end;
end;

{$ENDREGION}

{$REGION 'IPv6 Public Methods'}

//*************************************
//*****     IPv6 Constructors     *****
//*************************************

constructor TIPv6.Create();
begin
  inherited;
  Clear;
end;

constructor TIPv6.Create(const AAddress: string);
begin
  Create;
  try
    SetAddress(AAddress);
  except
    Clear;
    raise;
  end;
end;

//*************************************
//***** IPv6 Clear Address & Mask *****
//*************************************

procedure TIPv6.Clear;
begin
  FAddr := TAddr('$00000000000000000000000000000000');
  FMask := TAddr('$FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
end;

//*************************************
//*****      IPv6 Destructor      *****
//*************************************

destructor TIPv6.Destroy();
begin
  inherited;
end;

{$ENDREGION}

{$ENDREGION}

{$REGION 'Initialization/Finalization'}

var
  Copyrights: string;

initialization
  Copyrights        := 'Copyright: IP.pas (c) 2010 - 2022 by Ron Maupin' + #13#10                               +
                       'Copyright: Velthuis.BigIntegers.pas (c) 2015,2016,2017 Rudy Velthuis';

  IPv4RegEx         := TPerlRegEx.Create();
  IPv4RegEx.Options := [preExtended];
  IPv4RegEx.RegEx   := '^# Anchor'#10                                                                           +
                       '  (?:# BEGIN Dotted-decimal Notation'#10                                                +
                       '       (25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\. # 0 to 255.  *** Group 1 ***'#10 +
                       '       (25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\. # 0 to 255.  *** Group 2 ***'#10 +
                       '       (25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\. # 0 to 255.  *** Group 3 ***'#10 +
                       '       (25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])   # 0 to 255   *** Group 4 ***'#10 +
                       '  )  # END Dotted-decimal Notation'#10                                                  +
                       '  (?:# BEGIN Optional Length'#10                                                        +
                       '       /(3[0-2]|[1-2]?[0-9])                           # /0 to /32  *** Group 5 ***'#10 +
                       '  )? # END Optional Length'#10                                                          +
                       '$# Anchor'#10;
  IPv4RegEx.Study;

  IPv6RegEx         := TPerlRegEx.Create();
  IPv6RegEx.Options := [preCaseLess, preExtended];
  IPv6RegEx.RegEx   := '^# Anchor'#10                                                                           +
                       '  (# BEGIN Compressed-mixed                                         *** Group 1 ***'#10 +
                       '    (# BEGIN Hexadecimal Notation                                   *** Group 2 ***'#10 +
                       '       (?:'#10                                                                          +
                       '         (?:[0-9A-F]{1,4}:){5}[0-9A-F]{1,4}            # No ::'#10                      +
                       '       | (?:[0-9A-F]{1,4}:){4}:[0-9A-F]{1,4}           # 4::1'#10                       +
                       '       | (?:[0-9A-F]{1,4}:){3}(?::[0-9A-F]{1,4}){1,2}  # 3::2'#10                       +
                       '       | (?:[0-9A-F]{1,4}:){2}(?::[0-9A-F]{1,4}){1,3}  # 2::3'#10                       +
                       '       | [0-9A-F]{1,4}:(?::[0-9A-F]{1,4}){1,4}         # 1::4'#10                       +
                       '       | (?:[0-9A-F]{1,4}:){1,5}                       # :: End'#10                     +
                       '       | :(?::[0-9A-F]{1,4}){1,5}                      # :: Start'#10                   +
                       '       | :                                             # :: Only'#10                    +
                       '       ):'#10                                                                           +
                       '    )# END Hexadecimal Notation'#10                                                     +
                       '    (# BEGIN Dotted-decimal Notation                                *** Group 3 ***'#10 +
                       '       (25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\. # 0 to 255.  *** Group 4 ***'#10 +
                       '       (25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\. # 0 to 255.  *** Group 5 ***'#10 +
                       '       (25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\. # 0 to 255.  *** Group 6 ***'#10 +
                       '       (25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])   # 0 to 255   *** Group 7 ***'#10 +
                       '    )# END Dotted-decimal Notation'#10                                                  +
                       '  )# END Compressed-mixed'#10                                                           +
                       '  |'#10                                                                                 +
                       '  (# BEGIN Compressed                                               *** Group 8 ***'#10 +
                       '     (?:# BEGIN Hexadecimal Notation'#10                                                +
                       '       (?:[0-9A-F]{1,4}:){7}[0-9A-F]{1,4}              # No ::'#10                      +
                       '     | (?:[0-9A-F]{1,4}:){6}:[0-9A-F]{1,4}             # 6::1'#10                       +
                       '     | (?:[0-9A-F]{1,4}:){5}(?::[0-9A-F]{1,4}){1,2}    # 5::2'#10                       +
                       '     | (?:[0-9A-F]{1,4}:){4}(?::[0-9A-F]{1,4}){1,3}    # 4::3'#10                       +
                       '     | (?:[0-9A-F]{1,4}:){3}(?::[0-9A-F]{1,4}){1,4}    # 3::4'#10                       +
                       '     | (?:[0-9A-F]{1,4}:){2}(?::[0-9A-F]{1,4}){1,5}    # 2::5'#10                       +
                       '     | [0-9A-F]{1,4}:(?::[0-9A-F]{1,4}){1,6}           # 1::6'#10                       +
                       '     | (?:[0-9A-F]{1,4}:){1,7}:                        # :: End'#10                     +
                       '     | :(?::[0-9A-F]{1,4}){1,7}                        # :: Start'#10                   +
                       '     | ::                                              # :: Only'#10                    +
                       '     )  # END Hexadecimal Notation'#10                                                  +
                       '  )# END Compressed'#10                                                                 +
                       '  (?:# BEGIN Optional Length'#10                                                        +
                       '       /(12[0-8]|1[0-1][0-9]|[1-9]?[0-9])             # /0 to /128  *** Group 9 ***'#10 +
                       '  )? # END Optional Length'#10                                                          +
                       '$# Anchor'#10;
  IPv6RegEx.Study;

finalization
  IPv4RegEx.Free;
  IPv6RegEx.Free;

{$ENDREGION}

end.
