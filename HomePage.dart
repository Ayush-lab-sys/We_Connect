import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import '../authentication/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/firebaseHelper.dart';
import '../models/usermodel.dart';
import '../sidebar.dart';
var g, h;
class Home extends StatefulWidget {
final UserModel? userModel;
final User? firebaseUser;
const Home({Key? key, required this.userModel, required
this.firebaseUser});
@override
State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
String name = "";
String batch = "";final User? user = Auth().currentUser;
final dbRef = FirebaseDatabase.instance.ref().child('Posts');
Future<void> value() async {
User? currentUser = FirebaseAuth.instance.currentUser;
UserModel? thisUserModel =
await FirebaseHelper.getUserModelById(currentUser!.uid);
setState(() {
batch = thisUserModel!.batch.toString();
});
}
void initState() {
super.initState();
value();
}
@override
Widget build(BuildContext context) {
return Scaffold(
drawer: DrawerScreen(
userModel: widget.userModel,
firebaseUser: user,
),
appBar: AppBar(
title: Text('We connect'),
),
backgroundColor: Color(0xfff9fafc),
body: Padding(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
child: Column(
mainAxisAlignment: MainAxisAlignment.start,
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Expanded(
child: FirebaseAnimatedList(
query: dbRef.child('Post List'),
itemBuilder: (BuildContext context, DataSnapshot snapshot,
animation, index) {
var v = (snapshot.value as Map)['pDescription'];
var i = (snapshot.value as Map)['pName'];
g = v.replaceAll(
RegExp("{|}|uid: |pDescription: "), "");
h = i.replaceAll(RegExp("{|}|uid: |pName: "), "");
name = h;
return Padding(
padding: const EdgeInsets.all(10.0),
child: Container(
decoration: BoxDecoration(
color: Colors.grey.shade100,
borderRadius: BorderRadius.circular(10.0)),
child: Container(
child: Column(
mainAxisAlignment: MainAxisAlignment.start,
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Padding(
padding:
const EdgeInsets.only(bottom: 10),child: Column(
mainAxisAlignment:
MainAxisAlignment.spaceEvenly,
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Text(
name,
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.w700,
backgroundColor:
Colors.blue[100]),
),
Padding(
padding: const EdgeInsets.only(
top: 3, bottom: 7),
child: Text(
batch,
style: TextStyle(
fontSize: 12,
fontWeight: FontWeight.bold,
backgroundColor:
Colors.orange[100]),
), ) ], ), ),
ClipRRect(
borderRadius: BorderRadius.circular(10),
child: FadeInImage(
fit: BoxFit.cover,
width:
MediaQuery.of(context).size.width *1,
height:
MediaQuery.of(context).size.height *
.25,
placeholder: const AssetImage(
'images/scree.png'),
image: NetworkImage(
(snapshot.value as Map)['pImage']),
), ),
const SizedBox(
height: 10,
),
Padding(
padding: const EdgeInsets.symmetric(
horizontal: 10),
child: Text(
(snapshot.value as Map)['pTitle'],
style: const TextStyle(
fontSize: 15,
fontWeight: FontWeight.bold),
), ),
Padding(
padding: const EdgeInsets.symmetric(
horizontal: 10),
child: ReadMoreText(
g,
trimLength: 100,
trimMode: TrimMode.Length,
trimCollapsedText: ' see more',
trimExpandedText: ' see less',
lessStyle: const TextStyle(color: Colors.blue,
fontSize: 13,
fontWeight: FontWeight.bold),
moreStyle: const TextStyle(
color: Colors.blue,
fontSize: 13,
fontWeight: FontWeight.bold),
))
],
),
),
));
})),
],
),
));
}
}
