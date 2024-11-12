
import 'package:groundjp/exception/server/server_exception.dart';
import 'package:groundjp/exception/socket_exception_os_code.dart';

class InternalSocketException extends ServerException {

  final SocketOSCode errno;

  InternalSocketException(this.errno) : super(errno.getMessage());

}