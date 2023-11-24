object AboutForm: TAboutForm
  Left = 0
  Top = 0
  HorzScrollBar.Visible = False
  AutoSize = True
  BorderStyle = bsDialog
  Caption = 'About {Product Name}'
  ClientHeight = 479
  ClientWidth = 688
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -17
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
  PixelsPerInch = 144
  TextHeight = 23
  object Label4: TLabel
    AlignWithMargins = True
    Left = 8
    Top = 120
    Width = 672
    Height = 295
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
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
    Font.Height = -17
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
    Left = 152
    Top = 3
    Width = 221
    Height = 40
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 9
    Margins.Bottom = 5
    Caption = '{Product Name}'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -29
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    Font.Quality = fqClearTypeNatural
    ParentFont = False
    ShowAccelChar = False
    StyleElements = []
  end
  object Label2: TLabel
    AlignWithMargins = True
    Left = 152
    Top = 45
    Width = 198
    Height = 25
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 9
    Margins.Bottom = 5
    Caption = 'Release {Product Version}'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -18
    Font.Name = 'Segoe UI'
    Font.Style = []
    Font.Quality = fqClearTypeNatural
    ParentFont = False
    StyleElements = []
  end
  object Label3: TLabel
    AlignWithMargins = True
    Left = 152
    Top = 75
    Width = 135
    Height = 25
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = '{Legal Copyright}'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -18
    Font.Name = 'Segoe UI'
    Font.Style = []
    Font.Quality = fqClearTypeNatural
    ParentFont = False
    StyleElements = []
  end
  object AboutImage: TVirtualImage
    Left = 8
    Top = 3
    Width = 96
    Height = 96
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 48
    Margins.Bottom = 48
    ImageWidth = 0
    ImageHeight = 0
    ImageIndex = 0
  end
  object Button1: TButton
    AlignWithMargins = True
    Left = 286
    Top = 429
    Width = 114
    Height = 38
    Margins.Left = 174
    Margins.Top = 9
    Margins.Right = 174
    Margins.Bottom = 9
    Caption = 'OK'
    Constraints.MaxHeight = 38
    Constraints.MaxWidth = 123
    Constraints.MinHeight = 38
    Constraints.MinWidth = 114
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = []
    Font.Quality = fqClearTypeNatural
    ModalResult = 1
    ParentFont = False
    TabOrder = 0
    StyleElements = []
  end
end
