import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/icon_data.dart';

import 'stamp_detail.dart';

class StampBook extends StatefulWidget {
  var categoriesid;
  var userId;
  var icon;
  StampBook(
      {Key key,
      @required this.categoriesid,
      @required this.userId,
      @required this.icon});

  @override
  StampBookState createState() => StampBookState();
}

class StampBookState extends State<StampBook> {
  var countstamp = "-";

  var categories_stamp = [];
  var stampid_already = [];
  var timeStamp_already = [];
  var stampName = [];

  List<Category> categories = [
    Category(99, "Loading...", false, icon: IconDataSolid(0xf029)),
  ];

  @override
  void initState() {
    categories_stamp = [];
    stampid_already = [];
    stampName = [];
    super.initState();
    print(widget.userId);
    Firestore.instance
        .collection("Stamp_Transaction")
        .where("userId", isEqualTo: widget.userId)
        .getDocuments()
        .then(
          (querySnap) => {
            if (querySnap.documents.isNotEmpty)
              {
                querySnap.documents.forEach((docstamp) {
                  if (docstamp.data["categories"] == widget.categoriesid) {
                    stampid_already.add(docstamp.data["stampId"]);
                  }
                })
              },
            Firestore.instance
                .collection("Stamp_Data")
                .where("categories", isEqualTo: widget.categoriesid)
                .getDocuments()
                .then(
              (querySnapshot) {
                categories_stamp = [];
                categories = [];
                if (querySnapshot.documents.isNotEmpty) {
                  var count = 0;
                  querySnapshot.documents.forEach((doc) {
                    if (stampid_already.contains(doc.documentID)) {
                      categories.add(Category(count, doc.data["name"], true,
                          icon: widget.icon));
                    } else {
                      categories.add(Category(count, doc.data["name"], false,
                          icon: widget.icon));
                    }
                    stampName.add(doc.data["name"]);
                    categories_stamp.add(doc.documentID);
                    count += 1;
                  });
                } else {
                  categories.add(
                    Category(
                      99,
                      "ไม่มีแสตมป์ในกลุ่มสาระนี้",
                      false,
                      icon: IconDataSolid(0xf04d),
                    ),
                  );
                }

                setState(
                  () {
                    countstamp = stampid_already.length.toString();
                    _buildCategoryItem;
                  },
                );
              },
            ),
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(widget.categoriesid),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blue,
              Colors.yellow,
              Colors.redAccent,
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
                  child: Text(
                    "คุณได้รับ " + countstamp + " แสตมป์แล้วจากกลุ่มสาระนี้",
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
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
                    mainAxisSpacing: 10.0),
                delegate: SliverChildBuilderDelegate(
                  _buildCategoryItem,
                  childCount: categories.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, int index) {
    Category category = categories[index];
    return MaterialButton(
      elevation: 1.0,
      highlightElevation: 1.0,
      onPressed: () => _categoryPressed(context, category),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.black87,
      textColor: Colors.white,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          if (category.isStamped == true)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                'assets/image/stamped.png',
                height: 100,
                width: 100,
              ),
            ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (category.icon != null) Icon(category.icon),
                if (category.icon != null) SizedBox(height: 5.0),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    category.name,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    style: TextStyle(fontSize: 19),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _categoryPressed(BuildContext context, Category category) {
    if (category.id != 99) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StampDetail(
            stampId: categories_stamp[category.id],
            stampName: stampName[category.id],
            userId: widget.userId,
            stampIcon: widget.icon,
          ),
        ),
      );
    }
  }
}

class Category {
  final int id;
  final String name;
  final bool isStamped;
  final dynamic icon;
  Category(this.id, this.name, this.isStamped, {this.icon});
}
