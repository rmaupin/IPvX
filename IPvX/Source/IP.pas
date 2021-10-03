//******************************************************************************
//*                                                                            *
//* File:       IP.pas                                                         *
//*                                                                            *
//* Function:   A library with IPv4 and IPv6 objects that have properties and  *
//*             functions specific to each IP, and defines an IP Exception.    *
//*             The library gets and sets the IP information as strings, but   *
//*             the data are stored internally as integers: 32-bit, unsigned   *
//*             integers for IPv4, and BigInteger for IPv6. Only the address   *
//*             and mask are stored in the objects; all other values are       *
//*             calculated when they are referenced,                           *
//*                                                                            *
//*             IPv4 address and mask strings accept and return in the common  *
//*             dotted-decimal notation (leading zeroes are not permitted in   *
//*             the octets).                                                   *
//*                                                                            *
//*             IPv6 address strings will accept any of the three RFC 4291,    *
//*             section 2.2. Text Representation of Addresses conventional     *
//*             formats (1), but only return strings in the RFC 5259 canonical *
//*             format (2) (except for the Ex versions of Prefix, Network, and *
//*             Address, which return fully expanded addresses with leading    *
//*             zeroes in each of the 16-bit address fields).                  *
//*                                                                            *
//*              (1) https://datatracker.ietf.org/doc/html/rfc4291#section-2.2 *
//*              (2) https://datatracker.ietf.org/doc/html/rfc5952             *
//*                                                                            *
//*             Invalid address or mask strings throw an EIPError exception.   *
//*                                                                            *
//*             Uses the BigIntegers library by Rudy Velthuis for IPv6:        *
//*             https://github.com/rvelthuis/DelphiBigNumbers                  *
//*                                                                            *
//* Language:   Delphi version XE2 or later as required for BigInteger         *
//*                                                                            *
//* Author:     Ron Maupin                                                     *
//*                                                                            *
//* Copyright:  (c) 2010 - 2021 by Ron Maupin                                  *
//*             Velthuis.BigIntegers.pas (c) 2015,2016,2017 Rudy Velthuis      *
//*                                                                            *
//* Credits:    Thanks to Rudy Velthuis for the BigInteger library to simplify *
//*             IPv6 128-bit math. IPv6 addresses can be handled as an array   *
//*             of two 64-bit, unsigned integers, or four 32-bit, unsigned     *
//*             integers, but it is simpler and easier to be able to use       *
//*             128-bit integers as that is what an IPv6 address is.           *
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

unit IP;

interface

uses
  System.SysUtils, Velthuis.BigIntegers;  // Rwquires the use of the BigInteger library for IPv6 128-bit addresses: https://github.com/rvelthuis/DelphiBigNumbers

type

  EIPError = class(Exception);  // Defines the IP exception.

  TIPv4 = class(TObject)  // The IPv4 object; only stores the address and mask, all other properties and values are calculated when referenced
    private
      type TAddr = UInt32;                                // IPv4 addresses are 32-bit, unsigned integers
      var FAddr: TAddr;                                   // The IPv4 Address
      var FMask: TAddr;                                   // The IPv4 Mask
      function GetPrefix(): string;                       // Calculates the Prefix and returns it as a string
      procedure SetPrefix(const APrefix: string);         // Sets the Address and Mask from a Prefix string
      function GetNetwork(): string;                      // Calculates the Network and returns it as a string
      procedure SetNetwork(const ANetwork: string);       // Sets the Address from a Network string
      function GetNetLength(): string;                    // Calculates the Prefix Length and returns it as a string
      procedure SetNetLength(const ANetLength: string);   // Sets the Mask from a Prefix Length string
      function GetAddress(): string;                      // Returns the Address as a string
      procedure SetAddress(const AAddress: string);       // Sets the Address from a string
      function GetNetMask(): string;                      // Returns the Mask as a string
      procedure SetNetMask(const ANetMask: string);       // Sets the Mask from a string
      function GetHostMask(): string;                     // Calculates the Host Mask and returns it as a string
      procedure SetHostMask(const AHostMask: string);     // Sets the Mask from a Host Mask string
      function GetOffset(): string;                       // Calculates the Address Offset within the network and returns it as a string
      procedure SetOffset(const AOffset: string);         // Sets the Address from an Address Offset string
      function GetFirst(): string;                        // Calculates the First Usable Address and returns it as a string
      function GetLast(): string;                         // Calculates the Last Usable Address and returns it as a string
      function GetBroadcast(): string;                    // Calculates the Broadcast Address and returns it as a string
    public
      constructor Create();
      procedure Clear();                                                // Clears the Address and Mask by setting the Address to all zeroes and the Mask to all ones
      procedure Assign(const Source: TIPv4);                            // Assigns the Address and Mask from another IPv4 object
      function InRange(const APrefix: string): Boolean;                 // Test if the Address in in the range of a given Prefix
      destructor Destroy(); override;
      property Prefix:    string  read GetPrefix    write SetPrefix;    // The R/W Prefix property
      property Network:   string  read GetNetwork   write SetNetwork;   // The R/W Network property
      property NetLength: string  read GetNetLength write SetNetLength; // The R/W Prefix Length property
      property Address:   string  read GetAddress   write SetAddress;   // The R/W Address property
      property NetMask:   string  read GetNetMask   write SetNetMask;   // The R/W Network Mask property
      property HostMask:  string  read GetHostMask  write SetHostMask;  // The R/W Host Mask property
      property Offset:    string  read GetOffset    write SetOffset;    // The R/W Address Offset property
      property First:     string  read GetFirst;                        // The RO First Usable Address property
      property Last:      string  read GetLast;                         // The RO Last Usable Address property
      property Broadcast: string  read GetBroadcast;                    // The RO Broadcast Address property
  end;

  TIPv6 = class(TObject)  // The IPv6 object; only stores the address and mask, all other properties and values are calculated when referenced
    private
      type TAddr = BigInteger;                            // IPv6 addresses are 128-bit, unsigned integers; requires the use of integer array or BigInteger
      var FAddr: TAddr;                                   // The IPv6 Address
      var FMask: TAddr;                                   // The IPv6 Mask
      function GetPrefix(): string;                       // Calculates the Prefix and returns it as a string
      procedure SetPrefix(const APrefix: string);         // Sets the Address and Mask from a Prefix string
      function GetNetwork(): string;                      // Calculates the Network and returns it as a string
      procedure SetNetwork(const ANetwork: string);       // Sets the Address from a Network string
      function GetNetLength(): string;                    // Calculates the Prefix Length and returns it as a string
      procedure SetNetLength(const ANetLength: string);   // Sets the Mask from a Prefix Length string
      function GetAddress(): string;                      // Returns the Address as a string
      procedure SetAddress(const AAddress: string);       // Sets the Address from a string
      function GetOffset(): string;                       // Calculates the Address Offset within the network and returns it as a string
      procedure SetOffset(const AOffset: string);         // Sets the Address from an Address Offset string
      function GetFirst(): string;                        // Calculates the First Network Address and returns it as a string
      function GetLast(): string;                         // Calculates the Last Network Address and returns it as a string
    public
      constructor Create();
      procedure Clear();                                                // Clears the Address and Mask by setting the Address to all zeroes and the Mask to all ones
      procedure Assign(const Source: TIPv6);                            // Assigns the Address and Mask from another IPv4 object
      function InRange(const APrefix: string): Boolean;                 // Test if the Address in in the range of a given Prefix
      function Expand(const AAddress: string): string;                  // Fully expands an IPv6 Address or Prefix string, including leading zeroes in each of the 16-bit address fields
      function Compress(const AAddress: string): string;                // Compresses an IPv6 Address string to the RFC 5952 address format
      destructor Destroy(); override;
      property Prefix:    string  read GetPrefix    write SetPrefix;    // The R/W Prefix property
      property Network:   string  read GetNetwork   write SetNetwork;   // The R/W Network property
      property NetLength: string  read GetNetLength write SetNetLength; // The R/W Prefix Length property
      property Address:   string  read GetAddress   write SetAddress;   // The R/W Address property
      property Offset:    string  read GetOffset    write SetOffset;    // The R/W Address Offset property
      property First:     string  read GetFirst;                        // The RO First Network Address property
      property Last:      string  read GetLast;                         // The RO Last Network Address property
  end;

