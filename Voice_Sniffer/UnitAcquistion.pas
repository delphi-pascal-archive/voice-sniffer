unit UnitAcquistion;

interface

uses
  Classes,SysUtils;

type
  TThreadSniffer = class(TThread)
  private
    FIp:   string;
    FPort: integer;
    FPortLocal: integer;
    FMsg:  string;
    ErrStr     : string;
    procedure StoreMsg;
    procedure Erreur;
  protected
    procedure Execute; override;
  public
    constructor Create(const Ip,Port : string);
    property    Port: integer write FPort;
  end;

implementation

constructor TThreadSniffer.Create(const Ip,Port : string);
begin
  inherited create(True);
  FIp:= Ip;
  FPort:= strtoint(Port);
  FreeOnTerminate:= true;
  resume;
end;

end.
