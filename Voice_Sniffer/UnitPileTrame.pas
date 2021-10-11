unit UnitPileTrame;

interface

uses classes,
     UnitGlobal;

//==============================================================================
// Ancetre de base pour le stockage des Trames suivant le protocole
//==============================================================================
type
  TCustomPileTrame = class(TObject)
  protected
  private
    FMyList : TThreadList;
    function GetCount: Integer;
  public
    constructor Create;
    procedure   Push(Rec: Pointer);
    function    Pop:Pointer;
    property    Count: integer read GetCount;
  end;
//==============================================================================
// Objet pile des messages TCP
//==============================================================================
  TPileTrameTCP = class(TCustomPileTrame)
  protected
  private
  public
    destructor  Destroy; override;
    function    Pop:PTrameTCP;
  end;


  
implementation

//==============================================================================
{ TCustomPIleTrame }

constructor TCustomPileTrame.Create;
begin
  inherited create;
  FMyList:= TThreadList.Create;
  FMyList.Duplicates := dupAccept;
end;

function TCustomPileTrame.GetCount: Integer;
begin
  with FMyList.LockList do
  try
    result:= Count;
  finally
    FMyList.UnlockList;
  end;
end;

procedure TCustomPileTrame.Push(Rec: Pointer);
begin
  FMyList.Add(Rec);
end;

function TCustomPileTrame.Pop:Pointer;
begin
  result:= nil;
  with FMyList.LockList do
  try
    if Count>0 then
    begin
      result:= First;
      Delete(0);
    end;
  finally
    FMyList.UnlockList;
  end;
end;

//==============================================================================
{ TPileTrameTCP }

function TPileTrameTCP.Pop:PTrameTCP;
begin
  result:= inherited pop;
//  dispose(result);
end;

destructor TPileTrameTCP.Destroy;
begin
  with FMyList.LockList do
  try
    while Count<>0 do
      pop;
  finally
    FMyList.UnlockList;
  end;
end;


end.
