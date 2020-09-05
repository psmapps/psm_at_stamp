import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<List> getStampTransactionByCategories(
    {@required String categories, @required String userId}) async {
  List stampIdFromTransactionList = [];
  QuerySnapshot querySnap = await FirebaseFirestore.instance
      .collection("Stamp_Transaction")
      .where("userId", isEqualTo: userId)
      .where("categories", isEqualTo: categories)
      .get();
  if (querySnap.docs.isEmpty) {
    return stampIdFromTransactionList;
  }
  querySnap.docs.forEach((docSnap) {
    stampIdFromTransactionList.add(docSnap.data()["stampId"]);
  });
  return stampIdFromTransactionList;
}