implementation

uses
  System.RegularExpressionsCore;

{$REGION 'IPv4'}

var
  v4AddrRegEx: TPerlRegEx;

{$REGION 'IPv4 Private Methods'}

//***** IPv4 Prefix *****

function TIPv4.GetPrefix(): string;
var
  i: Integer;   // The number of one bits in the Mask
  m, n: TAddr;  // The Mask and Network
begin
  i := 0;
  m := FMask;
  while (m > 0) do begin  // Count the number of one bits in the Mask
    i := (i + 1);
    m := (m shl 1);
  end;
  n := (FAddr and FMask);                           // Calculate the Network
  Result := (((n shr 24).ToString          + '.' +  // Calculate the 1st octet and convert to a string
             ((n shl 8) shr 24).ToString   + '.' +  // Calculate the 2nd octet and convert to a string adding to the previous string
             ((n shl 16) shr 24).ToString  + '.' +  // Calculate the 3rd octet and convert to a string adding to the previous string
             ((n shl 24) shr 24).ToString) +        // Calculate the 4th octet and convert to a string adding to the previous string
             '/' + i.ToString);                     // Convert the prefix length to a string adding to the previous string
end;

procedure TIPv4.SetPrefix(const APrefix: string);
begin
  v4AddrRegEx.Subject := APrefix;
  if v4AddrRegEx.Match then begin                         // Check that the string is a valid IPv4 common dotted decimal text representation of an IPv4 address with no leading zeroes in the octets
    if (v4AddrRegEx.Groups[5] <> '') then begin           // Check that the string has a prefix length
      if (v4AddrRegEx.Groups[5].ToInteger > 0) then begin // Calculate the Mask from the Prefix Length
        FMask := ($FFFFFFFF shl (32 - v4AddrRegEx.Groups[5].ToInteger));
      end
      else begin
        FMask := 0;
      end;
      FAddr := (((TAddr(v4AddrRegEx.Groups[1].ToInteger shl 24) // Convert the 1st string octet to a TAddr
               or TAddr(v4AddrRegEx.Groups[2].ToInteger shl 16) // Convert the 2nd string octet to a TAddr and add it
               or TAddr(v4AddrRegEx.Groups[3].ToInteger shl 8)  // Convert the 3rd string octet to a TAddr and add it
               or TAddr(v4AddrRegEx.Groups[4].ToInteger))       // Convert the 4th string octet to a TAddr and add it
               and FMask)                                       // Mask the result of the octets to get the network
               or (FAddr and ($FFFFFFFF - FMask)));             // Calculate the the address offset and addit to the calculated network, resulting in the new Address
    end
    else begin
      raise EIPError.Create('Invalid IPv4 Prefix'); // The string is missing a prefix length
    end;
  end
  else begin
    raise EIPError.Create('Invalid IPv4 Prefix'); // The string is not a valid IPv4 common dotted decimal text representation of an IPv4 address with no leading zeroes in the octets
  end;
end;

//***** IPv4 Network *****

function TIPv4.GetNetwork(): string;
var
  n: TAddr; // The Network
begin
  n := (FAddr and FMask);                         // Calculate the Network
  Result := ((n shr 24).ToString         + '.' +  // Calculate the 1st octet and convert to a string
            ((n shl 8) shr 24).ToString  + '.' +  // Calculate the 2nd octet and convert to a string adding to the previous string
            ((n shl 16) shr 24).ToString + '.' +  // Calculate the 3rd octet and convert to a string adding to the previous string
            ((n shl 24) shr 24).ToString);        // Calculate the 4th octet and convert to a string adding to the previous string
end;

procedure TIPv4.SetNetwork(const ANetwork: string);
begin
  v4AddrRegEx.Subject := ANetwork;
  if v4AddrRegEx.Match then begin                         // Check that the string is a valid IPv4 common dotted decimal text representation of an IPv4 address with no leading zeroes in the octets
    if (v4AddrRegEx.Groups[5] <> '') then begin           // Check if the string includes a prefix length
      if (v4AddrRegEx.Groups[5].ToInteger > 0) then begin // Calculate the Mask from the Prefix Length
        FMask := ($FFFFFFFF shl (32 - v4AddrRegEx.Groups[5].ToInteger));
      end
      else begin
        FMask := 0;
      end;
    end;
    FAddr := (((TAddr(v4AddrRegEx.Groups[1].ToInteger shl 24) // Convert the 1st string octet to a TAddr
             or TAddr(v4AddrRegEx.Groups[2].ToInteger shl 16) // Convert the 2nd string octet to a TAddr and add it
             or TAddr(v4AddrRegEx.Groups[3].ToInteger shl 8)  // Convert the 3rd string octet to a TAddr and add it
             or TAddr(v4AddrRegEx.Groups[4].ToInteger))       // Convert the 4th string octet to a TAddr and add it
             and FMask)                                       // Mask the result of the octets to get the network
             or (FAddr and ($FFFFFFFF - FMask)));             // Calculate the the address offset and addit to the calculated network, resulting in the new Address
  end
  else begin
    raise EIPError.Create('Invalid IPv4 Network');  // The string is not a valid IPv4 common dotted decimal text representation of an IPv4 address with no leading zeroes in the octets
  end;
end;

//***** IPv4 Prefix Length *****

function TIPv4.GetNetLength(): string;
var
  i: Integer; // The Prefix Length
  m: TAddr;   // The Mask
begin
  i := 0;
  m := FMask;
  while (m > 0) do begin  // Count the number of one bits in the Mask
    i := (i + 1);
    m := (m shl 1);
  end;
  Result := i.ToString; // Convert the number of one bits to a string
end;

procedure TIPv4.SetNetLength(const ANetLength: string);
var
  i: Integer; // The number of one bits in the Mask
begin
  try
    i := ANetLength.ToInteger;              // Convert the prefix length to an integer
    if ((i >= 0) and (i <= 32)) then begin  // Check that the prefix length is a valid length
      if (i > 0) then begin
        FMask := ($FFFFFFFF shl (32 - i));    // Calculate the Mask from the prefix length
      end
      else begin
        FMask := 0;
      end;
    end                                 
    else begin
      raise EIPError.Create('Invalid IPv4 Mask Length');  // The prefix length is out of range
    end;
  except
    raise EIPError.Create('Invalid IPv4 Mask Length');  // The string is not an integer
  end;
