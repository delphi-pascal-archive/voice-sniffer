object MainForm: TMainForm
  Left = 235
  Top = 126
  Width = 948
  Height = 712
  Caption = 'Voice Sniffer v2.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 17
  object PanelBottom: TPanel
    Left = 0
    Top = 553
    Width = 940
    Height = 131
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      940
      131)
    object Btn_StartStop: TButton
      Left = 758
      Top = 79
      Width = 174
      Height = 44
      Caption = 'Btn_StartStop'
      TabOrder = 0
      OnClick = Btn_StartStopClick
    end
    object GroupBox1: TGroupBox
      Left = 10
      Top = 13
      Width = 1143
      Height = 59
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = ' Trace TCP '
      TabOrder = 1
      object Label1: TLabel
        Left = 7
        Top = 21
        Width = 157
        Height = 17
        Caption = 'Adressse IP carte reseau :'
      end
      object Label2: TLabel
        Left = 642
        Top = 22
        Width = 22
        Height = 17
        AutoSize = False
        Caption = 'a'
      end
      object Touslesports: TRadioButton
        Left = 354
        Top = 21
        Width = 118
        Height = 22
        Caption = 'Tous les ports'
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = TouslesportsClick
      end
      object PortStartPortEnd: TRadioButton
        Left = 475
        Top = 21
        Width = 53
        Height = 22
        Caption = 'De'
        TabOrder = 1
        OnClick = PortStartPortEndClick
      end
      object UpDown1: TUpDown
        Left = 608
        Top = 17
        Width = 21
        Height = 25
        Associate = StartPort
        TabOrder = 2
      end
      object UpDown2: TUpDown
        Left = 749
        Top = 18
        Width = 21
        Height = 25
        Associate = EndPort
        TabOrder = 3
      end
      object StartPort: TEdit
        Left = 523
        Top = 17
        Width = 85
        Height = 25
        TabOrder = 4
        Text = '0'
        OnKeyPress = StartPortKeyPress
      end
      object EndPort: TEdit
        Left = 670
        Top = 18
        Width = 79
        Height = 25
        TabOrder = 5
        Text = '0'
        OnKeyPress = StartPortKeyPress
      end
      object EditIp: TEdit
        Left = 180
        Top = 18
        Width = 159
        Height = 25
        TabOrder = 6
        Text = 'EditIp'
      end
    end
    object GroupBox2: TGroupBox
      Left = 10
      Top = 73
      Width = 326
      Height = 51
      Caption = ' Voir '
      TabOrder = 2
      object VoirDate: TCheckBox
        Left = 10
        Top = 21
        Width = 127
        Height = 22
        Caption = 'Date'
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
      object VoirIpPort: TCheckBox
        Left = 81
        Top = 21
        Width = 96
        Height = 22
        Caption = 'IP et Ports'
        Checked = True
        State = cbChecked
        TabOrder = 1
      end
      object VoirDrapeaux: TCheckBox
        Left = 194
        Top = 21
        Width = 126
        Height = 22
        Caption = 'Drapeaux TCP'
        Checked = True
        State = cbChecked
        TabOrder = 2
      end
    end
    object GroupBox3: TGroupBox
      Left = 343
      Top = 73
      Width = 404
      Height = 51
      Caption = ' Filtre Drapeaux TCP '
      TabOrder = 3
      object FiltreURG: TCheckBox
        Left = 10
        Top = 21
        Width = 65
        Height = 22
        Caption = 'URG'
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
      object FiltreACK: TCheckBox
        Left = 73
        Top = 21
        Width = 64
        Height = 22
        Caption = 'ACK'
        Checked = True
        State = cbChecked
        TabOrder = 1
      end
      object FiltrePSH: TCheckBox
        Left = 137
        Top = 21
        Width = 64
        Height = 22
        Caption = 'PSH'
        Checked = True
        State = cbChecked
        TabOrder = 2
      end
      object FiltreRST: TCheckBox
        Left = 201
        Top = 21
        Width = 64
        Height = 22
        Caption = 'RST'
        Checked = True
        State = cbChecked
        TabOrder = 3
      end
      object FiltreSYN: TCheckBox
        Left = 265
        Top = 21
        Width = 65
        Height = 22
        Caption = 'SYN'
        Checked = True
        State = cbChecked
        TabOrder = 4
      end
      object FiltreFIN: TCheckBox
        Left = 330
        Top = 21
        Width = 64
        Height = 22
        Caption = 'FIN'
        Checked = True
        State = cbChecked
        TabOrder = 5
      end
    end
  end
  object Ecr: TRichEdit
    Left = 0
    Top = 0
    Width = 940
    Height = 553
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
    WordWrap = False
  end
  object TimerInData: TTimer
    Enabled = False
    Interval = 500
    OnTimer = TimerInDataTimer
    Left = 176
    Top = 270
  end
end
