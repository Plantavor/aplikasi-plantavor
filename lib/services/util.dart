import 'dart:convert';
import 'package:crypto/crypto.dart';

String hashPass(String pass) {
  var bytes = utf8.encode(pass);
  return md5.convert(bytes).toString();
}