end;

//***** IPv4 Address *****

function TIPv4.GetAddress(): string;
begin
  Result := ((FAddr shr 24).ToString         + '.' +  // Calculate the 1st octet and convert to a string
            ((FAddr shl 8) shr 24).ToString  + '.' +  // Calculate the 2nd octet and convert to a string adding to the previous string
            ((FAddr shl 16) shr 24).ToString + '.' +  // Calculate the 3rd octet and convert to a string adding to the previous string
            ((FAddr shl 24) shr 24).ToString);        // Calculate the 4th octet and convert to a string adding to the previous string
end;

procedure TIPv4.SetAddress(const AAddress: string);
begin
  v4AddrRegEx.Subject := AAddress;
  if v4AddrRegEx.Match then begin
    FAddr := (TAddr(v4AddrRegEx.Groups[1].ToInteger shl 24) // Convert the 1st string octet to a TAddr
           or TAddr(v4AddrRegEx.Groups[2].ToInteger shl 16) // Convert the 2nd string octet to a TAddr and add it
           or TAddr(v4AddrRegEx.Groups[3].ToInteger shl 8)  // Convert the 3rd string octet to a TAddr and add it
           or TAddr(v4AddrRegEx.Groups[4].ToInteger));      // Convert the 4th string octet to a TAddr and add it
    if (v4AddrRegEx.Groups[5] <> '') then begin             // Check if the string includes a prefix length
      if (v4AddrRegEx.Groups[5].ToInteger > 0) then begin   // Calculate the Mask from the Prefix Length
        FMask := ($FFFFFFFF shl (32 - v4AddrRegEx.Groups[5].ToInteger));
      end
      else begin
        FMask := 0;
      end;
    end;
  end
  else begin
    raise EIPError.Create('Invalid IPv4 Address');  // The string is not a valid IPv4 common dotted decimal text representation of an IPv4 address with no leading zeroes in the octets
  end;
end;

//***** IPv4 Network Mask *****

function TIPv4.GetNetMask(): string;
begin
  Result := ((FMask shr 24).ToString         + '.' +  // Calculate the 1st octet and convert to a string
            ((FMask shl 8) shr 24).ToString  + '.' +  // Calculate the 2nd octet and convert to a string adding to the previous string
            ((FMask shl 16) shr 24).ToString + '.' +  // Calculate the 3rd octet and convert to a string adding to the previous string
            ((FMask shl 24) shr 24).ToString);        // Calculate the 4th octet and convert to a string adding to the previous string
end;

procedure TIPv4.SetNetMask(const ANetMask: string);
var
  m: TAddr; // The Mask
begin
  v4AddrRegEx.Subject := ANetMask;
  if v4AddrRegEx.Match then begin                 // Check that the string is a valid IPv4 common dotted decimal text representation of an IPv4 address with no leading zeroes in the octets
    if (v4AddrRegEx.Groups[5] <> '') then begin   // Check if the string includes a prefix length
      raise EIPError.Create('Invalid IPv4 Mask'); // Masks do not have prefix lengths
    end;
    m := (TAddr(v4AddrRegEx.Groups[1].ToInteger shl 24) // Convert the 1st string octet to a TAddr
       or TAddr(v4AddrRegEx.Groups[2].ToInteger shl 16) // Convert the 2nd string octet to a TAddr and add it
       or TAddr(v4AddrRegEx.Groups[3].ToInteger shl 8)  // Convert the 3rd string octet to a TAddr and add it
       or TAddr(v4AddrRegEx.Groups[4].ToInteger));      // Convert the 4th string octet to a TAddr and add it
    while (m > 0) do begin                  // Check that the string is a valid mask
      if ((m div $80000000) = 1) then begin // Check that the string is consecutive one bits
        m := (m shl 1);
      end
      else begin
        raise EIPError.Create('Invalid IPv4 Mask'); // The mask is not consecutive one bits
      end;
    end;
    FMask := (TAddr(v4AddrRegEx.Groups[1].ToInteger shl 24) // Convert the 1st string octet to a TAddr
           or TAddr(v4AddrRegEx.Groups[2].ToInteger shl 16) // Convert the 2nd string octet to a TAddr and add it
           or TAddr(v4AddrRegEx.Groups[3].ToInteger shl 8)  // Convert the 3rd string octet to a TAddr and add it
           or TAddr(v4AddrRegEx.Groups[4].ToInteger));      // Convert the 4th string octet to a TAddr and add it
  end
  else begin
    raise EIPError.Create('Invalid IPv4 Mask');
  end;
end;

//***** IPv4 Host Mask *****

function TIPv4.GetHostMask(): string;
var
  h: TAddr; // The Host Mask
begin
  h := ($FFFFFFFF - FMask);                       // Calculate the Host Mask
  Result := ((h shr 24).ToString         + '.' +  // Calculate the 1st octet and convert to a string
            ((h shl 8) shr 24).ToString  + '.' +  // Calculate the 2nd octet and convert to a string adding to the previous string
            ((h shl 16) shr 24).ToString + '.' +  // Calculate the 3rd octet and convert to a string adding to the previous string
            ((h shl 24) shr 24).ToString);        // Calculate the 4th octet and convert to a string adding to the previous string
end;

procedure TIPv4.SetHostMask(const AHostMask: string);
var
  m: TAddr; // The Mask
begin
  v4AddrRegEx.Subject := AHostMask;
  if v4AddrRegEx.Match then begin // Check that the string is a valid IPv4 common dotted decimal text representation of an IPv4 address with no leading zeroes in the octets
    if (v4AddrRegEx.Groups[5] <> '') then begin   // Check if the string includes a prefix length
      raise EIPError.Create('Invalid IPv4 Host Mask'); // Masks do not have prefix lengths
    end;
    m := ($FFFFFFFF -                                     // Invert the Mask
          (TAddr(v4AddrRegEx.Groups[1].ToInteger shl 24)  // Convert the 1st string octet to a TAddr
        or TAddr(v4AddrRegEx.Groups[2].ToInteger shl 16)  // Convert the 2nd string octet to a TAddr and add it
        or TAddr(v4AddrRegEx.Groups[3].ToInteger shl 8)   // Convert the 3rd string octet to a TAddr and add it
        or TAddr(v4AddrRegEx.Groups[4].ToInteger)));      // Convert the 4th string octet to a TAddr and add it
    while (m > 0) do begin                  // Check that the string is a valid mask
      if ((m div $80000000) = 1) then begin // Check that the string is consecutive one bits
        m := (m shl 1);
      end
      else begin
        raise EIPError.Create('Invalid IPv4 Host Mask');
      end;
    end;
    FMask := ($FFFFFFFF -                                     // Invert the Mask
              (TAddr(v4AddrRegEx.Groups[1].ToInteger shl 24)  // Convert the 1st string octet to a TAddr
            or TAddr(v4AddrRegEx.Groups[2].ToInteger shl 16)  // Convert the 2nd string octet to a TAddr and add it
            or TAddr(v4AddrRegEx.Groups[3].ToInteger shl 8)   // Convert the 3rd string octet to a TAddr and add it
            or TAddr(v4AddrRegEx.Groups[4].ToInteger)));      // Convert the 4th string octet to a TAddr and add it
  end
  else begin
    raise EIPError.Create('Invalid IPv4 Host Mask');
  end;
