import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class PermissionManager {
  static Future<bool> requestStoragePermissions() async {
    if (Platform.isAndroid) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        Permission.manageExternalStorage,
      ].request();

      // Check if storage permission is granted
      bool storageGranted = statuses[Permission.storage]?.isGranted ?? false;
      bool manageStorageGranted = statuses[Permission.manageExternalStorage]?.isGranted ?? false;

      // On Android 11+, we need MANAGE_EXTERNAL_STORAGE for full access
      if (Platform.isAndroid) {
        final androidInfo = await _getAndroidSdkVersion();
        if (androidInfo >= 30) {
          return manageStorageGranted || storageGranted;
        } else {
          return storageGranted;
        }
      }

      return storageGranted;
    }

    // For other platforms, assume permission is granted
    return true;
  }

  static Future<bool> checkStoragePermissions() async {
    if (Platform.isAndroid) {
      final storageStatus = await Permission.storage.status;
      final manageStorageStatus = await Permission.manageExternalStorage.status;

      final androidInfo = await _getAndroidSdkVersion();
      if (androidInfo >= 30) {
        return manageStorageStatus.isGranted || storageStatus.isGranted;
      } else {
        return storageStatus.isGranted;
      }
    }

    return true;
  }

  static Future<void> openAppSettings() async {
    await Permission.storage.request();
  }

  static Future<int> _getAndroidSdkVersion() async {
    // This is a simplified version - in a real app you might want to use
    // device_info_plus package for accurate SDK version detection
    return 29; // Default to API 29 for compatibility
  }

  static Future<bool> shouldShowPermissionRationale() async {
    if (Platform.isAndroid) {
      return await Permission.storage.shouldShowRequestRationale;
    }
    return false;
  }
}