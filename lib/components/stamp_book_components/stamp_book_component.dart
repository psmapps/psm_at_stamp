import 'package:flutter/material.dart';

Widget stampBookWidget(
    {@required String stampTitle,
    @required Function onTapHandler,
    String iconUrl}) {
  return Container(
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        splashColor: Colors.black38,
        borderRadius: BorderRadius.circular(20),
        onTap: onTapHandler,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: iconUrl != null
                  ? FadeInImage.assetNetwork(
                      imageScale: 10,
                      placeholderScale: 10,
                      fadeInCurve: Curves.decelerate,
                      fadeInDuration: Duration(milliseconds: 375),
                      fadeOutCurve: Curves.decelerate,
                      fadeOutDuration: Duration(milliseconds: 375),
                      placeholder: "assets/images/icons/icon_gray.png",
                      image: iconUrl,
                    )
                  : Image.asset(
                      "assets/images/icons/icon_gray.png",
                      scale: 10,
                    ),
            ),
            ListTile(
              title: Center(
                child: Text(
                  stampTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Sukhumwit",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
