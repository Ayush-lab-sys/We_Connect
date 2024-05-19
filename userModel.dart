import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
class UserModel {
String? uid;
String? fullname;
String? rid;
String? phone_no;
String? email;
String? batch;
String? stream;
String? clg_name;
String? profilepic;
UserModel(
{this.uid,
this.fullname,
this.rid,
this.phone_no,
this.email,
this.batch,
this.stream,
this.clg_name,
this.profilepic});
UserModel.fromMap(Map<String, dynamic> map) {
uid = map["uid"];
fullname = map["fullname"];
rid = map["rid"];phone_no = map["phone_no"];
email = map["email"];
batch = map["batch"];
stream = map["stream"];
clg_name = map["clg_name"];
profilepic = map["profilepic"];
}
Map<String, dynamic> toMap() {
return {
"uid": uid,
"fullname": fullname,
"rid": rid,
"phone_no": phone_no,
"email": email,
"batch": batch,
"stream": stream,
"clg_name": clg_name,
"profilepic": profilepic,
}; }}
