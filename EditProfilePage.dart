import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/models/usermodel.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../API.dart';
import '../main.dart';
import '../models/chatRoomModel.dart';
import '../models/firebaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
class editProfile extends StatefulWidget {
final UserModel? userModel;
const editProfile({super.key, this.userModel});
@override
State<editProfile> createState() => _editProfileState();
}
class _editProfileState extends State<editProfile> {
final streams = ['BCA', 'BBE', 'BBA', 'BCP', 'BJMC'];
final batch = [ '2020-2023', '2019-2022', '2018-2021',
'2017-2020', '2016-2019', '2015-2018' ];
bool showSpinner = false;
String _value1 = "BCA";
String _value2 = "2020-2023";String name = "";
String rid = "";
String pno = "";
String email = "";
String clgname = "";
String profile = "";
final TextEditingController _controllerEmail = TextEditingController();
final TextEditingController _controllerName = TextEditingController();
final TextEditingController _controllerRid = TextEditingController();
final TextEditingController _controllerPhoneNo =
 TextEditingController();
final TextEditingController _controllerClgName =
 TextEditingController();
final streamSelected = TextEditingController();
String? errorMessage = '';
Future<ChatRoomModel?> getChatroomModel(UserModel targetUser)
 async {
ChatRoomModel? chatRoom;
QuerySnapshot snapshot = await FirebaseFirestore.instance
.collection("chatrooms")
.where("participants.${widget.userModel!.uid}"
, isEqualTo: true)
.where("participants.${targetUser.uid}"
, isEqualTo: true)
.get();
if (snapshot.docs.isNotEmpty) {
// Fetch the existing one
var docData = snapshot.docs[0].data();
ChatRoomModel existingChatroom =ChatRoomModel.fromMap(docData as Map<String, dynamic>);
chatRoom = existingChatroom;
} else {
// Create a new one
ChatRoomModel newChatroom = ChatRoomModel(
chatroomid: uuid.v1(),
lastMessage: ""
,
msgtype: ""
,
participants: {
widget.userModel!.uid.toString(): true,
targetUser.uid.toString(): true,
}, );
await FirebaseFirestore.instance
.collection("chatrooms")
.doc(newChatroom.chatroomid)
.set(newChatroom.toMap());
chatRoom = newChatroom;
}
return chatRoom;
}
Future<void> value() async {
User? currentUser = FirebaseAuth.instance.currentUser;
UserModel? thisUserModel =
await FirebaseHelper.getUserModelById(currentUser!.uid);
setState(() {
name = thisUserModel!.fullname.toString();
rid = thisUserModel.rid.toString();
clgname = thisUserModel.clg_name.toString();pno = thisUserModel.phone_no.toString();
email = thisUserModel.email.toString();
profile = thisUserModel.profilepic.toString();
});
_controllerName.text = name;
_controllerRid.text = rid;
_controllerEmail.text = email;
_controllerPhoneNo.text = pno;
_controllerClgName.text = clgname;
}
final _formkey = GlobalKey<FormState>();
void updateuser() async {
if (_formkey.currentState!.validate()) {
setState(() {
showSpinner = true;
});
User? currentUser = FirebaseAuth.instance.currentUser;
await FirebaseFirestore.instance
.collection("users")
.doc(currentUser!.uid)
.update({
'fullname': _controllerName.text.trim(),
'rid': _controllerRid.text.trim(),
'phone_no': _controllerPhoneNo.text,
'email': _controllerEmail.text.trim(),
'clg_name': _controllerClgName.text.trim(),
'batch': _value2,'stream': _value1,
}).then((value) {
setState(() {
showSpinner = false;
});
// print('New user created');
API().toastMessages("Profile Successfully Edited");
}); }}
@override
void initState() {
super.initState();
value();
_controllerName.text = name;
_controllerRid.text = rid;
_value1 = streams[0];
_value2 = batch[0];
}
Widget build(BuildContext context) {
return ModalProgressHUD(
inAsyncCall: showSpinner,
child: Scaffold(
appBar: AppBar(
leading: IconButton(
onPressed: () {
Navigator.pop(context);
},
icon: const Icon(Icons.arrow_left),
iconSize: 40,
),centerTitle: true,
automaticallyImplyLeading: false,
title: const Text(
"Edit Profile",
style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
), ),
backgroundColor: Colors.grey[100],
body: Form(
key: _formkey,
child: SingleChildScrollView(
child:
Column(crossAxisAlignment: CrossAxisAlignment.start,
children: [
//Name
const SizedBox(
height: 30,
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
decoration: const InputDecoration(border: InputBorder.none,
), ), ), ),),
//Registration id
const SizedBox(
height: 30,
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
decoration: const InputDecoration(
border: InputBorder.none,
), ), ), ), ),
const SizedBox(height: 30),
Padding(
padding: const EdgeInsets.symmetric(horizontal: 25),
child: IntlPhoneField(
controller: _controllerPhoneNo,
decoration: InputDecoration(
labelText: pno,border: const OutlineInputBorder(
borderSide: BorderSide(),
),),
initialCountryCode: 'IN',
onChanged: (phone) {},
), ),
// Email
const SizedBox(
height: 20,
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
validator: (value) =>
value!.isEmpty ? "Enter email" : null,
decoration: InputDecoration(
border: InputBorder.none,
hintText: email,
icon: const Icon(
Icons.email,
),),
controller: _controllerEmail,
),),), ),const SizedBox(
height: 30,
),
Row(
children: [
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
child: DropdownButton(
value: _value2,
items: batch.map((e) {
return DropdownMenuItem(
value: e,
child: Text(e),
);
}).toList(),
onChanged: (newvalue) {
setState(() {
_value2 = newvalue!;
}); }, ),), ), ),
Padding(
padding: const EdgeInsets.symmetric(horizontal: 25),
child: Container(
decoration: BoxDecoration(color: Colors.grey[200],
border: Border.all(color: Colors.white),
borderRadius: BorderRadius.circular(12),
),
child: Padding(
padding: const EdgeInsets.only(left: 20),
child: DropdownButton(
value: _value1,
items: streams.map((e) {
return DropdownMenuItem(
value: e,
child: Text(e),
);
}).toList(),
onChanged: (newvalue) {
setState(() {
_value1 = newvalue!;
}); },), ), ),), ],
), //Batch
const SizedBox(
height: 20,
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
hintText: clgname,
), ), ),), ),
//sign up button
const SizedBox(height: 30),
Padding(
padding: const EdgeInsets.symmetric(horizontal: 25),
child: Container(
child: ElevatedButton(
onPressed: () {
updateuser();
},
style: ElevatedButton.styleFrom(
backgroundColor: Colors.blue,
fixedSize: const Size(360, 50),
),
child: const Text(
'Save Changes',
style: TextStyle(
color: Colors.white,
fontSize: 17,
fontWeight: FontWeight.bold,
),
),
),),
),
const SizedBox(
height: 10,
),
]),
),
),
),
);
}
