import 'package:flutter/material.dart';
import 'package:psm_at_stamp/screens/intro_slider_screens/slider_pages/slider_page_stamp_indicator_page.dart';
import 'package:psm_at_stamp/screens/intro_slider_screens/slider_pages/slider_page_welcome_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroSliderScreen extends StatefulWidget {
  IntroSliderScreen({Key key}) : super(key: key);

  @override
  _IntroSliderScreenState createState() => _IntroSliderScreenState();
}

class _IntroSliderScreenState extends State<IntroSliderScreen> {
  int slideIndex = 0;
  PageController controller = new PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(31, 31, 31, 1),
      body: Container(
        child: Stack(
          children: <Widget>[
            PageView(
              controller: controller,
              onPageChanged: (index) {
                setState(() {
                  slideIndex = index;
                });
              },
              children: <Widget>[
                sliderPageWelcomePage(),
                sliderPageStampIndicatorPage(),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Center(
                  child: SmoothPageIndicator(
                    controller: controller,
                    count: 5,
                    effect: WormEffect(
                      spacing: 8.0,
                      radius: 26,
                      dotWidth: 16,
                      dotHeight: 16.0,
                      paintStyle: PaintingStyle.fill,
                      strokeWidth: 1.5,
                      dotColor: Colors.grey,
                      activeDotColor: Colors.yellowAccent,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
