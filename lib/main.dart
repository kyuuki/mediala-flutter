import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mediala/service/notification_service.dart';

import 'my_app.dart';

/// The name associated with the UI isolate's [SendPort].
const String isolateName = 'isolate';

/// A port used to communicate from a background isolate to the UI isolate.
final ReceivePort port = ReceivePort();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  IsolateNameServer.registerPortWithName(
    port.sendPort,
    isolateName,
  );
  await NotificationService().init();
  await NotificationService().requestIOSPermissions();
  runApp(const MyApp());
}
