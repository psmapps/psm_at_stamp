import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/permission_converter_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/signin_service_converter_service.dart';

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
  String stampId;
  PsmAtStampUserPermission permission;
  SignInServices signInServices;
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
      @required SignInServices signInServices,
      String profileImageUrl,
      String stampId,
      Map<String, dynamic> otherInfos}) {
    this.prefix = prefix;
    this.name = name;
    this.surname = surname;
    this.studentId = studentId;
    this.userId = userId;
    this.year = year;
    this.room = room;
    this.udid = udid;
    this.accessToken = accessToken;
    this.permission = permission;
    this.displayName = displayName;
    this.profileImageUrl = profileImageUrl;
    this.signInServices = signInServices;
    this.otherInfos = otherInfos;
    this.stampId = stampId;
  }
  String exportToString() {
    Map<String, dynamic> psmAtStampUser = {
      "prefix": this.prefix,
      "name": this.name,
      "surname": this.surname,
      "userId": this.userId,
      "studentId": this.studentId,
      "year": this.year,
      "room": this.room,
      "permission": psmAtStampPermissionToString(
          psmAtStampUserPermission: this.permission),
      "accessToken": this.accessToken,
      "udid": this.udid,
      "displayName": this.displayName,
      "profileImageUrl": this.profileImageUrl,
      "signInServices":
          psmAtStampSignInServiceToString(signInService: this.signInServices),
      "stampId": this.stampId,
      "otherInfos":
          this.otherInfos != null ? json.encode(this.otherInfos) : "{}"
    };
    return json.encode(psmAtStampUser);
  }
}

/// PsmAtStampUserPermission is a permission for the PsmAtStampUser. Currently have [student, staff, administrator]
enum PsmAtStampUserPermission { student, staff, administrator }

/// SignInServices is a permission for the PsmAtStampUser. Currently have [line, apple, google, email]
enum SignInServices { line, apple, google, email }
