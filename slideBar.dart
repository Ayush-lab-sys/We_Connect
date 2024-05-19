import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/models/firebaseHelper.dart';
import 'package:first_app/screens/help.dart';
import './screens/profile.dart';
import 'package:flutter/material.dart';
import 'authentication/auth.dart';
import 'models/usermodel.dart';
class DrawerScreen extends StatefulWidget {
final UserModel? userModel;
final User? firebaseUser;
const DrawerScreen(
{Key? key, required this.userModel, required this.firebaseUser})
: super(key: key);
@override
State<DrawerScreen> createState() => _DrawerScreenState();
}
class _DrawerScreenState extends State<DrawerScreen> {
String name = "";
String url = "";
String batch = "";
final User? user = Auth().currentUser;Future<void> signOut() async {
await Auth().signOut();
}
Future<void> value() async {
User? currentUser = FirebaseAuth.instance.currentUser;
UserModel? thisUserModel =
await FirebaseHelper.getUserModelById(currentUser!.uid);
setState(() {
name = thisUserModel!.fullname.toString();
batch = thisUserModel.batch.toString();
url = thisUserModel.profilepic.toString();
});
}
final List drawerMenuListname = const [
{
"leading": Icon(
Icons.account_circle,
color: Color.fromARGB(255, 81, 140, 203),
size: 30,
),
"title": "Profile",
"trailing": Icon(
Icons.chevron_right,
),
"action_id": 1,
},
{
"leading": Icon(Icons.help,
color: Color.fromARGB(255, 81, 140, 203),
size: 30,
),
"title": "Help",
"trailing": Icon(Icons.chevron_right),
"action_id": 3,
},
{
"leading": Icon(
Icons.exit_to_app,
color: Color.fromARGB(255, 81, 140, 203),
size: 30,
),
"title": "Log Out",
"trailing": Icon(Icons.chevron_right),
"action_id": 5,
},
];
@override
void initState() {
// Call your async method here
super.initState();
value();
}
Widget build(BuildContext context) {
return SafeArea(
child: SizedBox(
width: 280,
child: Drawer(child: ListView(
children: [
Container(
padding: EdgeInsets.symmetric(vertical: 10),
child: ListTile(
leading: ClipRRect(
borderRadius: BorderRadius.circular(100),
child: CachedNetworkImage(
width: MediaQuery.of(context).size.height * .10,
height: MediaQuery.of(context).size.height * .10,
imageUrl: url,
fit: BoxFit.cover,
placeholder: (context, url) => CircleAvatar(
backgroundColor: Colors.blue[600],
child: Icon(
Icons.person,
// size: 60,
color: Colors.yellow[700],
),
),
errorWidget: (context, url, error) => CircleAvatar(
backgroundColor: Colors.blue[600],
child: Icon(
Icons.person,
color: Colors.yellow[700],
),
),
),
),
title: Text(
name,
style: const TextStyle(color: Colors.black,
),
),
subtitle: Text(
batch,
style: const TextStyle(
color: Colors.black,
),
),
),
),
const SizedBox(
height: 15,
),
const SizedBox(
height: 1,
),
...drawerMenuListname.map((sideMenuData) {
return ListTile(
leading: sideMenuData['leading'],
title: Text(
sideMenuData['title'],
style: const TextStyle(
fontSize: 15,
fontWeight: FontWeight.bold,
fontFamily: AutofillHints.addressCity,
),
),
trailing: sideMenuData['trailing'],
onTap: () {
Navigator.pop(context);
if (sideMenuData['action_id'] == 1) {Navigator.of(context).push(
MaterialPageRoute(
builder: (context) => CompleteProfile(
userModel: widget.userModel,
firebaseUser: widget.firebaseUser,
),
),
);
} else if (sideMenuData['action_id'] == 5) {
signOut();
} else if (sideMenuData['action_id'] == 3) {
Navigator.of(context).push(MaterialPageRoute(
builder: (context) => const Help(),
));
}
},
);
}).toList(),
],
),
),
),
);
}}
