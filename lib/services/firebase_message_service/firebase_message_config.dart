import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';

void firebaseMessageConfig() async {
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  String fcmToken = await firebaseMessaging.getToken();
  logger.d("Firebase Cloud Messaging Token: " + fcmToken);
  firebaseMessaging.subscribeToTopic("NEWS");
  firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      try {
        logger.d('onMessage called: ' + message.toString());
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
