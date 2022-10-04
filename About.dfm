object AboutForm: TAboutForm
  Left = 0
  Top = 0
  HorzScrollBar.Visible = False
  AutoSize = True
  BorderStyle = bsDialog
  Caption = 'About {Product Name}'
  ClientHeight = 321
  ClientWidth = 460
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  Font.Quality = fqClearTypeNatural
  Padding.Left = 3
  Padding.Top = 3
  Padding.Right = 3
  Padding.Bottom = 3
  Position = poOwnerFormCenter
  StyleElements = []
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label4: TLabel
    AlignWithMargins = True
    Left = 6
    Top = 93
    Width = 448
    Height = 185
    AutoSize = False
    Caption = 
      'DISCLAIMER:'#13#13'THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ' +
      '"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NO' +
      'T LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITN' +
      'ESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL T' +
      'HE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, IND' +
      'IRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES ' +
      '(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS ' +
      'OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUP' +
      'TION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN ' +
      'CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTH' +
      'ERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN' +
      ' IF ADVISED OF THE POSSIBILITY  OF SUCH DAMAGE.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 6446426
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = []
    Font.Quality = fqClearTypeNatural
    ParentFont = False
    Transparent = True
    WordWrap = True
    StyleElements = []
  end
  object Label1: TLabel
    AlignWithMargins = True
    Left = 102
    Top = 3
    Width = 143
    Height = 25
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 6
    Caption = '{Product Name}'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    Font.Quality = fqClearTypeNatural
    ParentFont = False
    ShowAccelChar = False
    StyleElements = []
  end
  object Label2: TLabel
    AlignWithMargins = True
    Left = 102
    Top = 31
    Width = 133
    Height = 15
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 6
    Caption = 'Release {Product Version}'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Font.Quality = fqClearTypeNatural
    ParentFont = False
    StyleElements = []
  end
  object Label3: TLabel
    AlignWithMargins = True
    Left = 102
    Top = 51
    Width = 92
    Height = 15
    Caption = '{Legal Copyright}'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Font.Quality = fqClearTypeNatural
    ParentFont = False
    StyleElements = []
  end
  object AboutImage: TVirtualImage
    Left = 6
    Top = 3
    Width = 64
    Height = 64
    Margins.Right = 32
    Margins.Bottom = 32
    ImageWidth = 0
    ImageHeight = 0
    ImageIndex = 0
  end
  object Button1: TButton
    AlignWithMargins = True
    Left = 191
    Top = 287
    Width = 76
    Height = 25
    Margins.Left = 116
    Margins.Top = 6
    Margins.Right = 116
    Margins.Bottom = 6
    Caption = 'OK'
    Constraints.MaxHeight = 25
    Constraints.MaxWidth = 82
    Constraints.MinHeight = 25
    Constraints.MinWidth = 76
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Font.Quality = fqClearTypeNatural
    ModalResult = 1
    ParentFont = False
    TabOrder = 0
    StyleElements = []
  end
end
