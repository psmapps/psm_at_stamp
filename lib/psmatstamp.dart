import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/icon_data.dart';

import 'stampbook.dart';

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

List<Category> categories = [
  Category(0,"Loading...", icon: IconDataSolid(0xf029)),
];

List categories_firestore = [];

Future<void> refreshCategories() async {
    print("Refresing");
      Firestore.instance.collection("Categories").getDocuments().then((documentSnapshort) {
        var icon;
        categories = [];
        categories_firestore = [];
        var count = 0;
        documentSnapshort.documents.forEach((doc) => {
          
          if (doc.data["icon"] != null){
            icon = IconDataBrands(0xf3e2),
          } else {
            icon = IconDataSolid(0xf029),
          
          },
          categories.add(Category(count, doc.documentID ,icon: icon),),
          categories_firestore.add(doc.documentID),
          count += 1,
        });
        setState( () {
          _buildCategoryItem;
        });
    });
}

  @override
  void initState(){
    super.initState();
    Firestore.instance.collection("Categories").getDocuments().then((documentSnapshort) {
        var icon;
        categories = [];
        categories_firestore = [];
        var count = 0;
        documentSnapshort.documents.forEach((doc) => {
          
          if (doc.data["icon"] != null){
            icon = IconDataSolid(int.parse(doc.data['icon'])),
          } else {
            icon = IconDataSolid(0xf029),
          
          },
          categories.add(Category(count, doc.documentID ,icon: icon),),
          categories_firestore.add(doc.documentID),
          count += 1,
        });
        setState( () {
          _buildCategoryItem;
        });
    });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: Text('แสกน QR Code', style: TextStyle(fontWeight: FontWeight.bold),),
        icon: Icon(Icons.camera_alt),
        backgroundColor: Colors.pink,
        onPressed: () {
          print("Hello");
      },),
      
    body: Container(
      child: DefaultTabController(
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
              
                child: CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30, bottom: 30),
                          child: Text("กรุณาเลือกกลุ่มสาระการเรียนรู้ เพื่อดูแสตมป์", maxLines: 2,style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0
                        ),
                        delegate: SliverChildBuilderDelegate(
                          _buildCategoryItem,
                          childCount: categories.length,

                        )

                      ),
                    ),
                  ]
                ),
              ),
            
            Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      // Where the linear gradient begins and ends
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      // Add one stop for each color. Stops should increase from 0 to 1
                      colors: [
                        // Colors are easy thanks to Flutter's Colors class.
                        Colors.redAccent,
                        Colors.blue,
                        Colors.yellow,
                      
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
                                                      child: Image.network(widget.profileImage, height: 160,width: 160,),
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
                                                            Text(widget.displayName, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent),),
                                                            Padding(padding: EdgeInsets.only(top: 10),
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: <Widget>[
                                                                Text(widget.prefix + widget.name + " " + widget.surname, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                                                                Text("ชั้น: ม." + widget.year + "/" + widget.room, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                                                                Text("รหัสนักเรียน: " + widget.studentId, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
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
                                padding: const EdgeInsets.all(10),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  color: Colors.yellowAccent,
                                  padding: const EdgeInsets.all(10),
                                  child: Center(
                                    child: Text("ออกจากระบบ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
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
      ),
    )
    );
  }
  Widget _buildCategoryItem(BuildContext context, int index) {
    Category category = categories[index];
    return MaterialButton(
      elevation: 1.0,
      highlightElevation: 1.0,
      onPressed: () => _categoryPressed(context,category),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.black87,
      textColor: Colors.white,
      
      
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if(category.icon != null)
            Icon(category.icon),
          if(category.icon != null)
            SizedBox(height: 5.0),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              category.name,
              textAlign: TextAlign.center,
              maxLines: 3,
              style: TextStyle(fontSize: 19),),
          ),
        ],
      ),
    );
  }

  _categoryPressed(BuildContext context,Category category) {
    if (category.name != "Loading..."){
    var catid = categories_firestore[category.id]; 
    Navigator.push(context, MaterialPageRoute(builder: (context) => Stampbook(userId: widget.userId, categoriesid: catid, icon: category.icon,)));
    }


  }
}
  
class Category{
  final int id;
  final String name;
  final dynamic icon;
  Category(this.id, this.name, {this.icon});

}