end;

//***** IPv4 Address Offset *****

function TIPv4.GetOffset(): string;
begin
  Result := (FAddr and ($FFFFFFFF - FMask)).ToString; // Mask the Address with the Host Mask
end;

procedure TIPv4.SetOffset(const AOffset: string);
var
  o: TAddr; // The Offset
begin
  try
    o := TAddr(AOffset.ToInt64);              // Convert the string to an integer
    if (o <= ($FFFFFFFF - FMask)) then begin  // Check that the offset is within the host portion of the address
      FAddr := ((FAddr and FMask) or o);      // Add the Offset to the Network
    end
    else begin
      raise EIPError.Create('Invalid IPv4 Address Offset'); // The Offset is outside the host portion of the address
    end;
  except
    raise EIPError.Create('Invalid IPv4 Address Offset'); // The offset is not an integer
  end;
end;

//***** IPv4 First Usable Address *****

function TIPv4.GetFirst(): string;
var
  i: Integer;   // The Prefix Length
  a, m: TAddr;  // The Address and Mask
begin
  if (FMask > 0) then begin // Check that the Mask > 0 before counting one bits
    i := 0;
    m := FMask;
    while (m > 0) do begin  // Count the number of one bits in the Mask
      i := (i + 1);
      m := (m shl 1);
    end;
    a := ((FAddr and FMask) + TAddr((i < 31) and (FAddr < $E0000000)));   // Add 1 to Prefix if Mask Length < 31 and not multicast nor reserved
    Result := ((a shr 24).ToString         + '.' +  // Calculate the 1st octet and convert to a string
              ((a shl 8) shr 24).ToString  + '.' +  // Calculate the 2nd octet and convert to a string adding to the previous string
              ((a shl 16) shr 24).ToString + '.' +  // Calculate the 3rd octet and convert to a string adding to the previous string
              ((a shl 24) shr 24).ToString);        // Calculate the 4th octet and convert to a string adding to the previous string
  end
  else begin
    Result := '0.0.0.0';  // The Mask iz zero sa the first address is zero
  end;
end;

//***** IPv4 Last Usable Address *****

function TIPv4.GetLast(): string;
var
  i: Integer;   // The Prefix Length
  a, m: TAddr;  // The Address and Mask
begin
  if (FMask > 0) then begin // Check that the Mask > 0 before counting one bits
    i := 0;
    m := FMask;
    while (m > 0) do begin  // Count the number of one bits in the Mask
      i := (i + 1);
      m := (m shl 1);
    end;
    a := (((FAddr and FMask) + ($FFFFFFFF - FMask)) - TAddr((i < 31) and (FAddr < $E0000000)));  // Subtract 1 from Broadcast Address if Mask Length < 31 and not multicast nor reserved
    Result := ((a shr 24).ToString         + '.' +  // Calculate the 1st octet and convert to a string
              ((a shl 8) shr 24).ToString  + '.' +  // Calculate the 2nd octet and convert to a string adding to the previous string
              ((a shl 16) shr 24).ToString + '.' +  // Calculate the 3rd octet and convert to a string adding to the previous string
              ((a shl 24) shr 24).ToString);        // Calculate the 4th octet and convert to a string adding to the previous string
  end
  else begin
    Result := '255.255.255.255';  // The Mask iz zero sa the last address is all one bits
  end;
end;

//***** IPv4 Broadcast Address *****

function TIPv4.GetBroadcast(): string;
var
  a: TAddr; // The Address
begin
  if ((FMask > 0) and (FAddr < $E0000000)) then begin // Check that the Mask > 0 and not multicast nor reserved
    a := ((FAddr and FMask) or ($FFFFFFFF - FMask));   // Network + Inverse Mask
    Result := ((a shr 24).ToString         + '.' +  // Calculate the 1st octet and convert to a string
              ((a shl 8) shr 24).ToString  + '.' +  // Calculate the 2nd octet and convert to a string adding to the previous string
              ((a shl 16) shr 24).ToString + '.' +  // Calculate the 3rd octet and convert to a string adding to the previous string
              ((a shl 24) shr 24).ToString);        // Calculate the 4th octet and convert to a string adding to the previous string
  end
  else begin
    Result := 'N/A';  // Not a network with a Broadcast Address
  end;
end;

{$ENDREGION}

{$REGION 'IPv4 Public Methods'}

//***** IPv4 Create *****

constructor TIPv4.Create();
begin
  inherited;
  Clear;      // Initialize Address to zero and Mask to all one bits
end;

//***** IPv4 Clear Address and Mask *****

procedure TIPv4.Clear();
begin
  FAddr := $00000000; // Clear Address to zero
  FMask := $FFFFFFFF; // Set Mask to all one bits
end;

//***** IPv4 Assign Address and Mask *****

procedure TIPv4.Assign(const Source: TIPv4);
begin
  FAddr := Source.FAddr;  // Assign the Address from the Address in the other IPv4 oject
  FMask := Source.FMask;  // Assign the Mask from the Mask in the other IPv4 oject
end;

//***** IPv4 Address in a Range *****

function TIPv4.InRange(const APrefix: string): Boolean;
var
  a, m: TAddr;  // The Prefix address and mask
begin
  v4AddrRegEx.Subject := APrefix;
  if v4AddrRegEx.Match then begin                                     // Check that the string is a valid IPv4 common dotted decimal text representation of an IPv4 address with no leading zeroes in the octets
    if (v4AddrRegEx.Groups[5] <> '') then begin                       // Check that the string has a prefix length
      if (v4AddrRegEx.Groups[5].ToInteger > 0) then begin             // Calculate Prefix and Prefix Length
        a := (TAddr(v4AddrRegEx.Groups[1].ToInteger shl 24)           // Convert the 1st string octet to a TAddr
           or TAddr(v4AddrRegEx.Groups[2].ToInteger shl 16)           // Convert the 2nd string octet to a TAddr and add it
           or TAddr(v4AddrRegEx.Groups[3].ToInteger shl 8)            // Convert the 3rd string octet to a TAddr and add it
           or TAddr(v4AddrRegEx.Groups[4].ToInteger));                // Convert the 4th string octet to a TAddr and add it
        m := ($FFFFFFFF shl (32 - v4AddrRegEx.Groups[5].ToInteger));  // Calculate the Prefix Length
        Result := ((a and m) = (FAddr and m));                        // Return Prefix = Address AND Prefix Mask
      end
      else begin
        Result := True; // A zero Mask means every Address is in the same Prefix
      end;
    end
    else begin
      raise EIPError.Create('Invalid IPv4 Range');  // The string is missing a prefix length
    end;
  end
  else begin
    raise EIPError.Create('Invalid IPv4 Range');  // The string is not a valid IPv4 common dotted decimal text representation of an IPv4 address with no leading zeroes in the octets
  end;
end;

//***** IPv4 Destroy *****

destructor TIPv4.Destroy();
begin
  inherited;
end;

{$ENDREGION}

{$ENDREGION}

{$REGION 'IPv6'}

var
  v6AddrRegEx: TPerlRegEx;
  v6LengRegEx: TPerlRegEx;
  v6MixdRegEx: TPerlRegEx;

{$REGION 'IPv6 Private Methods'}

