import 'package:permission_handler/permission_handler.dart';

Future<void> checkPermissions() async {
  final cameraStatus = await Permission.camera.request();
  final micStatus = await Permission.microphone.request();

  if (cameraStatus != PermissionStatus.granted ||
      micStatus != PermissionStatus.granted) {
    throw Exception('Camera or microphone permission denied');
  }
}
