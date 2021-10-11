unit UnitMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdActns, Menus, StdCtrls, ComCtrls, ExtCtrls, Mask,
  UnitThreadSniffer, UnitPileTrame, UnitGlobal;

type
  TMainForm = class(TForm)
    PanelBottom: TPanel;
    Btn_StartStop: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Touslesports: TRadioButton;
    PortStartPortEnd: TRadioButton;
    UpDown1: TUpDown;
    Label2: TLabel;
    UpDown2: TUpDown;
    TimerInData: TTimer;
    StartPort: TEdit;
    EndPort: TEdit;
    EditIp: TEdit;
    GroupBox2: TGroupBox;
    VoirDate: TCheckBox;
    VoirIpPort: TCheckBox;
    VoirDrapeaux: TCheckBox;
    GroupBox3: TGroupBox;
    FiltreURG: TCheckBox;
    Ecr: TRichEdit;
    FiltreACK: TCheckBox;
    FiltrePSH: TCheckBox;
    FiltreRST: TCheckBox;
    FiltreSYN: TCheckBox;
    FiltreFIN: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Btn_StartStopClick(Sender: TObject);
    procedure TimerInDataTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure StartPortKeyPress(Sender: TObject; var Key: Char);
    procedure TouslesportsClick(Sender: TObject);
    procedure PortStartPortEndClick(Sender: TObject);

  private
    { Déclarations privées }
    FPileTrameTcp : TPileTrameTCP;
    FStart: Boolean;
    FThreadSniffer: TThreadSniffer;
    procedure SetStart(value: boolean);
    function  GetMyIP: String;
    function  VisuStr(const str: string; NbCar: integer):string;

  public
    { Déclarations publiques }
    property Start: Boolean read Fstart write SetStart;
  end;

var
  MainForm: TMainForm;

implementation


{$R *.dfm}

uses winsock2, StrUtils;


procedure TMainForm.FormCreate(Sender: TObject);
begin
  FPileTrameTCP:= TPileTrameTCP.Create;
  FStart:= true;
  Start:= False;
  EditIp.Text := GetMyIp;
end;
procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FPileTrameTcp.Free;
end;

procedure TMainForm.SetStart(value: boolean);
begin
  if FStart<>value then
  begin
    FStart:= value;
    if not FStart then
    begin
      Btn_StartStop.Caption:= 'Start';
      Btn_StartStop.Enabled := true;
    end
    else
    begin
      Ecr.Color:= clblack;
      Ecr.Font.Color:= clwhite;
      Btn_StartStop.Caption:= 'Stop';
    end;
    TimerInData.Enabled := FStart;
  end;
end;


//==============================================================================
// Bouton activation de la trace TCP
//==============================================================================
procedure TMainForm.Btn_StartStopClick(Sender: TObject);
begin
  Start:= not Start;
  if Start then
  begin
    if TousLesPorts.Checked then
      FThreadSniffer:= TThreadSniffer.Create(FPileTrameTCP,EditIP.Text,$1,$FFFF)
    else
      FThreadSniffer:= TThreadSniffer.Create(FPileTrameTCP,EditIP.Text,strtoint(StartPort.Text),
                                             strtoint(EndPort.Text));

  end
  else FThreadSniffer.Terminate;

end;

//==============================================================================
// Formatage chaine de caractère pour visu confortable
//==============================================================================
function TMainForm.VisuStr(const str: string; NbCar: integer):string;
begin
  result:= str;
  if length(result)<NbCar then result:= DupeString(' ', Nbcar-Length(result))+result;
end;


//==============================================================================
// On Timer
//==============================================================================
procedure TMainForm.TimerInDataTimer(Sender: TObject);
var
  TrameTcp    : PTrameTCP;
  Str         : string;
  StrDate     : string;
  StrIp       : string;
  StrDrapeaux : string;
  FiltreOk    : boolean;
