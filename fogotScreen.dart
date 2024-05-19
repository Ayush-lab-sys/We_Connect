//fogotScreen.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../API.dart';
class forgotScreen extends StatefulWidget {
const forgotScreen({super.key});
@override
State<forgotScreen> createState() => _forgotScreenState();
}
class _forgotScreenState extends State<forgotScreen> {
final FirebaseAuth _auth = FirebaseAuth.instance;
bool showSpinner = false;
final _formkey = GlobalKey<FormState>();
final TextEditingController _controllerEmail = TextEditingController();
@override
Widget build(BuildContext context) {
return ModalProgressHUD(
inAsyncCall: showSpinner,
child: Scaffold(
appBar: AppBar(
title: const Text('Forgot Password'),
),
backgroundColor: Colors.grey[300],
body: SafeArea(
child: Center(child: Form(
key: _formkey,
child: SingleChildScrollView(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
//Email Field
Padding(
padding: const EdgeInsets.symmetric(horizontal: 25),
child: Container(
decoration: BoxDecoration(
color: Colors.grey[200],
border: Border.all(color: Colors.white),
borderRadius: BorderRadius.circular(12),
),
child: Padding(
padding: const EdgeInsets.only(left: 20),
child: TextFormField(
validator: (value) =>
value!.isEmpty ? "Enter an email" : null,
decoration: const InputDecoration(
border: InputBorder.none,
hintText: 'Email',
icon: Icon(
Icons.email,
), ),
controller: _controllerEmail,
), ),), ),
//Password textfieldSizedBox(height: 30),
Padding(
padding: const EdgeInsets.symmetric(horizontal: 25),
child: Container(
child: ElevatedButton(
onPressed: () {
if (_formkey.currentState!.validate()) {
setState(() {
showSpinner = true; });
try {
_auth
.sendPasswordResetEmail(
email: _controllerEmail.text.toString())
.then((value) {
setState(() {
showSpinner = false;
});
API().toastMessages(
'Please Check Your Email, a Reset link has been sent to
you via email');
}).onError((error, stackTrace) {
setState(() {
showSpinner = false;
});
API().toastMessages(error.toString());
});
} catch (e) {
API().toastMessages(e.toString());
setState(() {showSpinner = false;
}); }}},
style: ElevatedButton.styleFrom(
backgroundColor: Colors.blue,
fixedSize: const Size(360, 50),
),
child: const Text(
'Send Request',
style: TextStyle(
color: Colors.white,
fontSize: 17,
fontWeight: FontWeight.bold,
), ), ), ),),],),),),), ),),);}}
