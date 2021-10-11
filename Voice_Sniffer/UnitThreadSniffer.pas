unit UnitThreadSniffer;

interface

uses
  Classes,Windows,SysUtils,
  UWinsockErreurs,
  UnitGlobal, UnitPileTrame;
type
  TThreadSniffer = class(TThread)
  private
    FIp        : string;
    FStartPort : word;
    FEndPort   : word;
    FDrapeaux  : set of TDrapeaux;
    FPileTrameTcp : TPileTrameTcp;
    procedure SendErreur(Code: word);
  protected
    procedure Execute; override;
  public
    constructor Create(PileTrameTcp: TPileTrameTcp; Ip: string; aStartPort,aEndPort: Word);
  end;
  ESockError = class(Exception);

var
  ThreadSniffer: TThreadSniffer;

implementation

uses WinSock2;




procedure TThreadSniffer.SendErreur(Code: word);
begin
end;



constructor TThreadSniffer.Create(PileTrameTcp: TPileTrameTcp; Ip: string; aStartPort,aEndPort: Word);
begin
  inherited create(True);
  FPileTrameTcp:= PileTrameTcp;
  FIp:= Ip;
  FStartPort:= aStartPort;
  FEndPort:= aEndPort;
  FreeOnTerminate:= true;
  resume;
end;


procedure TThreadSniffer.Execute;
const
  MAX_BUFFER = $FFFF;
var
  PortSource      : word;
  PortDestination : word;
  Drap            : set of TDrapeaux;
  Sock            : TSocket;
  SockAdr         : TSockAddrIn;
  buffer          : Array[0..MAX_BUFFER] of char;
  BufferInlen     :dword;
  byteret         : dword;
  info            : TWSAData ;
  Sio             : dword;
  bufTcp          : Pchar;
  TrameTCP        : PTrameTCP;

