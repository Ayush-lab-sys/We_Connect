import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/chatRoomModel.dart';
import '../models/firebaseHelper.dart';
import '../models/usermodel.dart';
import 'chatRoomPage.dart';
class chats extends StatefulWidget {
final UserModel? userModel;
final User firebaseUser;
const chats({Key? key, required this.userModel, required
this.firebaseUser})
: super(key: key);
@override
_chatsState createState() => _chatsState();
}
class _chatsState extends State<chats> {
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(centerTitle: true,
title: const Text(
"All Chats",
style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
),
),
body: SafeArea(
child: StreamBuilder(
stream: FirebaseFirestore.instance
.collection("chatrooms")
.where("participants.${widget.userModel!.uid}"
, isEqualTo: true)
.snapshots(),
builder: (context, snapshot) {
if (snapshot.connectionState == ConnectionState.active) {
if (snapshot.hasData) {
QuerySnapshot chatRoomSnapshot = snapshot.data as
QuerySnapshot;
return ListView.builder(
itemCount: chatRoomSnapshot.docs.length,
itemBuilder: (context, index) {
ChatRoomModel chatRoomModel =
ChatRoomModel.fromMap(
chatRoomSnapshot.docs[index].data()
as Map<String, dynamic>);
Map<String, dynamic> participants =
chatRoomModel.participants!;
List<String> participantKeys = participants.keys.toList();
participantKeys.remove(widget.userModel!.uid);return FutureBuilder(
future:
FirebaseHelper.getUserModelById(participantKeys[0]),
builder: (context, userData) {
if (userData.connectionState == ConnectionState.done) {
if (userData.data != null) {
UserModel targetUser = userData.data as UserModel;
return ListTile(
onTap: () {
Navigator.push(
context,
MaterialPageRoute(builder: (context) {
return chatRoomPage(
firebaseUser: widget.firebaseUser,
userModel: widget.userModel,
targetUser: targetUser,
chatRoom: chatRoomModel,
);
}),
);
},
leading: ClipRRect(
borderRadius: BorderRadius.circular(100),
child: CachedNetworkImage(
width:
MediaQuery.of(context).size.height * .10,
height:
MediaQuery.of(context).size.height * .10,
imageUrl: targetUser.profilepic.toString(),
fit: BoxFit.cover,
placeholder: (context, url) => CircleAvatar(backgroundColor: Colors.blue[600],
child: Icon(
Icons.person,
// size: 60,
color: Colors.yellow[700],
), ),
errorWidget: (context, url, error) =>
CircleAvatar(
backgroundColor: Colors.blue[600],
child: Icon(
Icons.person,
color: Colors.yellow[700],
), ), ), ),
title: Text(targetUser.fullname.toString()),
subtitle: (chatRoomModel.lastMessage.toString() !=
"")
? chatRoomModel.msgtype == "image"
? const Text("photo")
: Text(
chatRoomModel.lastMessage.toString())
: Text(
"Say hi to your new friend!",
style: TextStyle(
color: Theme.of(context)
.colorScheme
.secondary,
),), );
} else {
return Container(
child: const Text(
"Start Conversations",
style: TextStyle(fontSize: 25),),
);
}
} else {
return Container(
child: const Text(
"Start Conversations",
style: TextStyle(fontSize: 25),
),
); } }, ); }, );
} else if (snapshot.hasError) {
return Center(
child: Text(snapshot.error.toString()),
);
} else {
return const Center(
child: Text("No Chats"),
);
}
} else {
return const Center(
child: CircularProgressIndicator(),
); } },), ), );}}
