//SignUp.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/models/usermodel.dart';
import 'package:first_app/screens/main_page.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../API.dart';
class signup extends StatefulWidget {
const signup({super.key});
@override
State<signup> createState() => _signupState();
}
class _signupState extends State<signup> {
final TextEditingController _controllerEmail = TextEditingController();
final TextEditingController _controllerPassword =
TextEditingController();
final TextEditingController _confirmPassword =
TextEditingController();
final TextEditingController _controllerName = TextEditingController();
final TextEditingController _controllerRid = TextEditingController();
final TextEditingController _controllerPhoneNo =
TextEditingController();
final TextEditingController _controllerClgName =
TextEditingController();
final streamSelected = TextEditingController();
String? errorMessage = '';
User? currentUser = FirebaseAuth.instance.currentUser;
void createUserWithEmailAndPassword() async {
if (_formkey.currentState!.validate()) {
setState(() {
showSpinner = true;
});
UserCredential? credential;
try {
credential = await
FirebaseAuth.instance.createUserWithEmailAndPassword(
email: _controllerEmail.text,
password: _controllerPassword.text, ); ;}
catch (e) {
API().toastMessages(e.toString());
setState(() {
showSpinner = false;
});;}
if (credential != null) {
String uid = credential.user!.uid;
UserModel newUser = UserModel(
uid: uid,
fullname: _controllerName.text.trim(),
rid: _controllerRid.text.trim(),
phone_no: _controllerPhoneNo.text.trim(),
email: _controllerEmail.text.trim(),
batch: _value2,
stream: _value1,
profilepic: ""
,
clg_name: _controllerClgName.text.trim());
await FirebaseFirestore.instance
.collection("users")
.doc(uid)
.set(newUser.toMap())
.then((value) {
setState(() {
showSpinner = false;
});
API().toastMessages("User Successfully Created");
Navigator.pushReplacement(
context,
MaterialPageRoute(builder: (context) {
return MainPage();
}), ); });}}}
final batch = [
'2020-2023', '2019-2022', '2018-2021', '2017-2020', '2016-
2019', '2015-2018' ];
bool showSpinner = false;
final _formkey = GlobalKey<FormState>();
@override
late String _value1, _value2;
void initState() {
super.initState();
_value1 = streams[0];
_value2 = batch[0];
}
Widget build(BuildContext context) {
return ModalProgressHUD(
inAsyncCall: showSpinner,
child: Scaffold(
backgroundColor: Colors.grey[100],
body: Form(
key: _formkey,
child: SingleChildScrollView(
child:
Column(crossAxisAlignment: CrossAxisAlignment.start,
children: [
//Name
SizedBox(
height: 40,
),
Padding(
padding: const EdgeInsets.symmetric(horizontal: 25),
child: Container(
decoration: BoxDecoration(
color: Colors.grey[300],
border: Border.all(color: Colors.white),
borderRadius: BorderRadius.circular(12),
),
child: Padding(
padding: const EdgeInsets.only(left: 20),
child: TextFormField(
validator: (value) =>
value!.isEmpty ? "Enter Name" : null,
controller: _controllerName,
decoration: InputDecoration(
border: InputBorder.none, hintText: 'Name'),
),), ), ),
//Registration id
SizedBox(
height: 10,
),
Padding(
padding: const EdgeInsets.symmetric(horizontal: 25),
child: Container(
decoration: BoxDecoration(
color: Colors.grey[300],
border: Border.all(color: Colors.white),
borderRadius: BorderRadius.circular(12),
),
child: Padding(
padding: const EdgeInsets.only(left: 20),
child: TextFormField(
validator: (value) =>
value!.isEmpty ? "Enter Registration Id" : null,
controller: _controllerRid,
keyboardType: TextInputType.number,
decoration: InputDecoration(
border: InputBorder.none,
hintText: 'Registration Id'),
), ),),),
SizedBox(height: 10),
Padding(
padding: const EdgeInsets.symmetric(horizontal: 25),
child: IntlPhoneField(
controller: _controllerPhoneNo,
decoration: InputDecoration(labelText: 'Phone Number',
border: OutlineInputBorder(
borderSide: BorderSide(),
), ),
initialCountryCode: 'IN',
onChanged: (phone) {
print(phone.completeNumber);
}, ),),
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
value!.isEmpty ? "Enter email" : null,
decoration: InputDecoration(
border: InputBorder.none,
hintText: 'Email',
icon: Icon(
Icons.email,
),),
controller: _controllerEmail,
), ), ), ),
SizedBox(
height: 10
),
//Pasword
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
value!.isEmpty ? "Enter Password" : null,
obscureText: true,
decoration: InputDecoration(
border: InputBorder.none,
hintText: 'Password',
icon: Icon(
Icons.lock,
), ),
controller: _controllerPassword,
), ), ), ),
//Confirm Password
SizedBox(
height: 10,
),
Padding(
padding: const EdgeInsets.symmetric(horizontal: 25),
child: Container(decoration: BoxDecoration(
color: Colors.grey[200],
border: Border.all(color: Colors.white),
borderRadius: BorderRadius.circular(12),
),
child: Padding(
padding: const EdgeInsets.only(left: 20),
child: TextFormField(
validator: (value) {
if (value!.isEmpty) return 'Enter password';
if (value != _confirmPassword.text) return 'Not Match';
return null;
},
obscureText: true,
decoration: InputDecoration(
border: InputBorder.none,
hintText: 'Confirm Password',
icon: Icon(
Icons.lock,
), ),
controller: _confirmPassword,
), ), ), ),
//Batch
SizedBox(
height: 10,
),
Row(
children: [
Padding(
padding: const EdgeInsets.symmetric(horizontal: 25),
child: Container(decoration: BoxDecoration(
color: Colors.grey[200],
border: Border.all(color: Colors.white),
borderRadius: BorderRadius.circular(12),
),
child: Padding(
padding: const EdgeInsets.only(left: 20),
child: DropdownButton(
value: _value2,
items: batch.map((e) {
return DropdownMenuItem(
child: Text(e),
value: e,
);
}).toList(),
onChanged: (newvalue) {
setState(() {
_value2 = newvalue!;
});
}, ), ),),),
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
child: DropdownButton(value: _value1,
items: streams.map((e) {
return DropdownMenuItem(
child: Text(e),
value: e,
);
}).toList(),
onChanged: (newvalue) {
setState(() {
_value1 = newvalue!;
}); },), ), ), ), ], ),
//Batch
SizedBox(
height: 10,
),
SizedBox(
height: 10,
),
Padding(
padding: const EdgeInsets.symmetric(horizontal: 25),
child: Container(
decoration: BoxDecoration(
color: Colors.grey[200],
border: Border.all(color: Colors.white),
borderRadius: BorderRadius.circular(12),
),
child: Padding(padding: const EdgeInsets.only(left: 20),
child: TextFormField(
validator: (value) =>
value!.isEmpty ? "Enter College name" : null,
controller: _controllerClgName,
decoration: InputDecoration(
border: InputBorder.none,
hintText: 'College Name',
), ), ),), ),
//sign up button
SizedBox(height: 10),
Padding(
padding: const EdgeInsets.symmetric(horizontal: 25),
child: Container(
child: ElevatedButton(
onPressed: createUserWithEmailAndPassword,
style: ElevatedButton.styleFrom(
backgroundColor: Colors.blue,
fixedSize: Size(360, 50),
),
child: const Text(
'Sign Up',
style: TextStyle(
color: Colors.white,
fontSize: 17,
fontWeight: FontWeight.bold,
),),), ),),
SizedBox(height: 10,
),
Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Text(
'Already have a account!',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
TextButton(
child: Text('Log In'),
onPressed: () {
Navigator.pop(context);
}), ],
)
]),
),
),
),
);
}}
