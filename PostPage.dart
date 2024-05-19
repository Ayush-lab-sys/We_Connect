import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as
firebase_storage;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../API.dart';
import '../models/firebaseHelper.dart';
import '../models/usermodel.dart';
class Post extends StatefulWidget {
const Post({super.key});
@override
State<Post> createState() => _PostState();
}
File? _image;
TextEditingController titleController = TextEditingController();
TextEditingController descriptionController = TextEditingController();
final picker = ImagePicker();
class _PostState extends State<Post> {
bool showSpinner = false;final FirebaseAuth _auth = FirebaseAuth.instance;
final postRef = FirebaseDatabase.instance.ref().child('Posts');
firebase_storage.FirebaseStorage storage =
firebase_storage.FirebaseStorage.instance;
Future<void> _pickImage(ImageSource source) async {
final pickedFile = await picker.pickImage(source: source,
imageQuality: 35);
setState(() {
if (pickedFile != null) {
_image = File(pickedFile.path);
} else {
print('null value');
}
});
}
void showPhotoOptions() {
showDialog(
context: context,
builder: (context) {
return AlertDialog(
title: const Text("Upload Picture"),
content: Column(
mainAxisSize: MainAxisSize.min,
children: [
ListTile(
onTap: () {
Navigator.pop(context);
_pickImage(ImageSource.gallery);
},leading: const Icon(Icons.photo_album),
title: const Text("Select from Gallery"),
),
ListTile(
onTap: () {
Navigator.pop(context);
_pickImage(ImageSource.camera);
},
leading: const Icon(Icons.camera_alt),
title: const Text("Take a photo"),
), ], ),); }); }
@override
Widget build(BuildContext context) {
return ModalProgressHUD(
inAsyncCall: showSpinner,
child: Scaffold(
appBar: AppBar(
title: const Text(
"Blog",
style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
),
centerTitle: true,
),
body: SingleChildScrollView(
child: Padding(
padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
child: Column(
children: [
InkWell(
onTap: () {
showPhotoOptions();},
child: Center(
child: Container(
height: MediaQuery.of(context).size.height * .2,
width: MediaQuery.of(context).size.width * 1,
child: _image != null
? ClipRect(
child: Image.file(
_image!.absolute,
width: 100,
height: 100,
fit: BoxFit.fill,
),
)
: Container(
decoration: BoxDecoration(
color: Colors.grey.shade200,
borderRadius: BorderRadius.circular(10)),
width: 100,
height: 100,
child: const Icon(
Icons.camera_alt,
color: Colors.blue,
), ), ), ), ),
const SizedBox(
height: 30,
),
Form(
child: Column(
children: [
TextFormField(
controller: titleControllerdecoration: const InputDecoration(
labelText: 'title',
hintText: 'enter post title',
border: OutlineInputBorder(),
hintStyle: TextStyle(
color: Colors.grey, fontWeight: FontWeight.normal),
labelStyle: TextStyle(
color: Colors.grey, fontWeight: FontWeight.normal),
), ),
const SizedBox(
height: 30,
),
TextFormField(
controller: descriptionController,
minLines: 1,
maxLines: 3,
decoration: const InputDecoration(
labelText: 'Description',
hintText: 'Enter Description',
border: OutlineInputBorder(),
hintStyle: TextStyle(
color: Colors.grey, fontWeight: FontWeight.normal),
labelStyle: TextStyle(
color: Colors.grey, fontWeight: FontWeight.normal),
), ), ], )),
const SizedBox(
height: 30,
),
ElevatedButton(
onPressed: () async {
setState(() {
showSpinner = true;});
try {
int date = DateTime.now().microsecondsSinceEpoch;
firebase_storage.Reference ref = firebase_storage
.FirebaseStorage.instance
.ref('blogposts');
UploadTask uploadTask = ref
.child("${date.toString()}")
.putFile(_image!.absolute);
await Future.value(uploadTask);
var newurl = await ref.getDownloadURL();
final User? user = _auth.currentUser;
UserModel? thisUserModel =
await FirebaseHelper.getUserModelById(user!.uid);
postRef.child('Post List').child(date.toString()).set({
'pId': date.toString(),
'pImage': newurl.toString(),
'pTime': date.toString(),
'pTitle': titleController.text.toString(),
'pDescription': descriptionController.text.toString(),
'uemail': user.email.toString(),
'uid': user.uid.toString(),
'pName': thisUserModel!.fullname.toString()
}).then((value) {
API().toastMessages('Post published');
setState(() {
showSpinner = false;
});}).onError((error, stackTrace) {
API().toastMessages(error.toString());
setState(() {
showSpinner = false;
}); });
} catch (e) {
setState(() {
showSpinner = true;
});
API().toastMessages(e.toString());
} },
// ignore: sort_child_properties_last
child: const Text(
'Post',
style: TextStyle(
color: Colors.white,
fontSize: 17,
fontWeight: FontWeight.bold,
),
),
style: ElevatedButton.styleFrom(
backgroundColor: Colors.blue,
fixedSize: const Size(360, 50),
), ), ], ),), ),), ); }}
