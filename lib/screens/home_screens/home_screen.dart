import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psm_at_stamp/screens/home_screens/custom_tab_indicator.dart';
import 'package:psm_at_stamp/screens/home_screens/screen_data_manager.dart';
import 'package:psm_at_stamp/screens/home_screens/screen_widget_constructure.dart';
import 'package:psm_at_stamp/screens/qr_reader_screens/qr_reader_screen.dart';
import 'package:psm_at_stamp/services/firebase_message_service/firebase_message_config.dart';
import 'package:psm_at_stamp/services/home_screen_services/check_did_override_signin.dart';
import 'package:psm_at_stamp/services/intro_screen_services/check_open_intro.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/listener_on_user_update.dart';

class HomeScreen extends StatefulWidget {
  final PsmAtStampUser psmAtStampUser;
  HomeScreen({Key key, @required this.psmAtStampUser}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TabController tabController;
  ScreenWidget screenWidget;
  @override
  void initState() {
    super.initState();
    if (widget.psmAtStampUser.permission == PsmAtStampUserPermission.staff ||
        widget.psmAtStampUser.permission ==
            PsmAtStampUserPermission.administrator) {
      logger.d("Subscribed to Staff Notification Channels");
      firebaseMessaging.subscribeToTopic("staffs_notification");
    }
    checkDidOverrideSignIn(context, psmAtStampUser: widget.psmAtStampUser);
    checkOpenIntro(context, psmAtStampUser: widget.psmAtStampUser);
    listenerOnUserUpdate(context, psmAtStampUser: widget.psmAtStampUser);
    screenWidget = screenDataManager(psmAtStampUser: widget.psmAtStampUser);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: screenWidget.tabBarCount,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(90, 90, 90, 1),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(31, 31, 31, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(19),
              bottomRight: Radius.circular(19),
            ),
          ),
          title: Center(
            child: Image.asset(
              "assets/images/icons/icon.png",
              scale: 18,
            ),
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: screenWidget.screenList,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(19),
              topRight: Radius.circular(19),
            ),
            color: Color.fromRGBO(31, 31, 31, 1),
          ),
          child: TabBar(
            indicator: CustomTabIndicator(),
            labelColor: Colors.white,
            controller: tabController,
            unselectedLabelStyle: TextStyle(fontSize: 0),
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            onTap: (index) {
              HapticFeedback.mediumImpact();
            },
            tabs: screenWidget.tabBarList,
          ),
        ),
        floatingActionButton:
            widget.psmAtStampUser.permission == PsmAtStampUserPermission.staff
                ? Container()
                : FloatingActionButton(
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      child: Image.asset(
                        "assets/images/icons/scanQr.png",
                        scale: 20,
                      ),
                    ),
                    tooltip: "สแกน QR Code",
                    splashColor: Colors.grey,
                    backgroundColor: Color.fromRGBO(255, 213, 127, 1),
                    onPressed: () async {
                      await HapticFeedback.heavyImpact();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QrReaderScreen(
                            psmAtStampUser: widget.psmAtStampUser,
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