//***** IPv6 Expand Address/Prefix *****

function TIPv6.Expand(const AAddress: string): string;  // Accepts any RFC 4291 Section 2.2 address format (1, 2,or 3), returning RFC 4291 Section 2.2 format 1 with leading zeroes
var
  i: Integer;   // Counter
  a, m: string; // Address and Mask
begin
  v6LengRegEx.Subject := AAddress;
  if v6LengRegEx.Match then begin // Check if there is a prefix length on the address
    a := v6LengRegEx.Groups[1];   // Address
    m := v6LengRegEx.Groups[2];   // Mask Length
  end
  else begin
    a := AAddress;                // Address
    m := '';                      // No Mask Length
  end;
  v6MixdRegEx.Subject := a;
  if v6MixdRegEx.Match then begin // Check for a Mixed address
    a := v6MixdRegEx.Groups[1] +                                  // IPv6 notation part of address
         IntToHex(((v6MixdRegEx.Groups[2].ToInteger shl 8)        // Convert IPv4 1st octet
                 or v6MixdRegEx.Groups[3].ToInteger), 1) + ':' +  // Convert IPv4 2nd octet and add
         IntToHex(((v6MixdRegEx.Groups[4].ToInteger shl 8)        // Convert IPv4 3rd octet
                 or v6MixdRegEx.Groups[5].ToInteger), 1);         // Convert IPv4 2nd octet and add
  end;
  if a.Contains('::') then begin                        // Check for double colon
    case a.CountChar(':') of
      2: begin                                          // Two colons (only double)
        if (a = '::') then begin                        // Check if only a double colon
          a := '0:0:0:0:0:0:0:0';                       // Replace with eight zero words
        end
        else if (a.StartsWith('::')) then begin         // Check if the double colon at start
          a := a.Replace('::', '0:0:0:0:0:0:0:');       // Replace at start with seven zero words
        end
        else if (a.EndsWith('::')) then begin           // Check if the double colon at end
          a := a.Replace('::', ':0:0:0:0:0:0:0');       // Replace at end with seven zero words
        end
        else begin
          a := a.Replace('::', ':0:0:0:0:0:0:');        // Replace in middle with six zero words
        end;
      end;
      3: begin                                          // Three colons (double and one other)
        if (a.StartsWith('::')) then begin              // Check if the double colon at start
          a := a.Replace('::', '0:0:0:0:0:0:');         // Replace at start with six zero words
        end
        else if (a.EndsWith('::')) then begin           // Check if the double colon at end
          a := a.Replace('::', ':0:0:0:0:0:0');         // Replace at end with six zero words
        end
        else begin
          a := a.Replace('::', ':0:0:0:0:0:');          // Replace in middle with five zero words
        end;
      end;
      4: begin                                          // Four colons (double and two others)
        if (a.StartsWith('::')) then begin              // Check if the double colon at start
          a := a.Replace('::', '0:0:0:0:0:');           // Replace at start with five zero words
        end
        else if (a.EndsWith('::')) then begin           // Check if the double colon at end
          a := a.Replace('::', ':0:0:0:0:0');           // Replace at end with five zero words
        end
        else begin
          a := a.Replace('::', ':0:0:0:0:');            // Replace in middle with four zero words
        end;
      end;
      5: begin                                          // Five colons (double and three others)
        if (a.StartsWith('::')) then begin              // Check if the double colon at start
          a := a.Replace('::', '0:0:0:0:');             // Replace at start with four zero words
        end
        else if (a.EndsWith('::')) then begin           // Check if the double colon at end
          a := a.Replace('::', ':0:0:0:0');             // Replace at end with four zero words
        end
        else begin
          a := a.Replace('::', ':0:0:0:');              // Replace in middle with three zero words
        end;
      end;
      6: begin                                          // Six colons (double and four others)
        if (a.StartsWith('::')) then begin              // Check if the double colon at start
          a := a.Replace('::', '0:0:0:');               // Replace at start with three zero words
        end
        else if (a.EndsWith('::')) then begin           // Check if the double colon at end
          a := a.Replace('::', ':0:0:0');               // Replace at end with three zero words
        end
        else begin
          a := a.Replace('::', ':0:0:');                // Replace in middle with two zero words
        end;
      end;
      7: begin                                          // Seven colons (double and five others)
        if (a.StartsWith('::')) then begin              // Check if the double colon at start
          a := a.Replace('::', '0:0:');                 // Replace at start with two zero words
        end
        else if (a.EndsWith('::')) then begin           // Check if the double colon at end
          a := a.Replace('::', ':0:0');                 // Replace at end with two zero words
        end
        else begin
          a := a.Replace('::', ':0:');                  // Replace in middle with one zero words
        end;
      end;
      else begin
        raise EIPError.Create('Invalid IPv6 Address');  // Too many colons
      end;
    end;
  end;
  v6AddrRegEx.Subject := a;                             
  if v6AddrRegEx.Match then begin                       // Check for valid IPv6 address
    Result := '';
    for i := 1 to 8 do begin
      Result := (Result + IntToHex(('$' + v6AddrRegEx.Groups[i]).ToInteger, 4) + ':');  // Expand all eight words
    end;
    Delete(Result, Length(Result), 1);  // Remove final colon
    Result := (Result + m);             // Add back any prefix length
    Result := Result.ToLower;           // Convert alphabetic hexadecimal digits to lowercase
  end
  else begin
    raise EIPError.Create('Invalid IPv6 Address');  // Invalid IPv6 address
  end;
end;

//***** IPv6 Compress Address/Prefix *****

function TIPv6.Compress(const AAddress: string): string;  // Accepts any RFC 4291 Section 2.2 address format (1, 2,or 3), returning RFC 5952 format
var
  i: Integer;
  m: string;
  w: array[1..8] of string;
  u: UInt32;
