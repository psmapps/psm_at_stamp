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
      String profileImageUrl,
      Map<String, dynamic> otherInfos}) {
    this.prefix = prefix;
    this.name = name;
    this.surname = surname;
    this.studentId = studentId;
    this.userId = userId;
    this.year = year;
    this.room = room;
    this.permission = permission;
    this.profileImageUrl = profileImageUrl;
    this.otherInfos = otherInfos;
  }
}

/// PsmAtStampUserPermission is a permission for the PsmAtStampUser. Currently have [student, staff, administrator]
enum PsmAtStampUserPermission { student, staff, administrator }
