import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsProvider {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _mensajesStreamController = StreamController<String>.broadcast();
  Stream<String> get mensajesStream => _mensajesStreamController.stream;

  static Future<dynamic> onBackgroundMessage(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  intiNotifications() async {
    await _firebaseMessaging.requestNotificationPermissions();
    final token = await _firebaseMessaging.getToken();
    print('=================FCM Token==========================');
    print('token: $token');
    //Android
    //cDVwrguNSiW6SWJPvz2KtB:APA91bEJVPI-RHUm0Jk4p15t9YhrPRJW5_zHx-J6dJl5V2DlXye5ezH4g0N1Ku006lqc25EXqHHuH62H2-RYJybdv_vE3XMVDq2oRu9ERU6Uln0qJDGqG1BGr6xN1nGekcrID8n7LF8f
    _firebaseMessaging.configure(
      onMessage: onMessage,
      onBackgroundMessage:
          Platform.isIOS ? null : PushNotificationsProvider.onBackgroundMessage,
      onLaunch: onLaunch,
      onResume: onResume,
    );
  }

  Future<dynamic> onMessage(Map<String, dynamic> message) async {
    print('======================onMessage=======================');
    print('Message: $message');
    String argumento = 'no-data';
    print('Argumento: $argumento');
    if (Platform.isAndroid) {
      argumento = message['data']['texto'] ?? 'no-data';
    } else {
      argumento = message['texto'] ?? 'no-data';
    }
    _mensajesStreamController.sink.add(argumento);
  }

  Future<dynamic> onLaunch(Map<String, dynamic> message) async {
    print('======================onLaunch=======================');
    String argumento = 'no-data';
    print('Argumento: $argumento');
    if (Platform.isAndroid) {
      argumento = message['data']['texto'] ?? 'no-data';
    } else {
      argumento = message['texto'] ?? 'no-data';
    }
    _mensajesStreamController.sink.add(argumento);
  }

  Future<dynamic> onResume(Map<String, dynamic> message) async {
    print('======================onMessage=======================');
    print('Message: $message');
    String argumento = 'no-data';
    print('Argumento: $argumento');
    if (Platform.isAndroid) {
      argumento = message['data']['texto'] ?? 'no-data';
    } else {
      argumento = message['texto'] ?? 'no-data';
    }
    _mensajesStreamController.sink.add(argumento);
  }

  dispose() {
    _mensajesStreamController?.close();
  }
}
