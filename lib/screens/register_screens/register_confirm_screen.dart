import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/button_components/app_button_components.dart';
import 'package:psm_at_stamp/components/notification_components/message_box.dart';
import 'package:psm_at_stamp/components/register_screen_components/register_confirm_staff_sector.dart';
import 'package:psm_at_stamp/services/psmatstamp_stamp_services/psmatstamp_stamp_data_constructure.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/register_services/psmatstampregister_constructure.dart';
import 'package:psm_at_stamp/services/register_services/register_confirm_service.dart';

class RegisterConfirmScreen extends StatefulWidget {
  final PsmAtStampRegister psmAtStampRegister;
  final PsmAtStampStampData psmAtStampStampData;
  RegisterConfirmScreen(
      {Key key, @required this.psmAtStampRegister, this.psmAtStampStampData})
      : super(key: key);

  @override
  _RegisterConfirmScreenState createState() => _RegisterConfirmScreenState();
}

class _RegisterConfirmScreenState extends State<RegisterConfirmScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(31, 31, 31, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(40, 40, 40, 1),
        title: Text(
          "ผูกบัญชีกับรหัสนักเรียนหรือรหัสบัญชี",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white,
                      width: 7,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: FadeInImage.assetNetwork(
                      fit: BoxFit.cover,
                      width: 140,
                      height: 140,
                      fadeInCurve: Curves.easeIn,
                      placeholder: "assets/images/user.png",
                      image: widget.psmAtStampRegister.profileImage,
                    ),
                  ),
                ),
              ),
              Text(
                widget.psmAtStampRegister.displayName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
              ),
              Text(
                widget.psmAtStampRegister.prefix +
                    widget.psmAtStampRegister.name +
                    " " +
                    widget.psmAtStampRegister.surname,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "ชั้น ม." +
                    widget.psmAtStampRegister.year +
                    "/" +
                    widget.psmAtStampRegister.room +
                    "  -  " +
                    widget.psmAtStampRegister.studentId,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              widget.psmAtStampRegister.permission ==
                      PsmAtStampUserPermission.staff
                  ? registerConfirmStaffSector(
                      psmAtStampStampData: widget.psmAtStampStampData,
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(top: 10),
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: appButtonComponent(
                      title: "ข้อมูลไม่ถูกต้อง",
                      buttonColor: Colors.red,
                      textAlign: TextAlign.center,
                      onPressHandler: () {
                        showMessageBox(
                          context,
                          title: "ข้อมูลไม่ถูกต้อง",
                          content:
                              "หากข้อมูลไม่ถูกต้อง สามารถแจ้ง PSM @ STAMP Team เพื่อดำเนินการแก้ไขข้อมูลได้",
                          icon: FontAwesomeIcons.infoCircle,
                          iconColor: Colors.green,
                          actionsButton: [
                            IconButton(
                              icon: Icon(FontAwesomeIcons.timesCircle),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  Flexible(
                    child: appButtonComponent(
                      title: "ยืนยันการผูกบัญชี",
                      buttonColor: Colors.green,
                      textAlign: TextAlign.center,
                      onPressHandler: () {
                        if (widget.psmAtStampRegister.permission ==
                            PsmAtStampUserPermission.student) {
                          registerConfirm(
                            context,
                            psmAtStampRegister: widget.psmAtStampRegister,
                          );
                        }
                        if (widget.psmAtStampRegister.permission ==
                            PsmAtStampUserPermission.staff) {
                          registerConfirm(
                            context,
                            psmAtStampRegister: widget.psmAtStampRegister,
                            psmAtStampStampData: widget.psmAtStampStampData,
                          );
                        }
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
