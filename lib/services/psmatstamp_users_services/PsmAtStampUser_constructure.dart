import 'dart:convert';
import 'package:flutter/material.dart';

/// PsmAtStampUser are used to share user data with home_page
/// * Required
/// [prefix, name, surname, studentId, userId, year, room, permission]
/// * Optional
/// [profileImageUrl, otherInfo]
class PsmAtStampUser {
  String name;
  String prefix;
  String surname;
  String studentId;
  String userId;
  String year;
  String room;
  String profileImageUrl;
  String displayName;
  String accessToken;
  String udid;
  PsmAtStampUserPermission permission;
  Map<String, dynamic> otherInfos;
  PsmAtStampUser(
      {@required String prefix,
      @required String name,
      @required String surname,
      @required String studentId,
      @required String userId,
      @required String year,
      @required String room,
      @required PsmAtStampUserPermission permission,
      @required String displayName,
      @required String accessToken,
      @required String udid,
      String profileImageUrl,
      Map<String, dynamic> otherInfos}) {
    this.prefix = prefix;
    this.name = name;
    this.surname = surname;
    this.studentId = studentId;
    this.userId = userId;
    this.year = year;
    this.room = room;
    this.udid = udid;
    this.permission = permission;
    this.displayName = displayName;
    this.profileImageUrl = profileImageUrl;
    this.otherInfos = otherInfos;
  }
  String exportToString() {
    String permission;
    switch (this.permission) {
      case PsmAtStampUserPermission.student:
        permission = "Student";
        break;
      case PsmAtStampUserPermission.staff:
        permission = "Staff";
        break;
      case PsmAtStampUserPermission.administrator:
        permission = "Administrator";
        break;
      default:
        permission = "Null";
    }
    Map<String, dynamic> psmAtStampUser = {
      "prefix": this.prefix,
      "name": this.name,
      "surname": this.surname,
      "userId": this.userId,
      "studentId": this.studentId,
      "year": this.year,
      "room": this.room,
      "permission": permission,
      "accessToken": this.accessToken,
      "udid": this.udid,
      "displayName": this.displayName,
      "profileImageUrl": this.profileImageUrl,
      "otherInfos":
          this.otherInfos != null ? json.encode(this.otherInfos) : "{}"
    };
    return json.encode(psmAtStampUser);
  }
}

/// PsmAtStampUserPermission is a permission for the PsmAtStampUser. Currently have [student, staff, administrator]
enum PsmAtStampUserPermission { student, staff, administrator }
