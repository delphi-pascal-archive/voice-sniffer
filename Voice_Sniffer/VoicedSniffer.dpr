//==============================================================================
// Projet: Sniffeur de réseau
// Version : 2.0  le 16/07/2009
// Auteur Pierre Freby alias VoicedMirror pfreby@hotmail.com
//==============================================================================
program VoicedSniffer;

uses
  Forms,
  UnitMain in 'UnitMain.pas' {MainForm},
  UnitThreadSniffer in 'UnitThreadSniffer.pas',
  UWinsockErreurs in 'UWinsockErreurs.pas',
  WinSock2 in 'WinSock2.pas',
  UnitPileTrame in 'UnitPileTrame.pas',
  UnitGlobal in 'UnitGlobal.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Sniffeur TCP';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
