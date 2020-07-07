import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final _messageStreamController = StreamController<String>.broadcast();

  Stream<String> get messages => _messageStreamController.stream;

  initNotifications() {
    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.getToken().then((token) {
      print('======FCM==============');
      print(token);
      // cbqa8w0TSSOoJz0zS9FEhz:APA91bEFE151eLlHkb-bc_NwtxllnF5oAOc5MlvYrEqivFUAtjQ9WHjAUKHPIVDl8MQSHoBcoxPvDV_lvhnka2GqCiw_I4GVRSpS6Avm-fQvhWo_FlGFzcN5lcmU8WSlVpdyMe1DyRCb
    });
    _firebaseMessaging.configure(
      //App in foreground
      onMessage: (message) async {
        print('=================== On Message==================');
        print(message);
        String args = 'no-data';
        if (Platform.isAndroid) {
          args = message['data']['llave'] ?? 'no-data';
        }
        _messageStreamController.sink.add(args);
      },
      //App Terminated
      onLaunch: (message) async {
        print('=================== On Launch==================');
        print(message);
      },

      //App in Background
      onResume: (message) async {
        print('=================== On Resume==================');
        print(message);
        final notificacion = message['data']['llave'];
        print(notificacion);
        _messageStreamController.sink.add(notificacion);
      },
    );
  }

  dispose() {
    _messageStreamController?.close();
  }
}
