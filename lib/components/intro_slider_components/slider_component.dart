import 'package:flutter/material.dart';

Widget sliderComponent(
    {@required String imageAsset,
    @required String title,
    @required String subTitle}) {
  return Container(
    decoration: BoxDecoration(
      color: Color.fromRGBO(30, 30, 30, 1),
    ),
    child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 50),
          ),
          Image.asset(
            imageAsset,
            scale: 3,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Sukhumwit",
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                ),
                Text(
                  subTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Sukhumwit",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 5,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
          ),
        ],
      ),
    ),
  );
}
