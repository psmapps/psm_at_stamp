import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class Stampdetail extends StatefulWidget{

  var stampId;
  var stampName;
  var userId;
  var stampIcon;

  Stampdetail({Key key, @required this.stampId, @required this.stampName, @required this.userId, @required this.stampIcon});
  @override
  Stampdetailstate createState() => Stampdetailstate();
}

class Stampdetailstate extends State<Stampdetail>{
  var detail = "";
  var location = "";
  var isOpen = "";
  var stamped = false;
  var recieveddate = "";
  var ref = "";
  @override
  void initState() {
    super.initState();
    Firestore.instance.collection("Stamp_Data").document(widget.stampId).get().then((doc) {
      if (!doc.exists) {
        Navigator.pop(context);
      } else {
        if (doc.data['location'] != null){
          setState( () {
            location = doc.data["location"];
          });       
        } else {
          setState(() {
            location = "ไม่มีข้อมูล";
          });
          
        }

        if (doc.data["detail"] != null){
          setState(() {
            detail = doc.data["detail"];
          });
          
        } else {
          setState(() {
            detail = "ไม่มีข้อมูล";
          });
        }
        
        if (doc.data["isOpen"] == null){
          setState(() {
            isOpen = "ไม่มีข้อมูล";
          });
        } else if (doc.data["isOpen"] == true){
          setState(() {
            isOpen = "เปิด";
          });
        } else {
          setState(() {
            isOpen = "ปิด";
          });
        }
      }
      
    });

    Firestore.instance.collection("Stamp_Transaction").where("userId", isEqualTo: widget.userId).getDocuments().then((docdata) {
      if (docdata.documents.isNotEmpty){
        docdata.documents.forEach((doctran) {
          if (doctran.data["stampId"] == widget.stampId) {
            var timeStamp = doctran.data["timeStamp"];
           
            setState(() {
              stamped = true;
              recieveddate = timeStamp;
              ref = doctran.documentID;
            });
            return;
          }
        });
      }
    });

  }
  @override
  Widget  build(BuildContext context){
    return Scaffold(
      
      appBar: AppBar(
      backgroundColor: Colors.black87,
      title: Text(widget.stampName),
      ),
      body: Stack(
        
        children: <Widget>[ 
          Container(
          decoration: BoxDecoration(
                      gradient: LinearGradient(
                        // Where the linear gradient begins and ends
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,

                        colors: [
                          // Colors are easy thanks to Flutter's Colors class.
                          Colors.blue,
                          Colors.yellow,
                          Colors.redAccent

                        ],
                      ),
          ),
          ),
        
          SingleChildScrollView(
            child: Column(
              children: <Widget> [
                Padding(
                padding: const EdgeInsets.all(20),
                
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  color: Colors.black,
                  child: Row(
                    
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          child: Icon(widget.stampIcon, size: 70, color: Colors.yellowAccent,)),
                      ),
                      Expanded( 
                        child: Center(child: Text(widget.stampName, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30), maxLines: 2,)),
                      )
                    ],
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20 , 20),
                
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  color: Colors.black,
                  child: Row(
                    children: <Widget> [
                      Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text("รายละเอียดแสตมป์:", style: TextStyle(color: Colors.greenAccent, fontSize: 23, fontWeight: FontWeight.bold, decoration: TextDecoration.underline, decorationStyle: TextDecorationStyle.double),)
                            ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0,20,5),
                            child: Row(
                              children: <Widget>[
                                Text("ชื่อแสตมป์: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize:  17, color: Colors.orangeAccent),),
                                Expanded
                                (child: Text(widget.stampName, style: TextStyle(fontWeight: FontWeight.bold, fontSize:  17, color: Colors.white), maxLines: 2,))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0,20,5),
                            child: Row(
                              children: <Widget>[
                                Text("สถานะฐานกิจกรรม: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize:  17, color: Colors.orangeAccent),),
                                Expanded
                                (child: Text(isOpen, style: TextStyle(fontWeight: FontWeight.bold, fontSize:  17, color: Colors.white), maxLines: 2,))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0,20,5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                
                                Text("ที่ตั้งจุดรับแสตมป์: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize:  17, color: Colors.orangeAccent), textAlign: TextAlign.start,),
                                Expanded( child: Text(location, style: TextStyle(fontWeight: FontWeight.bold, fontSize:  17, color: Colors.white), maxLines: 2, textAlign: TextAlign.start))
                              
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0,20,20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                
                                Text("คำอธิบาย:  ", style: TextStyle(fontWeight: FontWeight.bold, fontSize:  17, color: Colors.orangeAccent), textAlign: TextAlign.start,),
                                Expanded( child: Text(detail, style: TextStyle(fontWeight: FontWeight.bold, fontSize:  17, color: Colors.white), maxLines: 10, textAlign: TextAlign.start))
                              
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    ]
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20 , 20),
                
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  color: Colors.black,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget> [
         
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                              ),
                              padding: const EdgeInsets.all(50),
                              
                            ),
                            if(stamped==true)
                              Image.asset('assets/image/stamped.png', height: 100, width: 100,),
                            
                            
                          ],
                        )
                      ),
                      Flexible(     
                       child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0,20,10,0),
                            child: Text("ข้อมูลการรับแสตมป์:", style: TextStyle(color: Colors.white),),
                          ),
                          if(stamped==true)
                            Padding(
                              padding: const EdgeInsets.only(top: 2, right: 10),
                              child: Text("ได้รับเมื่อ: " + recieveddate, style: TextStyle(color: Colors.white), maxLines: 2,)
                            ),
                          if(stamped==true)
                            Padding(
                              padding: const EdgeInsets.only(top: 2, right: 10),
                              child: Text("รหัสอ้างอิง: " + ref, style: TextStyle(color: Colors.white), maxLines: 2,)
                            ),
                          if(stamped==false)
                            Padding(
                              padding: const EdgeInsets.only(top: 2, right: 10),
                              child: Text("ไม่มีข้อมูล", style: TextStyle(color: Colors.white), maxLines: 2,)
                            ),
                          
                        ],
                        )                    

                      )
                    
                    ]
                  )
                  
                ),
              ),


              ]
            ),
          )
            
          
        ]
      )
    );
  }
}