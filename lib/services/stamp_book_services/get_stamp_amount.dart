import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<int> getStampAmount({@required String categories}) async {
  QuerySnapshot docSnap = await Firestore.instance
      .collection("Stamp_Data")
      .where("categories", isEqualTo: categories)
      .getDocuments();
  return docSnap.documents.length;
}
