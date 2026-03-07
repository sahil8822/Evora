import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

class PermissionService {
  /// Request and handle all necessary app permissions
  static Future<void> requestAllPermissions() async {
    // List of permissions we configured in AndroidManifest/Info.plist
    final List<Permission> permissions = [
      Permission.locationWhenInUse,
      Permission.camera,
      Permission.photos,
      Permission.storage,
      Permission.notification,
    ];

    // Request permissions
    Map<Permission, PermissionStatus> statuses = await permissions.request();

    // Log the outcomes for debug builds
    if (kDebugMode) {
      statuses.forEach((permission, status) {
        debugPrint('Permission $permission: $status');
      });
    }
  }

  /// Specialized check for Location
  static Future<bool> checkLocationPermission() async {
    final status = await Permission.locationWhenInUse.status;
    return status.isGranted;
  }

  /// Specialized check for Gallery/Camera
  static Future<bool> checkMediaPermissions() async {
    final cameraStatus = await Permission.camera.status;
    final photoStatus = await Permission.photos.status;
    return cameraStatus.isGranted && photoStatus.isGranted;
  }

  /// Helpful method to open App Settings if permisions are permanently denied
  static Future<void> openSettings() async {
    await openAppSettings();
  }
}
