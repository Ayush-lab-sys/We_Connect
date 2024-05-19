//Login.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../API.dart';
import '../models/usermodel.dart';
import '../screens/Home.dart';
import 'signUp.dart';
import 'package:flutter/material.dart';
import 'forgotScreen.dart';
class login extends StatefulWidget {
const login({super.key});
@override
State<login> createState() => _loginState();
}
final _formkey = GlobalKey<FormState>();
// ignore: camel_case_types
class _loginState extends State<login> {
final TextEditingController _controllerEmail = TextEditingController();
final TextEditingController _controllerPassword =
TextEditingController();
@override
String? errorMessage = '';
bool isLogin = true;
User? currentUser = FirebaseAuth.instance.currentUser;
Future<void> signInWithEmailAndPassword() async {
if (_formkey.currentState!.validate()) {
setState(() {
showSpinner = true;
});
UserCredential? credential;
try {
credential = await
FirebaseAuth.instance.signInWithEmailAndPassword(
email: _controllerEmail.text.trim(),
password: _controllerPassword.text.trim(),
);
} on FirebaseAuthException catch (e) {
API().toastMessages(e.toString());
setState(() {
showSpinner = false;
errorMessage = e.message;
});
if (credential != null) {
setState(() {
showSpinner = false;
API().toastMessages("User Login Successfull");
});
String uid = credential.user!.uid;
DocumentSnapshot userData = await FirebaseFirestore.instance
.collection('users')
.doc(uid)
.get();
UserModel userModel =
UserModel.fromMap(userData.data() as Map<String, dynamic>);
// ignore: use_build_context_synchronously
Navigator.pushReplacement(
context,
MaterialPageRoute(builder: (context) {
return Home( userModel: userModel,
firebaseUser: currentUser,
); }),);} } }}
bool showSpinner = false;
@override
Widget build(BuildContext context) {
return ModalProgressHUD(
inAsyncCall: showSpinner,
child: Scaffold(
backgroundColor: Colors.grey[300],
body: SafeArea(
child: Center(
child: Form(
key: _formkey,
child: SingleChildScrollView(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Container(
width: 100,
child: Image.network(
'https://i.postimg.cc/B6Rc7VBw/motionslowlogo-Adobe-Express.gif'), ),
const SizedBox(
height: 20,
),
//Hello again!
const Text(
'Hello Again!',
style:
TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
),
SizedBox(height: 10),
const Text(
'Welcome back, you\'ve been missed!',
style: TextStyle(fontSize: 20),
),
const SizedBox(
height: 50,
),
//Email Field
Padding( padding: const EdgeInsets.symmetric(horizontal: 25),
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
Icons.email,),),
controller: _controllerEmail, ), ), ), ),
//Password textfield
const SizedBox(
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
child: Padding(
padding: const EdgeInsets.only(left: 20),
child: TextFormField(
obscureText: true,
validator: (value) => value!.length < 6
? "Enter a password of more than 6 charaacter"
: null,
decoration: const InputDecoration(
border: InputBorder.none,
hintText: 'Password',
icon: Icon(
Icons.lock,
),
), controller: _controllerPassword, ),), ), ),
Padding(
padding: const EdgeInsets.only(top: 10.0, bottom: 30),
child: InkWell(
onTap: () { Navigator.push( context,
MaterialPageRoute(
builder: (context) => forgotScreen()));
},
child: const Align(
alignment: Alignment.center,
child: Text(
'forgot password',
style: TextStyle(
color: Colors.blue,
fontSize: 15,
fontWeight: FontWeight.w500),
)), ), ),
//sign in button
SizedBox(height: 10),
Padding(
padding: const EdgeInsets.symmetric(horizontal: 25),
child: Container(
child: ElevatedButton(
onPressed: signInWithEmailAndPassword,
style: ElevatedButton.styleFrom(
backgroundColor: Colors.blue,
fixedSize: const Size(360, 50), ),
child: const Text(
'Sign In',
style: TextStyle(
color: Colors.white,
fontSize: 17,
fontWeight: FontWeight.bold, ), ), ), ), ),
const SizedBox(
height: 20, ),
TextButton(
child: const Text('Register Now'),
onPressed: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => const signup()),
);
}),
],
)],
),)
,),),),
),);}}
