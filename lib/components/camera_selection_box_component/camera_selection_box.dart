import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/services/setting_services/get_camera_setting_file.dart';
import 'package:psm_at_stamp/services/setting_services/set_camera_setting_file.dart';

class CameraSelectionBox extends StatefulWidget {
  CameraSelectionBox({Key key}) : super(key: key);

  @override
  _CameraSelectionBoxState createState() => _CameraSelectionBoxState();
}

class _CameraSelectionBoxState extends State<CameraSelectionBox> {
  String dropdownValue = "-1";
  List<String> dropdownValueList = ["-1"];
  List<String> wordingForDropdownValue = [
    "ใช้ค่าเริ่มต้น",
    "กล้องหลัง",
    "กล้องหน้า"
  ];

  @override
  void initState() {
    super.initState();
    getAvailableCamera();
    getCurrentCameraSetting();
  }

  Future<void> getAvailableCamera() async {
    int _availableCamera = await BarcodeScanner.numberOfCameras;
    if (_availableCamera == 0) {
      setState(() {
        dropdownValueList.add("0");
      });
    } else if (_availableCamera >= 1) {
      setState(() {
        dropdownValueList.add("0");
        dropdownValueList.add("1");
      });
    }
  }

  Future<void> getCurrentCameraSetting() async {
    String cameraSetting = (await getCameraSetting())["camera"];
    setState(() {
      dropdownValue = cameraSetting;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10),
            ),
            ListTile(
              title: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.camera,
                      color: Colors.white,
                      size: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                    ),
                    Flexible(
                      child: Text(
                        "กล้องที่ใช้สแกน QR Code",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: "Sukhumwit",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Icon(Icons.arrow_downward),
                          ],
                        ),
                      ),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontFamily: "Sukhumwit",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String newValue) async {
                        await setCameraSetting(camera: newValue);
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: dropdownValueList.map<DropdownMenuItem<String>>(
                        (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.camera,
                                  size: 20,
                                  color: Colors.yellow[700],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                ),
                                Text(
                                  wordingForDropdownValue[int.parse(value) + 1],
                                )
                              ],
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
              ),
            )
          ],
        ),
      ),
    );
  }
}