begin
  v6AddrRegEx.Subject := AAddress;
  if v6AddrRegEx.Match then begin // Check for valid IPv6 address
    for i := 1 to 8 do begin
      w[i] := IntToHex(('$' + v6AddrRegEx.Groups[i]).ToInteger, 1); // Strip leading zeroes
    end;
    m := v6AddrRegEx.Groups[9]; // Capture any prefix length
    Result := '';
    for i := 1 to 6 do begin
      Result := (Result + w[i] + ':');  // Separate first six words with colons
    end;
    if (Result = '0:0:0:0:0:ffff:') then begin                            // Check for IPv4-Mapped address
      u := ((UInt32(w[7].ToInteger) shl 16) and UInt32(w[8].ToInteger));  // Calculate IPv4 address
      Result := (Result + 
                ((u shr 24).ToString         + '.' +  // Convert IPv4 1st octet and add to string
                ((u shl 8) shr 24).ToString  + '.' +  // Convert IPv4 2nd octet and add to string 
                ((u shl 16) shr 24).ToString + '.' +  // Convert IPv4 3rd octet and add to string
                ((u shl 24) shr 24).ToString));       // Convert IPv4 4th octet and add to string
    end
    else begin                                        // Not IPv4-Mapped address
      Result := (Result + w[7] + ':' + w[8]);         // Add last two words to string
    end;
    Result := Result.ToLower;                         // Convert alphabetic hexadecimal digits to lowercase 
    if (Result = '0:0:0:0:0:0:0:0') then begin              // Compress all-zeroes address
      Result := '::';
    end
    else if Result.StartsWith('0:0:0:0:0:0:0:') then begin  
      Result := Result.Replace('0:0:0:0:0:0:0:', '::');     // Compress seven zeroes at start
    end
    else if Result.EndsWith(':0:0:0:0:0:0:0') then begin    
      Result := Result.Replace(':0:0:0:0:0:0:0', '::');     // Compress seven zeroes at end
    end
    else if Result.StartsWith('0:0:0:0:0:0:') then begin
      Result := Result.Replace('0:0:0:0:0:0:', '::');       // Compress six zeroes at start
    end
    else if Result.Contains(':0:0:0:0:0:0:') then begin
      Result := Result.Replace(':0:0:0:0:0:0:', '::');      // Compress six zeroes in middle
    end
    else if Result.EndsWith(':0:0:0:0:0:0') then begin
      Result := Result.Replace(':0:0:0:0:0:0', '::');       // Compress six zeroes at end
    end
    else if Result.StartsWith('0:0:0:0:0:') then begin      // Compress five zeroes at start
      Result := Result.Replace('0:0:0:0:0:', '::');
    end
    else if Result.Contains(':0:0:0:0:0:') then begin
      Result := Result.Replace(':0:0:0:0:0:', '::');        // Compress five zeroes in middle
    end
    else if Result.EndsWith(':0:0:0:0:0') then begin
      Result := Result.Replace(':0:0:0:0:0', '::');         // Compress five zeroes at end
    end
    else if Result.StartsWith('0:0:0:0:') then begin        // Compress four zeroes at start
      Result := Result.Replace('0:0:0:0:', '::');
    end
    else if Result.Contains(':0:0:0:0:') then begin
      Result := Result.Replace(':0:0:0:0:', '::');          // Compress four zeroes in middle
    end
    else if Result.EndsWith(':0:0:0:0') then begin
      Result := Result.Replace(':0:0:0:0', '::');           // Compress four zeroes at end
    end
    else if Result.StartsWith('0:0:0:') then begin          // Compress three zeroes at start
      Result := Result.Replace('0:0:0:', '::');
    end
    else if Result.Contains(':0:0:0:') then begin
      Result := Result.Replace(':0:0:0:', '::')             // Compress three zeroes in middle
    end
    else if Result.EndsWith(':0:0:0') then begin
      Result := Result.Replace(':0:0:0', '::')              // Compress three zeroes at end
    end
    else if Result.StartsWith('0:0:') then begin            // Compress two zeroes at start
      Result := Result.Replace('0:0:', '::');
    end
    else if Result.Contains(':0:0:') then begin
      Result := Result.Replace(':0:0:', '::');              // Compress two zeroes in middle
    end
    else if Result.EndsWith(':0:0') then begin
      Result := Result.Replace(':0:0', '::');               // Compress two zeroes at end
    end;
    if (m <> '') then begin
      Result := (Result + '/' + m);
    end;
  end
  else begin
    raise EIPError.Create('Invalid IPv6 Address');          // Invalid IPv6 address
  end;
end;

//***** IPv6 Prefix *****

function TIPv6.GetPrefix(): string;
var
  i: Integer;   // The number of one bits in the Mask
  m, n: TAddr;  // The Mask and Network
begin
  i := 0;
  m := FMask;             
  while (m > 0) do begin  // Count the number of one bits in the Mask
    i := (i + 1);
    m := (m mod '$80000000000000000000000000000000');
    m := (m shl 1);
  end;
  n := (FAddr and FMask);                                                                   // Calculate the Network
  Result := Compress(((n shr 112).ToHexString                                      + ':' +  // Calculate the 1st word and convert to a string
                     ((n mod '$10000000000000000000000000000') shr 96).ToHexString + ':' +  // Calculate the 2nd word and convert to a string adding to the previous string
                     ((n mod '$1000000000000000000000000') shr 80).ToHexString     + ':' +  // Calculate the 3rd word and convert to a string adding to the previous string
                     ((n mod '$100000000000000000000') shr 64).ToHexString         + ':' +  // Calculate the 4th word and convert to a string adding to the previous string
                     ((n mod '$10000000000000000') shr 48).ToHexString             + ':' +  // Calculate the 5th word and convert to a string adding to the previous string
                     ((n mod '$1000000000000') shr 32).ToHexString                 + ':' +  // Calculate the 6th word and convert to a string adding to the previous string
                     ((n mod '$100000000') shr 16).ToHexString                     + ':' +  // Calculate the 7th word and convert to a string adding to the previous string
                      (n mod '$10000').ToHexString).ToLower                        +        // Calculate the 8th word and convert to a string adding to the previous string
                     '/' + i.ToString);                                                     // Convert the prefix length to a string adding to the previous string
end;

procedure TIPv6.SetPrefix(const APrefix: string);
begin
  try
    v6AddrRegEx.Subject := Expand(APrefix);
    if v6AddrRegEx.Match then begin                          // Check that the string is a valid IPv6 text representation
      if (v6AddrRegEx.Groups[9] <> '') then begin            // Check that the string has a prefix length
        if (v6AddrRegEx.Groups[9].ToInteger > 0) then begin  // Calculate the Mask from the Prefix Length
          FMask := ((BigInteger('$FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF') shl (128 - v6AddrRegEx.Groups[9].ToInteger)) mod '$100000000000000000000000000000000');
        end
        else begin
          FMask := 0;
        end;
        FAddr := ((('$' + v6AddrRegEx.Groups[1] +                                         // The 1st string word
                          v6AddrRegEx.Groups[2] +                                         // The 2nd string word
                          v6AddrRegEx.Groups[3] +                                         // The 3rd string word
                          v6AddrRegEx.Groups[4] +                                         // The 4th string word
                          v6AddrRegEx.Groups[5] +                                         // The 5th string word
                          v6AddrRegEx.Groups[6] +                                         // The 6th string word
                          v6AddrRegEx.Groups[7] +                                         // The 7th string word
                          v6AddrRegEx.Groups[8])                                          // The 8th string word
                          and FMask)                                                      // Mask the result of the words to get the network
                          or (FAddr and ('$FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF' - FMask)));  // Calculate the the address offset and addit to the calculated network, resulting in the new Address
      end
      else begin
        raise EIPError.Create('Invalid IPv6 Prefix'); // The string is missing a prefix length
      end;
    end
    else begin
      raise EIPError.Create('Invalid IPv6 Prefix'); // The string is not a valid IPv6 text representation
    end;
  except
    raise EIPError.Create('Invalid IPv6 Prefix'); // The string cannot expand because it is not a valid IPv6 text representation
  end;
end;

//***** IPv6 Network *****

function TIPv6.GetNetwork(): string;
var
  n: TAddr; // The Network
