import 'package:flutter/material.dart';
class Help extends StatelessWidget {
const Help({super.key});
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text(
"Help",
style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
),
),
body: Padding(
padding: const EdgeInsets.all(30),
child: Column(
children: const [
Text(
"Hey Everyone , I hope Our App is Contributing in your career's
growth, I would be very happy if you ask your queries and tell about the
problems you're facing , Kindly Email your query to the following Email
id , Our team will reach you ASAP , Thank you",
style: TextStyle(
fontSize: 22,
),
),
SizedBox(
height: 70),
Text(
"weconnect2002@gmail.com",
style: TextStyle(color: Colors.blue, fontSize: 24),
)], ),));}}
