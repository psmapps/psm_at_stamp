import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/screens/home_screens/custom_tab_indicator.dart';
import 'package:psm_at_stamp/screens/my_account_screens/my_account_screen.dart';
import 'package:psm_at_stamp/screens/stamp_book_screens/stamp_book_screen.dart';
import 'package:psm_at_stamp/services/home_screen_services/check_did_override_signin.dart';
import 'package:psm_at_stamp/services/intro_screen_services/check_open_intro.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/qr_code_scaner_services/scan_qr_code.dart';

class HomeScreen extends StatefulWidget {
  final PsmAtStampUser psmAtStampUser;
  HomeScreen({Key key, @required this.psmAtStampUser}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TabController tabController;
  @override
  void initState() {
    super.initState();
    checkDidOverrideSignIn(context, psmAtStampUser: widget.psmAtStampUser);
    checkOpenIntro(context, psmAtStampUser: widget.psmAtStampUser);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
          children: <Widget>[
            StampBookScreen(
              psmAtStampUser: widget.psmAtStampUser,
            ),
            MyAccountScreen(
              psmAtStampUser: widget.psmAtStampUser,
            )
          ],
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
              fontFamily: "Sukhumwit",
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            tabs: [
              Tab(
                icon: Icon(FontAwesomeIcons.book),
                child: Text("สมุดแสตมป์"),
              ),
              Tab(
                icon: Icon(FontAwesomeIcons.userAlt),
                child: Text("บัญชีของฉัน"),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
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
          onPressed: () {
            scanQrCode(
              context,
              psmAtStampUser: widget.psmAtStampUser,
            );
          },
        ),
      ),
    );
  }
}