begin
  n := (FAddr and FMask);                                                                   // Calculate the Network
  Result := Compress(((n shr 112).ToHexString                                      + ':' +  // Calculate the 1st word and convert to a string
                     ((n mod '$10000000000000000000000000000') shr 96).ToHexString + ':' +  // Calculate the 2nd word and convert to a string adding to the previous string
                     ((n mod '$1000000000000000000000000') shr 80).ToHexString     + ':' +  // Calculate the 3rd word and convert to a string adding to the previous string
                     ((n mod '$100000000000000000000') shr 64).ToHexString         + ':' +  // Calculate the 4th word and convert to a string adding to the previous string
                     ((n mod '$10000000000000000') shr 48).ToHexString             + ':' +  // Calculate the 5th word and convert to a string adding to the previous string
                     ((n mod '$1000000000000') shr 32).ToHexString                 + ':' +  // Calculate the 6th word and convert to a string adding to the previous string
                     ((n mod '$100000000') shr 16).ToHexString                     + ':' +  // Calculate the 7th word and convert to a string adding to the previous string
                      (n mod '$10000').ToHexString).ToLower);                               // Calculate the 8th word and convert to a string adding to the previous string
end;

procedure TIPv6.SetNetwork(const ANetwork: string);
begin
  try
    v6AddrRegEx.Subject := Expand(ANetwork);
    if v6AddrRegEx.Match then begin                          // Check that the string is a valid IPv6 text representation
      if (v6AddrRegEx.Groups[9] <> '') then begin            // Check that the string has a prefix length
        if (v6AddrRegEx.Groups[9].ToInteger > 0) then begin  // Calculate the Mask from the Prefix Length
          FMask := ((BigInteger('$FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF') shl (128 - v6AddrRegEx.Groups[9].ToInteger)) mod '$100000000000000000000000000000000');
        end
        else begin
          FMask := 0;
        end;
      end;
      FAddr := ((('$' + v6AddrRegEx.Groups[1] +                                         // The 1st string word
                        v6AddrRegEx.Groups[2] +                                         // The 2nd string word
                        v6AddrRegEx.Groups[3] +                                         // The 3rd string word
                        v6AddrRegEx.Groups[4] +                                         // The 4th string word
                        v6AddrRegEx.Groups[5] +                                         // The 5th string word
                        v6AddrRegEx.Groups[6] +                                         // The 6th string word
                        v6AddrRegEx.Groups[7] +                                         // The 7th string word
                        v6AddrRegEx.Groups[8])                                          // The 8th string word
                        and FMask)                                                      // Mask the result of the words to get the network
                        or (FAddr and ('$FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF' - FMask)));  // Calculate the the address offset and addit to the calculated network, resulting in the new Address
    end
    else begin
      raise EIPError.Create('Invalid IPv6 Network'); // The string is not a valid IPv6 text representation
    end;
  except
    raise EIPError.Create('Invalid IPv6 Network'); // The string cannot expand because it is not a valid IPv6 text representation
  end;
end;

//***** IPv6 Prefix Length *****

function TIPv6.GetNetLength(): string;
var
  i: Integer; // The Prefix Length
  m: TAddr;   // The Mask
begin
  i := 0;
  m := FMask;
  while (m > 0) do begin  // Count the number of one bits in the Mask
    i := (i + 1);
    m := (m mod '$80000000000000000000000000000000');
    m := (m shl 1);
  end;
  Result := i.ToString; // Convert the number of one bits to a string
end;

procedure TIPv6.SetNetLength(const ANetLength: string);
var
  i: Integer; // The number of one bits in the Mask
begin
  try
    i := ANetLength.ToInteger;
    if ((i >= 0) and (i <= 128)) then begin
      if (i > 0) then begin
        FMask := ((BigInteger('$FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF') shl (128 - i)) mod '$100000000000000000000000000000000');
      end
      else begin
        FMask := 0;
      end;
    end
    else begin
      raise EIPError.Create('Invalid IPv6 Mask Length');  // The prefix length is out of range
    end;
  except
    raise EIPError.Create('Invalid IPv6 Mask Length');  // The string is not an integer
  end;
end;

//***** IPv6 Address *****

function TIPv6.GetAddress(): string;
begin
  Result := Compress(((FAddr shr 112).ToHexString                                      + ':' +  // Calculate the 1st word and convert to a string
                     ((FAddr mod '$10000000000000000000000000000') shr 96).ToHexString + ':' +  // Calculate the 2nd word and convert to a string adding to the previous string
                     ((FAddr mod '$1000000000000000000000000') shr 80).ToHexString     + ':' +  // Calculate the 3rd word and convert to a string adding to the previous string
                     ((FAddr mod '$100000000000000000000') shr 64).ToHexString         + ':' +  // Calculate the 4th word and convert to a string adding to the previous string
                     ((FAddr mod '$10000000000000000') shr 48).ToHexString             + ':' +  // Calculate the 5th word and convert to a string adding to the previous string
                     ((FAddr mod '$1000000000000') shr 32).ToHexString                 + ':' +  // Calculate the 6th word and convert to a string adding to the previous string
                     ((FAddr mod '$100000000') shr 16).ToHexString                     + ':' +  // Calculate the 7th word and convert to a string adding to the previous string
                      (FAddr mod '$10000').ToHexString).ToLower);                               // Calculate the 8th word and convert to a string adding to the previous string
end;

procedure TIPv6.SetAddress(const AAddress: string);
begin
  try
    v6AddrRegEx.Subject := Expand(AAddress);
    if v6AddrRegEx.Match then begin           // Check that the string is a valid IPv6 text representation
      FAddr := ('$' + v6AddrRegEx.Groups[1] + // The 1st string word
                      v6AddrRegEx.Groups[2] + // The 2nd string word
                      v6AddrRegEx.Groups[3] + // The 3rd string word
                      v6AddrRegEx.Groups[4] + // The 4th string word
                      v6AddrRegEx.Groups[5] + // The 5th string word
                      v6AddrRegEx.Groups[6] + // The 6th string word
                      v6AddrRegEx.Groups[7] + // The 7th string word
                      v6AddrRegEx.Groups[8]); // The 8th string word
      if (v6AddrRegEx.Groups[9] <> '') then begin            // Check that the string has a prefix length
        if (v6AddrRegEx.Groups[9].ToInteger > 0) then begin  // Calculate the Mask from the Prefix Length
          FMask := ((BigInteger('$FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF') shl (128 - v6AddrRegEx.Groups[9].ToInteger)) mod '$100000000000000000000000000000000');
        end
        else begin
          FMask := 0;
        end;
      end;
    end
    else begin
      raise EIPError.Create('Invalid IPv6 Address');  // The string is not a valid IPv6 text representation
    end;
  except
    raise EIPError.Create('Invalid IPv6 Address');  // The string cannot expand because it is not a valid IPv6 text representation
  end;
end;

//***** IPv6 Address Offset *****

function TIPv6.GetOffset(): string;
begin
  Result := (FAddr and ('$FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF' - FMask)).ToDecimalString;  // Mask the Address with the Host Mask
end;

procedure TIPv6.SetOffset(const AOffset: string);
var
  o: TAddr; // The Offset
begin
  try
    o := ('0d' + AOffset);                                              // Convert the string to an integer
    if (o <= ('$FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF' - FMask)) then begin  // Check that the offset is within the host portion of the address
      FAddr := ((FAddr and FMask) or o);                                // Add the Offset to the Network
    end
    else begin
      raise EIPError.Create('Invalid IPv6 Address Offset'); // The Offset is outside the host portion of the address
    end;
  except
    raise EIPError.Create('Invalid IPv6 Address Offset'); // The offset is not an integer
  end;
end;

//***** IPv6 First Network Address *****

function TIPv6.GetFirst(): string;
var
  n: TAddr; // The Network
