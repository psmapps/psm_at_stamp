import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';

/// signUserIn is used to get and set the data in the Stamp_User
/// * Required
/// [userId, udid]
Future<PsmAtStampUser> signUserIn(
    {@required String userId,
    @required String accessToken,
    @required String udid}) async {
  return Firestore.instance
      .collection("Stamp_User")
      .document(userId)
      .get()
      .then((doc) async {
    if (!doc.exists) {
      throw PlatformException(
          code: "ACCOUNT_NOT_FOUND",
          details: "The userId is not found in Stamp_User: " + userId);
    }
    Map<String, dynamic> docData = doc.data;
    bool didOverrideSignIn = false;
    PsmAtStampUserPermission _permission;
    String _remotePermission = docData["permission"];

    if (docData["accessToken"] != null &&
        docData["udid"] != null &&
        docData["udid"] != udid) {
      didOverrideSignIn = true;
    }

    if (docData["prefix"] == null ||
        docData["name"] == null ||
        docData["surname"] == null ||
        docData["studentId"] == null ||
        docData["year"] == null ||
        docData["class"] == null ||
        docData["permission"] == null) {
      throw PlatformException(
          code: "ACCOUNT_DATA_INVALID",
          details: "Some of required data is missing from this account");
    }

    await Firestore.instance
        .collection("Stamp_User")
        .document(userId)
        .updateData({"accessToken": accessToken, "udid": udid});

    if (_remotePermission == "student") {
      _permission = PsmAtStampUserPermission.student;
    } else if (_remotePermission == "staff") {
      _permission = PsmAtStampUserPermission.staff;
    } else if (_remotePermission == "administrator") {
      _permission = PsmAtStampUserPermission.administrator;
    } else {
      throw PlatformException(
          code: "UNKNOWN_PERMISSION",
          details: "Unknown permission type: " + docData["permission"]);
    }
    return PsmAtStampUser(
        prefix: docData["prefix"],
        name: docData["name"],
        surname: docData["surname"],
        userId: docData["userId"],
        studentId: docData["studentId"],
        year: docData["year"],
        room: docData["room"],
        permission: _permission,
        profileImageUrl: docData["profileImage"] ??
            "https://firebasestorage.googleapis.com/v0/b/satitprasarnmit-psm-at-stamp.appspot.com/o/user.png?alt=media&token=eb023a2a-0d9e-46f2-8301-ef4e0e20cfee",
        otherInfos: {"didOverrideSignIn": didOverrideSignIn});
  });
}