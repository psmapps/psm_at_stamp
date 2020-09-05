import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';

Future<String> getCategoriesIcon({@required String categories}) async {
  DocumentSnapshot categoriesDoc;
  try {
    categoriesDoc = await FirebaseFirestore.instance
        .collection("Categories")
        .doc(categories)
        .get()
        .timeout(Duration(seconds: 10));
  } catch (e) {
    logger.e(e);
    throw e;
  }
  if (!categoriesDoc.exists) {
    throw PlatformException(code: "Categories_Not_Found");
  }
  return categoriesDoc.data()["iconUrl"];
}
