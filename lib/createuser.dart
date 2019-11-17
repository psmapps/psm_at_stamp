import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class createUser extends StatefulWidget{

  @override
  CreateUserState createState() => CreateUserState();
}

class CreateUserState extends State<createUser>{

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color.fromRGBO(43, 43, 43, 1),
    appBar: AppBar(

      title: Text("ผูกบัญชี LINE กับ PSM @ STAMP"),
    ),
    body: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Image.asset("assets/image/full_logo.png"),
                )
              ),
              Container(
                color: Colors.grey,
                width: 2,
                height: 100,
              ),
              Expanded(child: 
                Padding(
                  padding: const EdgeInsets.all(50),
                  child: Image.asset("assets/image/line_logo.png"),
                )
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            children: <Widget>[
                  Text("ผูกบัญชี LINE กับ PSM @ STAMP", style: TextStyle(fontSize: 20,color: Colors.white, fontWeight: FontWeight.bold)),
                  Text("(ทำเพียงครั้งแรกครั้งเดียว)", style: TextStyle(fontSize: 13,color: Colors.white, fontWeight: FontWeight.bold))
            ],
            )
        )
      ],
    )
  );
  }
}