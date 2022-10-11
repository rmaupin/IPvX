//******************************************************************************
//*                                                                            *
//* File:       About.pas                                                      *
//*                                                                            *
//* Function:   An About form for VCL applications on Windows. The form will   *
//*             display information about the hosting application when the     *
//*             form is displayed from the hosting application.                *
//*                                                                            *
//*             The form has a 64x64 pixel virtual image to which the hosting  *
//*             application can assign an image collection and an image index  *
//*             or image name from the image collection.                       *
//*                                                                            *
//*             The form will display the Product Name, Product Version, and   *
//*             Legal Copyright as configured in the hosting application       *
//*             project options. There is also a label with a boilerplate      *
//*             copyright protection warning.                                  *
//*                                                                            *
//*             The form also has public string variables that are populated   *
//*             with the strings from the hosting application project options, *
//*             Application, Version Info keys and values. The variables can   *
//*             easily be referenced from the hosting application. The string  *
//*             variables are assigned values when the form is created.        *
//*                                                                            *
//*              - CompanyName                                                 *
//*              - FileDescription: string;                                    *
//*              - FileVersion: string;                                        *
//*              - InternalName: string;                                       *
//*              - LegalCopyright: string;                                     *
//*              - LegalTrademarks: string;                                    *
//*              - OriginalFilename: string;                                   *
//*              - ProductName: string;                                        *
//*              - ProductVersion: string;                                     *
//*              - Comments: string;                                           *
//*                                                                            *
//* Language:   Delphi version 10.4 or later as required for Virtual Images    *
//*                                                                            *
//* Usage:      WARNING: The About form should NOT be added to the project;    *
//*             only add it in the uses clause of the VCL form unit.           *
//*                                                                            *
//*             (1) Add About to the uses clause of the VCL form unit of the   *
//*                 hosting application.                                       *
//*             (2) Create an AboutForm by vaiable assignment,                 *
//*                   e.g. FAbout := TAboutForm.Create(self);                  *
//*                 in the FormCreate event of the hosting application.        *
//*             (3) Assign the AboutForm.AboutImage.ImageCollection to an      *
//*                 ImageCollection in the hosting application.                *
//*             (4) Assign the AboutForm.AboutImage.ImageIndex or the          *
//*                 AboutForm.AboutImage.ImageName to an image in the          *
//*                 ImageCollection.                                           *
//*             (5) Call the AboutForm.ShowModal function from the hosting     *
//*                 application to see the form.                               *
//*             (6) Free the AboutForm varible,                                *
//*                   e.g. FAbout.Free;                                        *
//*                 in the FormDestroy event of the hosting application.       *
//*                                                                            *
//* Author:     Ron Maupin                                                     *
//*                                                                            *
//* Copyright:  (c) 2021 by Ron Maupin                                         *
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

unit About;

interface

uses
  System.Classes, System.SysUtils,
  Vcl.BaseImageCollection, Vcl.Controls, Vcl.Forms, Vcl.ImageCollection, Vcl.StdCtrls, Vcl.VirtualImage,
  Winapi.Windows;

type
  TAboutForm = class(TForm)
    AboutImage: TVirtualImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  public
    CompanyName: string;
    FileDescription: string;
    FileVersion: string;
    InternalName: string;
    LegalCopyright: string;
    LegalTrademarks: string;
    OriginalFilename: string;
    ProductName: string;
    ProductVersion: string;
    Comments: string;
  end;

var
  AboutForm: TAboutForm;

implementation {$R *.dfm}

type
  TLanguage = record
    Language: WORD;
    CodePage: WORD;
  end;
  PLanguage = ^TLanguage;

procedure TAboutForm.FormCreate(Sender: TObject);
var
  Handle: DWORD;
  VerSize: DWORD;
  VerInfo: Pointer;
  Trans: PLanguage;
  Size: DWORD;
  Lang: string;
  Buffer: PChar;
begin
  Handle := 0;
  VerSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Handle);
  if VerSize > 0 then begin
    GetMem(VerInfo, VerSize);
    if GetFileVersionInfo(PChar(ParamStr(0)), 0, VerSize, VerInfo) and VerQueryValue(VerInfo, '\VarFileInfo\Translation', Pointer(Trans), Size) then try
      Lang := IntToHex(Trans^.Language, 4) + IntToHex(Trans^.CodePage, 4);
      if VerQueryValue(VerInfo, PChar('\StringFileInfo\' + Lang + '\CompanyName'     ), Pointer(Buffer), Size) then CompanyName      := Buffer else CompanyName      := '';
      if VerQueryValue(VerInfo, PChar('\StringFileInfo\' + Lang + '\FileDescription' ), Pointer(Buffer), Size) then FileDescription  := Buffer else FileDescription  := '';
      if VerQueryValue(VerInfo, PChar('\StringFileInfo\' + Lang + '\FileVersion'     ), Pointer(Buffer), Size) then FileVersion      := Buffer else FileVersion      := '';
      if VerQueryValue(VerInfo, PChar('\StringFileInfo\' + Lang + '\InternalName'    ), Pointer(Buffer), Size) then InternalName     := Buffer else InternalName     := '';
      if VerQueryValue(VerInfo, PChar('\StringFileInfo\' + Lang + '\LegalCopyright'  ), Pointer(Buffer), Size) then LegalCopyright   := Buffer else LegalCopyright   := '';
      if VerQueryValue(VerInfo, PChar('\StringFileInfo\' + Lang + '\LegalTrademarks' ), Pointer(Buffer), Size) then LegalTrademarks  := Buffer else LegalTrademarks  := '';
      if VerQueryValue(VerInfo, PChar('\StringFileInfo\' + Lang + '\OriginalFilename'), Pointer(Buffer), Size) then OriginalFilename := Buffer else OriginalFilename := '';
      if VerQueryValue(VerInfo, PChar('\StringFileInfo\' + Lang + '\ProductName'     ), Pointer(Buffer), Size) then ProductName      := Buffer else ProductName      := '';
      if VerQueryValue(VerInfo, PChar('\StringFileInfo\' + Lang + '\ProductVersion'  ), Pointer(Buffer), Size) then ProductVersion   := Buffer else ProductVersion   := '';
      if VerQueryValue(VerInfo, PChar('\StringFileInfo\' + Lang + '\Comments'        ), Pointer(Buffer), Size) then Comments         := Buffer else Comments         := '';
    finally
      FreeMem(VerInfo);
    end;
  end;
  Caption        := 'About ' + ProductName;
  Label1.Caption := ProductName;
  Label2.Caption := 'Release ' + ProductVersion;
  Label3.Caption := LegalCopyright;
end;

procedure TAboutForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caHide;
end;

end.
