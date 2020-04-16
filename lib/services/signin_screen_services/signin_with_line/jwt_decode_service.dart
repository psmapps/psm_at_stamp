import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// jwtDecode is used to decode the json web token
/// * Required
/// [token]
Map<String, dynamic> jwtDecode({@required String token}) {
  if (token == null) return null;
  final parts = token.split('.');
  if (parts.length != 3) {
    throw new PlatformException(code: "INCORRECT_JWT_FORMAT");
  }
  final payload = parts[1];
  var normalized = base64Url.normalize(payload);
  var resp = utf8.decode(base64Url.decode(normalized));
  final payloadMap = json.decode(resp);
  if (payloadMap is! Map<String, dynamic>) {
    throw new PlatformException(code: "INCORRECT_JWT_FORMAT");
  }
  return payloadMap;
}
