unit UWinsockErreurs;

interface

uses
 Winsock,SysUtils ;

function WinsockErreur(ErrCode: Integer) : String ;


implementation


function WinsockErreur(ErrCode: Integer) : String ;
begin
 Case ErrCode of
  WSAEACCES          : result := 'WSAEACCES : The requested address is a broadcast address, but the appropriate flag was not set.' ;
  WSAEADDRINUSE      : result := 'WSAEADDRINUSE : The specified address is already in use.' ;
  WSAEADDRNOTAVAIL   : result := 'WSAEADDRNOTAVAIL : The specified address is not available from the local machine.' ;
  WSAEAFNOSUPPORT    : result := 'WSAEAFNOSUPPORT : The specified address family is not supported.' ;
  WSAEALREADY        : result := 'WSAEALREADY : A nonblocking connect call is in progress on the specified socket.' ;
  WSAECONNABORTED    : result := 'WSAECONNABORTED : The virtual circuit was terminated due to a time-out or other failure. The application should close the socket as it is no longer usable.' ;
  WSAECONNREFUSED    : result := 'WSAECONNREFUSED : The attempt to connect was forcefully rejected.' ;
  WSAECONNRESET      : result := 'WSAECONNRESET : The virtual circuit was reset by the remote side executing a "hard" or "abortive" close. For UPD sockets, the remote host was unable to deliver a previously sent UDP datagram and ... ' ;
  WSAEFAULT          : result := 'WSAEFAULT : The buf argument is not totally contained in a valid part of the user address space.' ;
  WSAEHOSTUNREACH    : result := 'WSAEHOSTUNREACH : The remote host cannot be reached from this host at this time.' ;
  WSAEINPROGRESS     : result := 'WSAEINPROGRESS : A blocking Windows Sockets 1.1 call is in progress, or the service provider is still processing a callback function.' ;
  WSAEINTR           : result := 'WSAEINTR : The (blocking) call was canceled through WSACancelBlockingCall.' ;
  WSAEINVAL          : result := 'WSAEINVAL : The socket has not been bound with bind, or an unknown flag was specified, or MSG_OOB was specified for a socket with SO_OOBINLINE enabled.' ;
  WSAEISCONN         : result := 'WSAEISCONN : The socket is already connected (connection-oriented sockets only).' ;
  WSAEMFILE          : result := 'WSAEMFILE : No more socket descriptors are available.' ;
  WSAEMSGSIZE        : result := 'WSAEMSGSIZE : The socket is message oriented, and the message is larger than the maximum supported by the underlying transport.' ;
  WSAENETDOWN        : result := 'WSAENETDOWN : The network subsystem has failed.' ;
  WSAENETUNREACH     : result := 'WSAENETUNREACH : The network cannot be reached from this host at this time.' ;
  WSAENETRESET       : result := 'WSAENETRESET : The connection has been broken due to the remote host resetting.' ;
  WSAENOBUFS         : result := 'WSAENOBUFS : No buffer space is available. The socket cannot be created.' ;
  WSAENOTCONN        : result := 'WSAENOTCONN : The socket is not connected.' ;
  WSAENOTSOCK        : result := 'WSAENOTSOCK : The descriptor is not a socket.' ;
  WSAEOPNOTSUPP      : result := 'WSAEOPNOTSUPP : MSG_OOB was specified, but the socket is not stream style such as type SOCK_STREAM, out-of-band data is not supported in the communication domain associated with this socket, or ... ' ;
  WSAEPROCLIM        : result := 'WSAEPROCLIM : Limit on the number of tasks supported by the Windows Sockets implementation has been reached.' ;
  WSAEPROTONOSUPPORT : result := 'WSAEPROTONOSUPPORT : The specified protocol is not supported.' ;
  WSAEPROTOTYPE      : result := 'WSAEPROTOTYPE : The specified protocol is the wrong type for this socket.' ;
  WSAESHUTDOWN       : result := 'WSAESHUTDOWN : The socket has been shut down; it is not possible to send on a socket after shutdown has been invoked with how set to SD_SEND or SD_BOTH.' ;
  WSAESOCKTNOSUPPORT : result := 'WSAESOCKTNOSUPPORT : The specified socket type is not supported in this address family.' ;
  WSAETIMEDOUT       : result := 'WSAETIMEDOUT : The connection has been dropped, because of a network failure or because the system on the other end went down without notice.' ;
  WSAEWOULDBLOCK     : result := 'WSAEWOULDBLOCK : The socket is marked as nonblocking and the requested operation would block.' ;
  WSAHOST_NOT_FOUND  : result := 'WSAHOST_NOT_FOUND : Authoritative Answer Host not found.' ;
  WSANO_DATA         : result := 'WSANO_DATA : Valid name, no data record of requested type.' ;
  WSANO_RECOVERY     : result := 'WSANO_RECOVERY : Nonrecoverable error occurred.' ;
  WSANOTINITIALISED  : result := 'WSANOTINITIALISED : A successful WSAStartup must occur before using this function.' ;
  WSATRY_AGAIN       : result := 'WSATRY_AGAIN : Non-Authoritative Host not found, or server failure.' ;
  else result := 'Erreur inconnue (' + IntToStr(ErrCode) + ')' ;
 end ;
end ;

end.

