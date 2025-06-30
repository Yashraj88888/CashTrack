import 'package:permission_handler/permission_handler.dart';

Future<void> requestSmsPermission() async {
  if (!await Permission.sms.isGranted) {
    await Permission.sms.request();
  }
}
