import 'package:first_app/screens/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
var uuid = Uuid();
var defaultUrl =
'https://www.channelfutures.com/files/2019/10/Focus-877x432.jpg';
void main() async {
HttpOverrides.global = new MyHttpOverrides();
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();
runApp(MyApp());
}
class MyApp extends StatelessWidget {
@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false,
theme: ThemeData(
primarySwatch: Colors.red,
),
home: const splashScreen(),
);}}class MyHttpOverrides extends HttpOverrides {
@override
HttpClient createHttpClient(SecurityContext? context) {
return super.createHttpClient(context)
..badCertificateCallback =
(X509Certificate cert, String host, int port) => true; }}
