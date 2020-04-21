import 'package:flutter/material.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';

/// PsmAtStampRegister used to pass data;
/// * Required
/// [userId, email, profileImage, displayName, registationPlatform]
/// * Optional
/// [studentId, prefix, name, surname, year, room]
class PsmAtStampRegister {
  String studentId;
  String userId;
  String email;
  String profileImage;
  String displayName;
  String prefix;
  String name;
  String surname;
  String year;
  String room;
  PsmAtStampUserPermission permission;
  SignInServices signInServices;

  PsmAtStampRegister(
      {@required String userId,
      @required String email,
      @required String profileImage,
      @required String displayName,
      @required SignInServices signInServices,
      String studentId,
      String prefix,
      String name,
      String surname,
      String year,
      String room,
      PsmAtStampUserPermission permission}) {
    this.studentId = studentId;
    this.userId = userId;
    this.email = email;
    this.profileImage = profileImage;
    this.displayName = displayName;
    this.prefix = prefix;
    this.name = name;
    this.surname = surname;
    this.year = year;
    this.room = room;
    this.permission = permission;
    this.signInServices = signInServices;
  }
}
