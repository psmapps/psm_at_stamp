import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:psm_at_stamp/components/notification_components/bell_animation_component.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:soundpool/soundpool.dart';

Soundpool pool = Soundpool(streamType: StreamType.notification);

void firebaseMessageConfig() async {
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  String fcmToken = "No Data";
  try {
    fcmToken = await firebaseMessaging.getToken().timeout(
          Duration(seconds: 10),
        );
    logger.d("Firebase Cloud Messaging Token: " + fcmToken);
  } catch (e) {
    logger.e(e);
    return;
  }
  kNotificationDuration = Duration(seconds: 15);
  int soundId = await rootBundle
      .load("assets/audios/graceful.mp3")
      .then((ByteData soundData) {
    return pool.load(soundData);
  });
  firebaseMessaging.subscribeToTopic("NEWS");
  firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      try {
        logger.d('onMessage called: ' + message.toString());
        HapticFeedback.heavyImpact();
        await Future.delayed(Duration(milliseconds: 500));
        HapticFeedback.heavyImpact();
        pool.play(soundId);

        showSimpleNotification(
          Text(
            message["aps"]["alert"]["title"] ?? "Notification",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          subtitle: Text(
            message["aps"]["alert"]["body"] ?? "-",
            style: TextStyle(fontSize: 17),
          ),
          leading: BellNotificationAnimation(),
          background: Colors.grey[850],
          autoDismiss: true,
          position: NotificationPosition.top,
        );
      } catch (e) {
        logger.e(e);
        logger.d('onMessage called Error: ' + message.toString());
      }
    },
    onResume: (Map<String, dynamic> message) async {
      logger.d('onResume called: $message');
    },
    onLaunch: (Map<String, dynamic> message) async {
      logger.d('onLaunch called: $message');
    },
  );
}