begin
  // Tant que la pile des messages TCP n'est pas vide
  while FPileTrameTCP.Count > 0 do
  begin
    // On récupère le message TCP formaté par nos soins
    TrameTcp:= FPileTrameTCP.Pop;
    // Si messsage existe !!! en principe n'est jamais a nil
    if TrameTcp<>nil then
    begin
      StrDrapeaux:= '';
      FiltreOk:= false;

      // Construction chaine drapeaux TCP pour affichage
      // et teste filtre par la meme occasion

      // URG
      if drp_URG in TrameTcp^.EtatDrapeaux then
      begin
        StrDrapeaux:= StrDrapeaux + 'URG ';
        FiltreOk:= FiltreOk or FiltreUrg.Checked;
      end
      else StrDrapeaux:= StrDrapeaux + '    ';
      // ACK
      if drp_ACK in TrameTcp^.EtatDrapeaux then
      begin
        StrDrapeaux:= StrDrapeaux + 'ACK ';
        FiltreOk:= FiltreOk or FiltreACK.Checked;
      end
      else StrDrapeaux:= StrDrapeaux + '    ';
      // PSH
      if drp_PSH in TrameTcp^.EtatDrapeaux then
      begin
        StrDrapeaux:= StrDrapeaux + 'PSH ';
        FiltreOk:= FiltreOk or FiltrePSH.Checked;
      end
      else StrDrapeaux:= StrDrapeaux + '    ';
      // RST
      if drp_RST in TrameTcp^.EtatDrapeaux then
      begin
        StrDrapeaux:= StrDrapeaux + 'RST ';
        FiltreOk:= FiltreOk or FiltreRST.Checked;
      end
      else StrDrapeaux:= StrDrapeaux + '    ';
      // SYN
      if drp_SYN in TrameTcp^.EtatDrapeaux then
      begin
        StrDrapeaux:= StrDrapeaux + 'SYN ';
        FiltreOk:= FiltreOk or FiltreSYN.Checked;
      end
      else StrDrapeaux:= StrDrapeaux + '    ';
      // FIN
      if drp_FIN in TrameTcp^.EtatDrapeaux then
      begin
        StrDrapeaux:= StrDrapeaux + 'FIN ';
        FiltreOk:= FiltreOk or FiltreFIN.Checked;
      end
      else StrDrapeaux:= StrDrapeaux + '    ';

      // Si Filtre sur drapeaux TCP est actif on construit le reste
      if FiltreOk then
      begin
        // Construction chaine finale visu
        str:= TrameTcp^.Data;

        // cr lf pour affichage
        if length(str)>1 then
          if copy(Str,length(Str)-1,2)=#13#10 then
            str:= copy(Str,1, length(Str)-2);
        // Formate date time
        if VoirDate.Checked
          then StrDate:= FormatDateTime('dd/mm/yyyy hh:mm:ss ', TrameTcp^.TimeStamp)
          else StrDate:='';
        // Formate ip et port
        if VoirIpPort.Checked then
        begin
          StrIp  := Format('%s:%d => %s:%d ',[VisuStr(TrameTcp^.Source.Ip,15),
                                              TrameTcp^.Source.Port,
                                              VisuStr(TrameTcp^.Destination.Ip,15),
                                              TrameTcp^.Destination.Port]);
        end
        else StrIp:='';

        // Formate Drapeaux TCP
        if not VoirDrapeaux.Checked then StrDrapeaux:= '';

        // Création chaine finale et visu
        Str:= format('%s%s%s%s',[StrDate,StrIp,StrDrapeaux,Str]);
        if str<>'' then Ecr.Lines.Add(Str);
      end;
       // On détruit notre enregistrement trame TCP
       Dispose(TrameTcp);
    end;
  end;
end;



//==============================================================================
// N'autorise que les chiffres pour saisie des numéro de port
//==============================================================================
procedure TMainForm.StartPortKeyPress(Sender: TObject; var Key: Char);
begin
  // Traite backspace
  if Key=#8 then exit;
  // Autres touches
  if (Key<'0') or (Key >'9') then Key:= #0;
end;

//==============================================================================
// Sélectionne tous les ports
//==============================================================================
procedure TMainForm.TouslesportsClick(Sender: TObject);
begin
  StartPort.Enabled := false;
  EndPort.Enabled   := false;
end;

//==============================================================================
// Sélectionne plage de ports
//==============================================================================
procedure TMainForm.PortStartPortEndClick(Sender: TObject);
begin
  StartPort.Enabled := true;
  EndPort.Enabled   := true;
end;

//==============================================================================
// Récupère son Ip locale
//==============================================================================
function TMainForm.GetMyIP: String;
type
   TaPInAddr = Array[0..10] of PInAddr;
   PaPInAddr = ^TaPInAddr;
var
   phe: PHostEnt;
   pptr: PaPInAddr;
   Buffer: Array[0..63] of Char;
   I: Integer;
   GInitData: TWSAData;
begin
   WSAStartup($101, GInitData);
   Result := '';
   GetHostName(Buffer, SizeOf(Buffer));
   phe := GetHostByName(buffer);
   if phe = nil then Exit;
   pPtr := PaPInAddr(phe^.h_addr_list);
   I := 0;
   while pPtr^[I] <> nil do
   begin
      Result := inet_ntoa(pptr^[I]^);
      Inc(I);
   end;
   WSACleanup;
end;

end.
