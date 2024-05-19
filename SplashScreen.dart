import 'dart:async';
import 'package:first_app/widget_tree.dart';
import 'package:flutter/material.dart';
class splashScreen extends StatefulWidget {
const splashScreen({super.key});
@override
State<splashScreen> createState() => _splashScreenState();
}
class _splashScreenState extends State<splashScreen> {
@override
void initState() {
super.initState();
Timer(Duration(seconds: 1), () {
Navigator.pushReplacement(
context, MaterialPageRoute(builder: (context) => WidgetTree()));
});
}
Widget build(BuildContext context) {
return Scaffold(
body: Column(
mainAxisAlignment: MainAxisAlignment.center,
crossAxisAlignment: CrossAxisAlignment.center,
children: [
Image(height: MediaQuery.of(context).size.height * .3,
width: MediaQuery.of(context).size.width * .6,
image: const AssetImage('images/scree.png')),
// ignore: prefer_const_constructors
SizedBox(
height: 10,
),
const Padding(
padding: EdgeInsets.symmetric(vertical: 30),
// ignore: prefer_const_constructors
child: Align(
alignment: Alignment.center,
child: Text(
'Connecting World',
style: TextStyle(
fontStyle: FontStyle.italic,
fontWeight: FontWeight.w400,
fontSize: 30),
),
),
),
],
),
);
}
}