(*
+--------+--------+----------------+--------------------------------+
| version|longueur| type de service|  longueur totale sur 16 bits   |
| 4 bits | 4 bits | (TOS) 8 bits   |               (en octets)      |
+--------+--------+----------------+------+-------------------------+
|       identification             |3 bits| 13 bits fragment offset |
|                                  |flags |                         |
+-----------------+----------------+------+-------------------------+
| durée de vie    |  protocole     |  somme de contrôle d'en tête   |
| (TTL) 8 bits    |    8 bits      |              (16 bits)         |
+-----------------+----------------+--------------------------------+
|                adresse IP source sur 32 bits                      |
|                                                                   |
+-------------------------------------------------------------------+
|                adresse IP destination sur 32 bits                 |
|                                                                   |
+-------------------------------------------------------------------+
|                                                                   |
/                     options (s'il y en a)                         /
/                         données                                   /
|                                                                   |
+-------------------------------------------------------------------+
*)
begin
  BufferInLen:=TH_NETDEV; //TH_TAPI
  ByteRet:= 0;

  // Initialise Winsock sortie si erreur
  if WSAStartup(MakeWord(2,2),info)<>0 then
  begin
    // Traite erreur
    SendErreur(WSAGetLastError);
    // sortie du thread
    exit;
  end;


  try
    // Initialise structure socket en mode raw
    Sock := Socket(AF_INET, SOCK_RAW,IPPROTO_IP);
    SockAdr.sin_addr.S_addr := inet_addr(pchar(FIp));
    SockAdr.sin_family := AF_INET;
    SockAdr.sin_port := 0;

    // Mise du socket en mode écoute sortie si erreur
    if bind(Sock,@SockAdr,Sizeof(SockAdr))<>0 then
    begin
      // Traite erreur
      SendErreur(WSAGetLastError);
      // Libère libaririe Winsock
      WSACleanUp;
      // sortie du thread
      exit;
    end ;

    // Mise de la connexion en mode association
    // sortie si erreur
    SIO:=  SIO_ASSOCIATE_HANDLE or IOC_VENDOR;
    if WSAIoctl(Sock,SIO,@BufferInLen,Sizeof(BufferInLen),
                nil,0,@byteret,nil,nil) <> 0 then
    begin
      // Traite erreur
      SendErreur(WSAGetLastError);
      // ferme socket
      closesocket(Sock) ;
      // Libère libaririe Winsock
      WSACleanUp;
      // sortie du thread
      exit;
    end;

    // Boucle du Thread d'acquisition
    while not Terminated do
    begin

      // Si erreur lecture sortie du thread
      if recv(Sock,buffer,MAX_BUFFER,0)<0 then
      begin
        // Traite erreur
        SendErreur(WSAGetLastError);
       // ferme socket
        closesocket(Sock) ;
        // Libère libaririe Winsock
        WSACleanUp;
         // sortie du thread
        exit;
      end;


      // Récupère Trame du protocole
      buftcp:=  @Buffer[(byte(Buffer[0]) and $0F)*4];

      // Traitement trame suivant type de protocole IP
      // On ne traite pour l'instant que le protocole TCP
      case byte(Buffer[9]) of
        IPPROTO_IP:;             { dummy for IP }
        IPPROTO_ICMP:;           { control message protocol }
        IPPROTO_IGMP:;           { group management protocol }
        IPPROTO_GGP:;            { gateway^2 (deprecated) }

        // TRAITEMENT DU PROTOCOLE TCP =========================================
        IPPROTO_TCP:
        begin
          // Récupère ports source et destination
          PortSource:= 256*byte(buftcp[0])+byte(buftcp[1]);
          PortDestination:= 256*byte(buftcp[2])+byte(buftcp[3]);
          // Si on est dans la capture des ports demandés
          if ((PortSource>= FStartPort) and (PortSource<= FEndPort)) or
             ((PortDestination>= FStartPort) and (PortDestination<= FEndPort)) then
          begin
            // Récupère DRAPEAUX TCP
            Drap:= [];
            if (byte(buftcp[13]) and 32)=32 then Drap:= Drap + [drp_URG];
            if (byte(buftcp[13]) and 16)=16 then Drap:= Drap + [drp_ACK];
            if (byte(buftcp[13]) and 08)=08 then Drap:= Drap + [drp_PSH];
            if (byte(buftcp[13]) and 04)=04 then Drap:= Drap + [drp_RST];
            if (byte(buftcp[13]) and 02)=02 then Drap:= Drap + [drp_SYN];
            if (byte(buftcp[13]) and 01)=01 then Drap:= Drap + [drp_FIN];
            // Si on est dans la capture des drapeaux demandés
            if true then // FDrapeaux = Drap then
            begin
              // Création de notre enregistement propre à TCP
              new(TrameTCP);
              with TrameTCP^ do
              try
                // Date time de la trame
                TimeStamp:= now;
                // Source et destination de la connexion
                Source.Ip:= inttostr(ord(Buffer[12]))+'.'+
                            inttostr(ord(Buffer[13]))+'.'+
                            inttostr(ord(Buffer[14]))+'.'+
                            inttostr(ord(Buffer[15]));
                Source.Port:= PortSource;
                Destination.Ip:= inttostr(ord(Buffer[16]))+'.'+
                                 inttostr(ord(Buffer[17]))+'.'+
                                 inttostr(ord(Buffer[18]))+'.'+
                                inttostr(ord(Buffer[19]));
                Destination.Port:= PortDestination;

                // Drapeaux
                EtatDrapeaux:= Drap;
                // Données
                Buffer[256*byte(Buffer[2])+byte(Buffer[3])]:=#0;
                data := string(pchar(@buftcp[((byte(BufTcp[12]) and $F0)shr 4)*4]));
                // On mémorise notre message TCP dans la liste
                FPileTrameTcp.Push(TrameTcp);
              // GROS PROBLEME LA IL FAUT DEBUG !!! :)
              except
                Dispose(TrameTCP);
              end;
            end;
          end;
        end;
        IPPROTO_PUP:;            { pup }
        IPPROTO_UDP:;            { user datagram protocol }
        IPPROTO_IDP:;            { xns idp }
        IPPROTO_ND:;             { UNOFFICIAL net disk proto }
        IPPROTO_RAW:;            { raw IP packet }
      end;
    end;
  finally
    // ferme socket
    closesocket(Sock) ;
    // Libère libaririe Winsock
    WSACleanUp;
  end;
end;

end.