begin
  n := (FAddr and FMask);                                                                   // Calculate the Network
  Result := Compress(((n shr 112).ToHexString                                      + ':' +  // Calculate the 1st word and convert to a string
                     ((n mod '$10000000000000000000000000000') shr 96).ToHexString + ':' +  // Calculate the 2nd word and convert to a string adding to the previous string
                     ((n mod '$1000000000000000000000000') shr 80).ToHexString     + ':' +  // Calculate the 3rd word and convert to a string adding to the previous string
                     ((n mod '$100000000000000000000') shr 64).ToHexString         + ':' +  // Calculate the 4th word and convert to a string adding to the previous string
                     ((n mod '$10000000000000000') shr 48).ToHexString             + ':' +  // Calculate the 5th word and convert to a string adding to the previous string
                     ((n mod '$1000000000000') shr 32).ToHexString                 + ':' +  // Calculate the 6th word and convert to a string adding to the previous string
                     ((n mod '$100000000') shr 16).ToHexString                     + ':' +  // Calculate the 7th word and convert to a string adding to the previous string
                      (n mod '$10000').ToHexString).ToLower);                               // Calculate the 8th word and convert to a string adding to the previous string
end;

//***** IPv6 Last Network Address *****

function TIPv6.GetLast(): string;
var
  a: TAddr; // The Address
begin
  a := ((FAddr and FMask) or ('$FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF' - FMask));                // Calculate the Address from the Network plus the largest host address
  Result := Compress(((a shr 112).ToHexString                                      + ':' +  // Calculate the 1st word and convert to a string
                     ((a mod '$10000000000000000000000000000') shr 96).ToHexString + ':' +  // Calculate the 2nd word and convert to a string adding to the previous string
                     ((a mod '$1000000000000000000000000') shr 80).ToHexString     + ':' +  // Calculate the 3rd word and convert to a string adding to the previous string
                     ((a mod '$100000000000000000000') shr 64).ToHexString         + ':' +  // Calculate the 4th word and convert to a string adding to the previous string
                     ((a mod '$10000000000000000') shr 48).ToHexString             + ':' +  // Calculate the 5th word and convert to a string adding to the previous string
                     ((a mod '$1000000000000') shr 32).ToHexString                 + ':' +  // Calculate the 6th word and convert to a string adding to the previous string
                     ((a mod '$100000000') shr 16).ToHexString                     + ':' +  // Calculate the 7th word and convert to a string adding to the previous string
                      (a mod '$10000').ToHexString).ToLower);                               // Calculate the 8th word and convert to a string adding to the previous string
end;

{$ENDREGION}

{$REGION 'IPv6 Public Methods'}

//***** IPv6 Create *****

constructor TIPv6.Create();
begin
  inherited;
  Clear;      // Initialize Address to zero and Mask to all one bits
end;

//***** IPv6 Clear Address and Mask *****

procedure TIPv6.Clear;
begin
  FAddr := '$00000000000000000000000000000000'; // Clear Address to zero
  FMask := '$FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'; // Set Mask to all one bits
end;

//***** IPv6 Assign Address and Mask *****

procedure TIPv6.Assign(const Source: TIPv6);
begin
  FAddr := Source.FAddr;  // Assign the Address from the Address in the other IPv6 oject
  FMask := Source.FMask;  // Assign the Mask from the Mask in the other IPv6 oject
end;

//***** IPv6 Address in a Range *****

function TIPv6.InRange(const APrefix: string): Boolean;
var
  a, m: TAddr;  // The Prefix address and mask
begin
  try
    v6AddrRegEx.Subject := Expand(APrefix);
    if v6AddrRegEx.Match then begin                         // Check that the string is a valid IPv6 text representation
      if (v6AddrRegEx.Groups[9] <> '') then begin           // Check that the string has a prefix length
        if (v6AddrRegEx.Groups[9].ToInteger > 0) then begin // Calculate Prefix and Prefix Length
          a := ('$' + v6AddrRegEx.Groups[1] +               // The 1st string word
                      v6AddrRegEx.Groups[2] +               // The 2nd string word
                      v6AddrRegEx.Groups[3] +               // The 3rd string word
                      v6AddrRegEx.Groups[4] +               // The 4th string word
                      v6AddrRegEx.Groups[5] +               // The 5th string word
                      v6AddrRegEx.Groups[6] +               // The 6th string word
                      v6AddrRegEx.Groups[7] +               // The 7th string word
                      v6AddrRegEx.Groups[8]);               // The 8th string word
          m := ((BigInteger('$FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF') shl (128 - v6AddrRegEx.Groups[9].ToInteger)) mod '$100000000000000000000000000000000');  // Calculate the Prefix Length
          Result := ((a and m) = (FAddr and m));            // Return Prefix = Address AND Prefix Mask
        end
        else begin
          Result := True; // A zero Mask means every Address is in the same Prefix
        end;
      end
      else begin
        raise EIPError.Create('Invalid IPv6 Range');  // The string is missing a prefix length
      end;
    end
    else begin
      raise EIPError.Create('Invalid IPv6 Range');  // The string is not a valid IPv6 text representation
    end;
  except
    raise EIPError.Create('Invalid IPv6 Range');  // The string cannot expand because it is not a valid IPv6 text representation
  end;
end;

//***** IPv6 Destroy *****

destructor TIPv6.Destroy();
begin
  inherited;
end;

{$ENDREGION}

{$ENDREGION}

initialization  // Initialize regular expressions
begin
  BigInteger.Base := 16;
  v4AddrRegEx         := TPerlRegEx.Create();
  v4AddrRegEx.RegEx   := '^(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.' +
                          '(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.' +
                          '(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.' +
                          '(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])'   +
                          '(?:/(3[0-2]|[1-2]?[0-9]))?$';
  v4AddrRegEx.Study;
  v6AddrRegEx         := TPerlRegEx.Create();
  v6AddrRegEx.RegEx   := '^([0-9A-F]{1,4}):' +
                          '([0-9A-F]{1,4}):' +
                          '([0-9A-F]{1,4}):' +
                          '([0-9A-F]{1,4}):' +
                          '([0-9A-F]{1,4}):' +
                          '([0-9A-F]{1,4}):' +
                          '([0-9A-F]{1,4}):' +
                          '([0-9A-F]{1,4})'  +
                          '(?:/(12[0-8]|1[0-1][0-9]|[1-9]?[0-9]))?$';
  v6AddrRegEx.Options := [preCaseLess];
  v6AddrRegEx.Study;
  v6LengRegEx         := TPerlRegEx.Create();
  v6LengRegEx.RegEx   := '^(.+)' +
                          '(/(?:12[0-8]|1[0-1][0-9]|[1-9]?[0-9]))$';
  v6LengRegEx.Study;
  v6MixdRegEx         := TPerlRegEx.Create();
  v6MixdRegEx.RegEx   := '^(.+:)' +
                          '(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.' +
                          '(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.' +
                          '(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.' +
                          '(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])?$';
  v6MixdRegEx.Options := [preCaseLess];
  v6MixdRegEx.Study;
end;

finalization  // Free regular expressions
begin
  v4AddrRegEx.Free;
  v6AddrRegEx.Free;
  v6LengRegEx.Free;
  v6MixdRegEx.Free;
end;

end.
