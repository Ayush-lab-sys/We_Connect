import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/firebaseHelper.dart';
import '../models/usermodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'editProfile.dart';
class CompleteProfile extends StatefulWidget {
final UserModel? userModel;
final User? firebaseUser;
const CompleteProfile(
{Key? key, required this.userModel, required this.firebaseUser})
: super(key: key);
@override
_CompleteProfileState createState() => _CompleteProfileState();
}
String photoUrl = "";
class _CompleteProfileState extends State<CompleteProfile> {
File? imageFile;
String name = "";String batch = "";
String stream = "";
final picker = ImagePicker();
Future<void> _pickImage(ImageSource source) async {
final pickedFile = await picker.pickImage(source: source,
imageQuality: 55);
setState(() {
if (pickedFile != null) {
imageFile = File(pickedFile.path);
_uploadImage();
} else {}
});
}
Future<void> _uploadImage() async {
UserModel? thisUserModel;
User? currentUser = FirebaseAuth.instance.currentUser;
thisUserModel = await
FirebaseHelper.getUserModelById(currentUser!.uid);
UploadTask uploadTask = FirebaseStorage.instance
.ref("profilepictures")
.child(widget.userModel!.uid.toString())
.putFile(imageFile!);
TaskSnapshot snapshot = await uploadTask;
String? imageUrl = await snapshot.ref.getDownloadURL();await FirebaseFirestore.instance
.collection("users")
.doc(currentUser.uid)
.update({'profilepic': imageUrl});
}
Future<void> value() async {
User? currentUser = FirebaseAuth.instance.currentUser;
UserModel? thisUserModel =
await FirebaseHelper.getUserModelById(currentUser!.uid);
setState(() {
name = thisUserModel!.fullname.toString();
batch = thisUserModel.batch.toString();
stream = thisUserModel.stream.toString();
if (thisUserModel.profilepic.toString() != null) {
photoUrl = thisUserModel.profilepic.toString();
print(photoUrl);
}
});
// return thisUserModel!.fullname.toString();
}
void showPhotoOptions() {
showDialog(
context: context,
builder: (context) {
return AlertDialog(
title: const Text("Upload Profile Picture"),
content: Column(
mainAxisSize: MainAxisSize.min,children: [
ListTile(
onTap: () {
Navigator.pop(context);
_pickImage(ImageSource.gallery);
},
leading: const Icon(Icons.photo_album),
title: const Text("Select from Gallery"),
),
ListTile(
onTap: () {
Navigator.pop(context);
_pickImage(ImageSource.camera);
},
leading: const Icon(Icons.camera_alt),
title: const Text("Take a photo"),
), ], ),); });}
@override
void initState() {
// Call your async method here
super.initState();
value();
}
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
leading: IconButton(
onPressed: () {
Navigator.pop(context);},
icon: const Icon(Icons.arrow_left),
iconSize: 40,
),
centerTitle: true,
automaticallyImplyLeading: false,
title: const Text(
"Profile",
style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
),
),
body: SingleChildScrollView(
child: Container(
padding: const EdgeInsets.all(20),
child: Column(children: [
Stack(children: [
const SizedBox(
width: 130,
height: 140,
),
ClipRRect(
borderRadius: BorderRadius.circular(100),
child: CachedNetworkImage(
width: MediaQuery.of(context).size.height * .2,
height: MediaQuery.of(context).size.height * .2,
imageUrl: photoUrl,
fit: BoxFit.cover,
placeholder: (context, url) => CircleAvatar(
backgroundColor: Colors.blue[600],
child: Icon(
Icons.person,
size: 60,color: Colors.yellow[700],
),
),
errorWidget: (context, url, error) => CircleAvatar(
backgroundColor: Colors.blue[600],
child: Icon(
Icons.person,
size: 60,
color: Colors.yellow[700],
), ), )),
Positioned(
bottom: 0,
right: 0,
child: Container(
width: 35,
height: 35,
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(100),
color: Colors.yellow[600]),
child: InkWell(
onTap: showPhotoOptions,
child: const Icon(
Icons.edit_outlined,
color: Color.fromARGB(255, 0, 0, 0),
size: 20,
), ), ), ), ]),
const SizedBox(
height: 10,
),
Text(
name,
style:const TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
),
Text(
stream,
style:
const TextStyle(fontWeight: FontWeight.w400, fontSize: 19),
),
Text(
batch,
style:
const TextStyle(fontWeight: FontWeight.w400, fontSize: 19),
),
const SizedBox(
height: 20,
),
SizedBox(
width: 200,
child: ElevatedButton(
onPressed: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => const editProfile()));
},
style: ElevatedButton.styleFrom(
backgroundColor: Colors.yellow[300],
side: BorderSide.none,
shape: const StadiumBorder()),
child: const Text(
"Edit Profile",
style: TextStyle(
color: Colors.black,fontWeight
: FontWeight
.bold
,
fontSize
: 15),
),
)),
const SizedBox
(
height
: 30
,
),
const Divider(),
const SizedBox
(
height
: 10
,
),
ProfileMenuWidget
(
title
: 'Message me'
,
icon
: Icons
.message_outlined
,
onpress
: () {},
),
const SizedBox
(
height
: 10
,
),
ProfileMenuWidget
(
title
: 'My Posts'
,
icon
: Icons
.post_add_rounded
,
onpress
: () {},
),
const SizedBox
(
height
: 10
,
),
ProfileMenuWidget
(
title
: 'Log Out'
,
icon
: Icons
.logout_sharp
,
onpress
: () {},
) ]), ), )); }}class ProfileMenuWidget extends StatelessWidget {
const ProfileMenuWidget({
super.key,
required this.title,
required this.icon,
required this.onpress,
this.endIcon = true,
this.txtcolor,
});
final String title;
final IconData icon;
final VoidCallback onpress;
final bool endIcon;
final Color? txtcolor;
@override
Widget build(BuildContext context) {
return ListTile(
leading: Container(
width: 40,
height: 40,
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(100),
color: Colors.grey.withOpacity(0.4),
),
child: Icon(
icon,
size: 22,
color: Colors.blue,
),
),title: Text(
title,
style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
),
trailing: endIcon
? Container(
width: 30,
height: 30,
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(100),
),
child: const Icon(
Icons.arrow_right,
size: 30,
color: Colors.blue,
),
)
: null,
);
}
}
