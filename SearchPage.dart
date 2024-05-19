import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/models/chatRoomModel.dart';
import 'package:first_app/models/usermodel.dart';
import 'package:first_app/screens/chatRoomPage.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../models/firebaseHelper.dart';
class Search extends StatefulWidget {
final UserModel? userModel;
final User firebaseUser;
const Search(
{super.key, required this.userModel, required this.firebaseUser});
@override
State<Search> createState() => _SearchState();
}
TextEditingController searchController = TextEditingController();
String url = "";
class _SearchState extends State<Search> {
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
ChatRoomModel existingChatroom =
ChatRoomModel.fromMap(docData as Map<String, dynamic>);
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
},
);
await FirebaseFirestore.instance
.collection("chatrooms")
.doc(newChatroom.chatroomid)
.set(newChatroom.toMap());
chatRoom = newChatroom;log("New Chatroom Created!");
}
return chatRoom;
}
bool _isSearching = false;
String name = "";
Future<void> myval() async {
User? currentUser = FirebaseAuth.instance.currentUser;
UserModel? thisUserModel =
await FirebaseHelper.getUserModelById(currentUser!.uid);
setState(() {
url = thisUserModel!.profilepic.toString();
});
}
@override
void initState() {
myval();
}
Widget build(BuildContext context) {
return GestureDetector(
onTap: () => FocusScope.of(context).unfocus(),
child: WillPopScope(
onWillPop: () {
if (_isSearching) {
setState(() {
_isSearching = !_isSearching;});
return Future.value(false);
} else {
return Future.value(true);
}
},
child: Scaffold(
appBar: AppBar(
title: Center(child: Text('Search')),
),
body: SafeArea(
child: Container(
padding: EdgeInsets.symmetric(vertical: 40, horizontal: 40),
child: Column(
children: [
TextField(
// onTap: () => _isSearching = true,
controller: searchController,
decoration: const InputDecoration(
hintText: 'Search',
),
),
Container(
padding: EdgeInsets.symmetric(vertical: 10),
child: ElevatedButton(
child: const Text('Submit'),
onPressed: () {
setState(() {
_isSearching = !_isSearching;
});
},
),),
StreamBuilder(
stream: FirebaseFirestore.instance
.collection("users")
.where("fullname",
isEqualTo: searchController.text.trim())
.where('fullname',
isNotEqualTo: widget.userModel!.fullname)
.snapshots(),
builder: (context, snapshot) {
if (snapshot.connectionState == ConnectionState.active) {
if (snapshot.hasData) {
QuerySnapshot dataSnapshot =
snapshot.data as QuerySnapshot;
if (dataSnapshot.docs.isNotEmpty) {
Map<String, dynamic> userMap = dataSnapshot.docs[0]
.data() as Map<String, dynamic>;
UserModel searchedUser =
UserModel.fromMap(userMap);
return ListTile(
onTap: () async {
ChatRoomModel? chatRoomModel =
await getChatroomModel(searchedUser);
if (chatRoomModel != null) {
// ignore: use_build_context_synchronously
Navigator.push(context,
MaterialPageRoute(builder: (context) {
return chatRoomPage(
firebaseUser: widget.firebaseUser,targetUser: searchedUser,
userModel: widget.userModel,
chatRoom: chatRoomModel,
);
}));
}
},
leading: ClipRRect(
borderRadius: BorderRadius.circular(100),
child: CachedNetworkImage(
width:
MediaQuery.of(context).size.height * .10,
height:
MediaQuery.of(context).size.height * .10,
imageUrl: searchedUser.profilepic.toString(),
fit: BoxFit.cover,
placeholder: (context, url) => CircleAvatar(
backgroundColor: Colors.blue[600],
child: Icon(
Icons.person,
// size: 60,
color: Colors.yellow[700],
),
),
errorWidget: (context, url, error) =>
CircleAvatar(
backgroundColor: Colors.blue[600],
child: Icon(
Icons.person,
color: Colors.yellow[700],
),
),),
),
title: Text(searchedUser.fullname!),
subtitle: Text(searchedUser.batch!),
trailing: Icon(Icons.keyboard_arrow_right),
);
} else {
return const Text('No result found!');
}
} else if (snapshot.hasError) {
return const Text('No result found!');
} else {
return const Text('No result found!');
}
} else {
return const CircularProgressIndicator();
}
},
)
],
),
),
),
),
),
);
}
}
