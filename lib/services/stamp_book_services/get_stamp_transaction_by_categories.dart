import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<List> getStampTransactionByCategories(
    {@required String categories, @required String userId}) async {
  List stampIdFromTransactionList = [];
  QuerySnapshot querySnap = await Firestore.instance
      .collection("Stamp_Transaction")
      .where("userId", isEqualTo: userId)
      .where("categories", isEqualTo: categories)
      .getDocuments();
  if (querySnap.documents.isEmpty) {
    return stampIdFromTransactionList;
  }
  querySnap.documents.forEach((docSnap) {
    stampIdFromTransactionList.add(docSnap.data["stampId"]);
  });
  return stampIdFromTransactionList;
}
