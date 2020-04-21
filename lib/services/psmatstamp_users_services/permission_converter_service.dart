import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';

String psmAtStampPermissionToString(
    {@required PsmAtStampUserPermission psmAtStampUserPermission}) {
  switch (psmAtStampUserPermission) {
    case PsmAtStampUserPermission.administrator:
      return "Administrator";
      break;
    case PsmAtStampUserPermission.staff:
      return "Staff";
      break;
    case PsmAtStampUserPermission.student:
      return "Student";
      break;
    default:
      throw PlatformException(code: "UNKNOWN_PERMISSION");
  }
}

PsmAtStampUserPermission psmAtStampStringToPermission(
    {@required String permissionString}) {
  switch (permissionString) {
    case "Student":
      return PsmAtStampUserPermission.student;
      break;
    case "Staff":
      return PsmAtStampUserPermission.staff;
      break;
    case "Administrator":
      return PsmAtStampUserPermission.administrator;
      break;
    default:
      throw PlatformException(code: "UNKNOWN_PERMISSION");
  }
}
