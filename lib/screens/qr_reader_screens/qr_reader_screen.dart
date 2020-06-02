import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:psm_at_stamp/components/notification_components/message_box.dart';
import 'package:psm_at_stamp/screens/setting_screens/setting_screen.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
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

class _QrReaderScreenState extends State<QrReaderScreen> {
  var qrText = "";
  QRViewController controller;
  Widget qrView = Container(
    decoration: BoxDecoration(
      color: Color.fromRGBO(31, 31, 31, 1),
    ),
  );
  bool isFrontCamera = false;

  @override
  void initState() {
    super.initState();
    cameraPermissionCheck();
  }

  Future<void> delaySetState() async {
    await Future.delayed(Duration(milliseconds: 300));
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
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: qrView,
              ),
              Expanded(
                flex: 1,
                child: Text("นำกล้องไปแสกน QR Code ที่มี อยู่ตรงกลาง"),
              )
            ],
          ),
          Container(
              padding: const EdgeInsets.only(top: 40, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    color: Colors.white,
                    iconSize: 40,
                    icon: Icon(Icons.switch_camera),
                    splashColor: Colors.grey,
                    enableFeedback: true,
                    onPressed: () {
                      controller.flipCamera();
                    },
                  ),
                ],
              ))
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen(
      (scanData) async {
        controller.pauseCamera();
        try {
          await scanQrCode(
            context,
            psmAtStampUser: widget.psmAtStampUser,
            result: scanData,
          );
        } on PlatformException catch (e) {
          if (e.code != "QRNOTCORRECT") {
            showMessageBox(
              context,
              title: "เกิดข้อผิดพลาดไม่ทราบสาเหตุ",
              content: "เกิดข้อผิดพลาดไม่ทราบสาเหตุ (Code " + e.code + " )",
              icon: FontAwesomeIcons.exclamationTriangle,
              iconColor: Colors.yellow,
              actionsButton: [
                IconButton(
                  icon: Icon(FontAwesomeIcons.timesCircle),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                )
              ],
            );
          }
          showMessageBox(
            context,
            title: "QR Code ไม่ถูกต้อง",
            content:
                "กรุณาสแกน QR Code ที่มีโลโก้ PSM @ STAMP อยู่ตรงกลางของ QR Code เท่านั้น",
            icon: FontAwesomeIcons.exclamationTriangle,
            iconColor: Colors.yellow,
            actionsButton: [
              IconButton(
                icon: Icon(FontAwesomeIcons.timesCircle),
                onPressed: () {
                  Navigator.pop(context);
                  controller.resumeCamera();
                },
              )
            ],
          );
        } catch (e) {
          showMessageBox(
            context,
            title: "เกิดข้อผิดพลาดไม่ทราบสาเหตุ",
            content: "เกิดข้อผิดพลาดไม่ทราบสาเหตุ (Code " + e.code + " )",
            icon: FontAwesomeIcons.exclamationTriangle,
            iconColor: Colors.yellow,
            actionsButton: [
              IconButton(
                icon: Icon(FontAwesomeIcons.timesCircle),
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              )
            ],
          );
        }
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
