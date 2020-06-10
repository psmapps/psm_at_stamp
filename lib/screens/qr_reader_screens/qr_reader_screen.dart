import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:psm_at_stamp/components/notification_components/message_box.dart';
import 'package:psm_at_stamp/screens/setting_screens/setting_screen.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/qr_code_scaner_services/scan_qr_code.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrReaderScreen extends StatefulWidget {
  final PsmAtStampUser psmAtStampUser;

  QrReaderScreen({
    Key key,
    @required this.psmAtStampUser,
  }) : super(key: key);

  @override
  _QrReaderScreenState createState() => _QrReaderScreenState();
}

class _QrReaderScreenState extends State<QrReaderScreen>
    with WidgetsBindingObserver {
  AppLifecycleState _appState;
  var qrText = "";
  QRViewController controller;
  Widget qrView = Container(
    decoration: BoxDecoration(
      color: Color.fromRGBO(31, 31, 31, 1),
    ),
  );
  bool isFlashOn = false;
  bool isFrontCamera = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _appState = state;
    });
    if (_appState.index == 0) {
      this.controller.resumeCamera();
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    WidgetsBinding.instance.addObserver(this);
    cameraPermissionCheck();
  }

  @override
  void dispose() {
    controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Future<void> cameraPermissionCheck() async {
    await Permission.camera.request();
    if (!(await Permission.camera.isGranted)) {
      return showMessageBox(
        context,
        title: "ยังไม่ได้อนุญาตการใช้กล้อง",
        content:
            "คุณยังไม่ได้อนุญาตการใช้กล้องให้กับ PSM @ STAMP การใช้กล้องจำเป็นต่อการ Scan QR Code กรุณาอนุญาตการใช้กล้องด้วยการไปที่หน้า ตั้งค่า ก่อน",
        icon: FontAwesomeIcons.exclamationTriangle,
        iconColor: Colors.yellow,
        actionsButton: [
          IconButton(
            icon: Icon(FontAwesomeIcons.timesCircle),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
          IconButton(
            icon: Icon(FontAwesomeIcons.cog),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingScreen(
                    psmAtStampUser: widget.psmAtStampUser,
                  ),
                ),
              );
            },
          ),
        ],
      );
    }
    await Future.delayed(Duration(milliseconds: 300));
    setState(() {
      qrView = QRView(
        key: GlobalKey(debugLabel: 'QR'),
        overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: 300,
        ),
        onQRViewCreated: _onQRViewCreated,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Stack(
              children: <Widget>[
                qrView,
                Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(
                        top: 40,
                        left: 10,
                        right: 10,
                      ),
                      child: Row(
                        children: <Widget>[
                          InkWell(
                            onTap: () {},
                            child: IconButton(
                              color: Colors.white,
                              iconSize: 40,
                              icon: Icon(FontAwesomeIcons.times),
                              splashColor: Colors.grey,
                              enableFeedback: true,
                              onPressed: () {
                                HapticFeedback.mediumImpact();
                                Navigator.popUntil(
                                  context,
                                  (route) => route.isFirst,
                                );
                              },
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            color: Colors.white,
                            iconSize: 40,
                            icon: Icon(
                              isFlashOn ? Icons.flash_off : Icons.flash_on,
                            ),
                            enableFeedback: true,
                            onPressed: () {
                              HapticFeedback.heavyImpact();
                              controller.toggleFlash();
                              setState(() {
                                if (isFlashOn) {
                                  isFlashOn = false;
                                } else {
                                  isFlashOn = true;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: const EdgeInsets.all(30),
                      child: RaisedButton(
                        splashColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Color.fromRGBO(31, 31, 31, 0.8),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.camera,
                                color: Colors.white,
                                size: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                              ),
                              Text(
                                "สลับกล้อง",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Sukhumwit",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onPressed: () async {
                          await HapticFeedback.mediumImpact();
                          controller.flipCamera();
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          "นำกล้องไปแสกน QR Code ที่มี",
                          style: TextStyle(
                            fontFamily: "Sukhumwit",
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                        ),
                      ),
                      Flexible(
                        child: Image.asset(
                          "assets/images/icons/icon_curve_black.png",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          "อยู่ตรงกลาง",
                          style: TextStyle(
                            fontFamily: "Sukhumwit",
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen(
      (scanData) {
        controller.pauseCamera();
        HapticFeedback.mediumImpact();
        scanQrCode(
          context,
          psmAtStampUser: widget.psmAtStampUser,
          result: scanData,
          controller: controller,
        );
      },
    );
  }
}
