import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';

SignInServices psmAtStampStringToSignInService(
    {@required String signInService}) {
  switch (signInService) {
    case "apple":
      return SignInServices.apple;
      break;
    case "line":
      return SignInServices.line;
      break;
    case "email":
      return SignInServices.email;
      break;
    case "google":
      return SignInServices.google;
      break;
    default:
      throw PlatformException(code: "UNKNOWN_SIGNIN_SERVICE");
  }
}

String psmAtStampSignInServiceToString(
    {@required SignInServices signInService}) {
  switch (signInService) {
    case SignInServices.apple:
      return "apple";
      break;
    case SignInServices.line:
      return "line";
      break;
    case SignInServices.email:
      return "email";
      break;
    case SignInServices.google:
      return "google";
      break;
    default:
      throw PlatformException(code: "UNKNOWN_SIGNIN_SERVICE");
  }
}
