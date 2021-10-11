unit UnitGlobal;

interface
type
  TDrapeaux = (drp_URG,drp_ACK,drp_PSH,drp_RST,drp_SYN,drp_FIN);
  TIpPort = record
    Ip   : string;
    Port : word;
  end;
  TTrameTCP = record
    TimeStamp    : TDateTime;
    Source       : TIpPort;
    Destination  : TIpPort;
    EtatDrapeaux : set of TDrapeaux;
    Data         : string;
  end;
  PTrameTCP = ^TTrameTCP;

implementation

end.
