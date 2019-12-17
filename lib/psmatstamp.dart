import 'package:flutter/material.dart';

class PSMATSTAMPMainPage extends StatefulWidget{
  var studentId;
  var prefix;
  var name;
  var surname;
  var year;
  var room;
  var userId;
  var displayName;
  var profileImage;
  var permission;
  var accessToken;
  PSMATSTAMPMainPage({Key key, @required this.studentId, @required this.prefix, @required this.name, @required this.surname, @required this.year, @required this.room, @required this.userId, @required this.displayName, @required this.profileImage, @required this.permission,@ required this.accessToken});
  
  @override
  _PSMATSTAMPMainPage createState() => _PSMATSTAMPMainPage();
}


class _PSMATSTAMPMainPage extends State<PSMATSTAMPMainPage>{

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black87,
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.book)),
                Tab(icon: Icon(Icons.settings)),
              ],
            ),
            title: Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Center(child: Image.asset("assets/image/full_logo.png", height: 80, width: 80,)),
              ),
            )
          ),
          body: TabBarView(
            children: [
              Icon(Icons.directions_car),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    // Where the linear gradient begins and ends
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    // Add one stop for each color. Stops should increase from 0 to 1
                    stops: [0.1, 0.5, 0.7, 0.9],
                    colors: [
                      // Colors are easy thanks to Flutter's Colors class.
                      Colors.indigo[800],
                      Colors.indigo[700],
                      Colors.indigo[600],
                      Colors.indigo[400],
                    ],
                  ),
                ),
                child: ListView(
                  children: <Widget>[
                    Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: InkWell(
                                  splashColor: Colors.grey,
                                  onTap: (){

                                  },
                                  child: Container(
                                      width: 400,
                                      height: 190,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                  padding: const EdgeInsets.only(top: 15, left: 10),
                                                  child:  ClipRRect(
                                                    borderRadius: BorderRadius.circular(20),
                                                    child: Image.network("", height: 160,width: 160,),
                                                  )
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 20, right: 5),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    FittedBox(
                                                      fit: BoxFit.fitWidth,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Text("Siratee K.", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent),),
                                                          Padding(padding: EdgeInsets.only(top: 10),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: <Widget>[
                                                              Text("นาย สิรธีร์ กิตติวิทย์เชาวกุล", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                                                              Text("ชั้น: 6/6", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                                                              Text("รหัสนักเรียน: 018693", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),)
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      )
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: RaisedButton(
                                child: Center(
                                  child: Text("Click to logout"),
                                ),
                                onPressed: (){
                                  
                                },
                              ),
                            ),

                          ],
                        )
                    ),
                  ],

                ),
              )
            ],
          ),
        ),
    );
  }
}