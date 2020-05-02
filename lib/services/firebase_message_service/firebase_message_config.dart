import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';

void firebaseMessageConfig() async {
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  String fcmToken = await firebaseMessaging.getToken();
  logger.d("Firebase Cloud Messaging Token: " + fcmToken);
  firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      logger.d('onMessage called: $message');
    },
    onResume: (Map<String, dynamic> message) async {
      logger.d('onResume called: $message');
    },
    onLaunch: (Map<String, dynamic> message) async {
      logger.d('onLaunch called: $message');
    },
  );
}
