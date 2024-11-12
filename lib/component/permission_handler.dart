
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {

  init() async {
    List<Permission> initPermissions = [Permission.notification];
    for (var permission in initPermissions) {
      await _permissionStatus(permission);
    }
  }


  Future<PermissionStatus> _permissionStatus(Permission permission) async {
    final status = await permission.status;
    if (status.isDenied && !await permission.isPermanentlyDenied) {
      return await permission.request();
    }
    return status;
  }
}