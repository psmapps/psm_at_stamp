import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class confirmPage extends StatefulWidget{
  var studentId;
  var prefix;
  var name;
  var surname;
  var year;
  var room;
  var displayName;
  var profileImage;
  var userId;
  var accessToken;
  confirmPage({Key key, @required this.studentId, @required this.prefix ,@required this.name, @required this.surname, @required this.year, @required this.room, @required this.displayName, @required this.profileImage, @required this.userId, @required this.accessToken}): super(key: key);

  @override
  ConfirmPageState createState() => ConfirmPageState();
}


class ConfirmPageState extends State<confirmPage>{
  void initState(){
    print("----{Confirm Data}----");
    print("StudentId: " + widget.studentId);
    print(widget.prefix + widget.name + " " + widget.surname);
    print("M." + widget.year + "/" + widget.room);

    print("displayName: " + widget.displayName);
    print("userId: " + widget.userId);
    print("profileImage: " + widget.profileImage);
    print("accessToken: " + widget.accessToken);

    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color.fromRGBO(43, 43, 43, 1),
    appBar: AppBar(
      title: Text("ยืนยันการผูกบัญชี")
    ),
    body:  Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 5),
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
            padding: const EdgeInsets.only(top: 5),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(widget.profileImage, height: 170, width: 170,),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  children: <Widget>[
                  Text(widget.displayName, style: TextStyle(color: Colors.green, fontSize: 30, fontWeight: FontWeight.bold)),
                  Text(widget.prefix + widget.name + " " + widget.surname, style:  TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),),
                  Text("รหัสนักเรียน: " + widget.studentId + " - ชั้น: ม." + widget.year + "/" + widget.room, style:  TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),)
                 ],
                )
              ],
              ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                        Expanded(
                          child: RaisedButton(
                            padding: const EdgeInsets.fromLTRB(10, 15, 10 ,15),
                            child: Text("ข้อมูลไม่ถูกต้อง", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            onPressed: (){
                              //TODO: Show option to the user for data correction
                            },
                          ),
                        ),
                        Padding(padding: const EdgeInsets.all(5),),
                       Expanded(
                         child: RaisedButton(
                            color: Colors.orange,
                            padding: const EdgeInsets.fromLTRB(10, 15, 10 ,15),
                            child: Text("ข้อมูลของฉันถูกต้อง", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                            onPressed: (){
                                //TODO: Implement the creatUser function
                            },
                          ),
                       ),
                    ],
                  ),
                ),
                
              ],
            ),
          )
        ],
        ),
  );
  }

}