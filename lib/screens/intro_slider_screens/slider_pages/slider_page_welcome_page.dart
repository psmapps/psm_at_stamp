import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:psm_at_stamp/components/intro_slider_components/slider_component.dart';

class SliderPageWelcomePage extends StatefulWidget {
  SliderPageWelcomePage({Key key}) : super(key: key);

  @override
  _SliderPageWelcomePageState createState() => _SliderPageWelcomePageState();
}

class _SliderPageWelcomePageState extends State<SliderPageWelcomePage> {
  String version = "-";
  String buildNumber = "-";
  @override
  void initState() {
    getPackageInfo();
    super.initState();
  }

  Future<void> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return sliderComponent(
      imageAsset: "assets/images/psmatstampintro.gif",
      title: "ยินดีต้อนรับเข้าสู่ PSM @ STAMP",
      subTitle: "มารู้จักกับ PSM @ STAMP v." +
          version +
          " กันดีกว่า \nปัดซ้ายแล้วเริ่มกันเลย... >",
    );
  }
}
