import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final _messageStreamController = StreamController<String>.broadcast();

  Stream<String> get messages => _messageStreamController.stream;

  initNotifications() {
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));

    _firebaseMessaging.getToken().then((token) {
      assert(token != null);
      print('======FCM==============');
      print(token);
      // cbqa8w0TSSOoJz0zS9FEhz:APA91bEFE151eLlHkb-bc_NwtxllnF5oAOc5MlvYrEqivFUAtjQ9WHjAUKHPIVDl8MQSHoBcoxPvDV_lvhnka2GqCiw_I4GVRSpS6Avm-fQvhWo_FlGFzcN5lcmU8WSlVpdyMe1DyRCb
    });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  dispose() {
    _messageStreamController?.close();
  }
}
