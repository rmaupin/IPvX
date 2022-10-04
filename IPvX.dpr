//******************************************************************************
//*                                                                            *
//* File:       IPvX.dpr                                                       *
//*                                                                            *
//******************************************************************************
//*                                                                            *
//* Function:   IPvX is an IP calculator for both IPv4 and IPv6, which started *
//*             as a test and demonstration of the IP.pas library, but it has  *
//*             some added features:                                           *
//*                                                                            *
//*              - A keypad that allows mouse-only use of the application,     *
//*                inspired by the IPv6 Buddy (https://www.ipv6buddy.com/)     *
//*                                                                            *
//*              - Status of the IP addressing, including the address cast,    *
//*                scope, and a (more or less official) desription.            *
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
//*              - Various IETF RFCs                                           *
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
//* Copyright:  IPvX.dpr, UI.pas, IP.pas (c) 2010 - 2022 by Ron Maupin         *
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

program IPvX;

uses
  Vcl.Forms,
  UI in 'UI.pas' {UIForm};

{$R *.res}

var
  Copyrights: string;

begin
  ReportMemoryLeaksOnShutdown := True;
  Copyrights := 'Copyright: IPvX.dpr, UI.pas, IP.pas (c) 2010 - 2022 by Ron Maupin' + #13#10 +
                'Copyright: Velthuis.BigIntegers.pas (c) 2015,2016,2017 Rudy Velthuis';
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'IPvX';
  Application.HelpFile := 'IPvX.chm';
  Application.CreateForm(TUIForm, UIForm);
  Application.Run;
end.
