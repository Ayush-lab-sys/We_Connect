import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class API {
void toastMessages(String msg) {
Fluttertoast.showToast(
msg: msg,
toastLength: Toast.LENGTH_SHORT,
gravity: ToastGravity.SNACKBAR,
timeInSecForIosWeb: 2,
backgroundColor: Colors.red,
textColor: Colors.white,
fontSize: 16.0);
}
}
