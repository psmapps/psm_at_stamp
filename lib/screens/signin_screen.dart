import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(31, 31, 31, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Center(
                child: Image.asset(
                  "assets/images/icons/icon.png",
                  scale: 3.5,
                ),
              ),
              Text(
                "Welcome to PSM @ STAMP",
                style: TextStyle(
                    fontFamily: "Library",
                    color: Color.fromRGBO(225, 223, 26, 1),
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Please Sign-in before start using.",
                style: TextStyle(color: Colors.white),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: RaisedButton(
                  onPressed: () {},
                  child: Text("Hello"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
