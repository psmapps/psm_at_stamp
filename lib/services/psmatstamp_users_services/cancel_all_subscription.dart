import 'package:psm_at_stamp/services/psmatstamp_users_services/listener_on_user_update.dart';

void cancelAllSubscription() {
  onUserUpdateStreamSubscription.cancel();
}
