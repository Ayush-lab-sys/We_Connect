import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_app/models/MessagwModel.dart';
import 'package:first_app/models/chatRoomModel.dart';
import 'package:first_app/screens/main_page.dart';
import 'package:first_app/screens/view_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import '../main.dart';
import '../models/firebaseHelper.dart';
import '../models/usermodel.dart';
class chatRoomPage extends StatefulWidget {
final UserModel targetUser;
final ChatRoomModel chatRoom;
final UserModel? userModel;
final User firebaseUser;
const chatRoomPage({
super.key,
required this.targetUser,required this.chatRoom,
required this.userModel,
required this.firebaseUser,
});
@override
State<chatRoomPage> createState() => _chatRoomPageState();
}
class _chatRoomPageState extends State<chatRoomPage> {
void getpages() async {
User? currentUser = FirebaseAuth.instance.currentUser;
UserModel? userModel =
await FirebaseHelper.getUserModelById(currentUser!.uid);
// ignore: use_build_context_synchronously
Navigator.pushReplacement(
context,
MaterialPageRoute(builder: (context) {
return MainPage();
}), ); }
TextEditingController MessageController = TextEditingController();
bool _showEmoji = false;
bool _isUploading = false;
String msgtype = "";
Future<void> sendChatImage(File file) async {
//getting image file extension
UserModel? thisUserModel;
User? currentUser = FirebaseAuth.instance.currentUser;
thisUserModel = await
FirebaseHelper.getUserModelById(currentUser!.uid);UploadTask uploadTask = FirebaseStorage.instance
.ref("images")
.child(thisUserModel!.uid.toString())
.putFile(file);
TaskSnapshot snapshot = await uploadTask;
String? imageUrl = await snapshot.ref.getDownloadURL();
//updating image in firestore database
sendMessage(imageUrl, "image");
}
void sendMessage(String message, String tp) async {
String msg = message;
MessageController.clear();
MessageModel newMesssage = MessageModel(
messageid: uuid.v1(),
createdon: DateTime.now(),
sender: widget.userModel!.uid,
text: msg,
seen: false,
type: tp);
FirebaseFirestore.instance
.collection('chatrooms')
.doc(widget.chatRoom.chatroomid)
.collection('Messages')
.doc(newMesssage.messageid)
.set(newMesssage.toMap());
widget.chatRoom.lastMessage = msg;
widget.chatRoom.msgtype = tp;
CollectionReference collection =FirebaseFirestore.instance.collection("chatrooms");
DocumentReference document =
collection.doc(widget.chatRoom.chatroomid);
document.update(widget.chatRoom.toMap());
}
@override
Widget build(BuildContext context) {
return GestureDetector(
onTap: () => FocusScope.of(context).unfocus(),
child: WillPopScope(
onWillPop: () {
if (_showEmoji) {
setState(() => _showEmoji = !_showEmoji);
return Future.value(false);
} else {
return Future.value(true);
} },
child: Scaffold(
appBar: AppBar(
title: InkWell(
onTap: () => Navigator.push(
context,
MaterialPageRoute(
builder: (_) =>
ViewProfileScreen(user: widget.targetUser))),
child: Row(
children: [
ClipRRect(
borderRadius: BorderRadius.circular(100),
child: CachedNetworkImage(
width: MediaQuery.of(context).size.height * .08,height: MediaQuery.of(context).size.height * .08,
imageUrl: widget.targetUser.profilepic.toString(),
fit: BoxFit.fill,
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
), ), ), ),
const SizedBox(
width: 10,
),
Text(widget.targetUser.fullname.toString())
], ), ), ),
body: SafeArea(
child: Container(
child: Column(
children: [
Expanded(
child: Container(
padding: const EdgeInsets.symmetric(horizontal: 10),
child: StreamBuilder(
stream: FirebaseFirestore.instancecollection("chatrooms")
.doc(widget.chatRoom.chatroomid)
.collection("Messages")
.orderBy("createdon", descending: true)
.snapshots(),
builder: (context, snapshot) {
if (snapshot.connectionState ==
ConnectionState.active) {
if (snapshot.hasData) {
QuerySnapshot dataSnapshot =
snapshot.data as QuerySnapshot;
return ListView.builder(
reverse: true,
itemCount: dataSnapshot.docs.length,
itemBuilder: (context, index) {
MessageModel currentMessage =
MessageModel.fromMap(
dataSnapshot.docs[index].data()
as Map<String, dynamic>);
bool isme = currentMessage.sender ==
widget.userModel!.uid;
return InkWell(
onLongPress: () {
msgtype = currentMessage.type!;
_showBottomSheet(
isme,
currentMessage.text,
currentMessage.messageid,
currentMessage.text);
},child: Row(
mainAxisAlignment: isme
? MainAxisAlignment.end
: MainAxisAlignment.start,
children: [
Container(
padding: EdgeInsets.all(
currentMessage.type == ""
? MediaQuery.of(context)
.size
.width *
.03
: MediaQuery.of(context)
.size
.width *
.03),
margin: EdgeInsets.symmetric(
horizontal: MediaQuery.of(context)
.size
.width *
.04,
vertical: MediaQuery.of(context)
.size
.height *
.01),
decoration: BoxDecoration(
color: (currentMessage.sender ==
widget.userModel!.uid)
? const Color.fromARGB(
255, 218, 255, 176)
: const Color.fromARGB(
255, 221, 245, 255),border: Border.all(
color: Colors.lightGreen),
//making borders curved
borderRadius:
const BorderRadius.only(
topLeft:
Radius.circular(30),
topRight:
Radius.circular(30),
bottomLeft:
Radius.circular(30))),
child: currentMessage.type != "image"
? Text(
currentMessage.text.toString(),
style: const TextStyle(
color: Colors.black87,
fontSize: 15),
)
: Padding(
padding:
const EdgeInsets.all(8.0),
child: ClipRRect(
borderRadius:
BorderRadius.circular(15),
child: CachedNetworkImage(
width:
MediaQuery.of(context)
.size
.height *
.25,
height:
MediaQuery.of(context).size .height *.25,
imageUrl: currentMessage
.text
.toString(),
placeholder:
(context, url) =>
const Padding(
padding:
EdgeInsets.all(8.0),
child:
CircularProgressIndicator(
strokeWidth: 2),
),
errorWidget: (context, url,
error) =>
const Icon(Icons.image,
size: 70),
), ), ),),], ), ); }, );
} else if (snapshot.hasError) {
return const Center(
child: Text(
"An error occured! Please check your internet
connection."),
);
} else {
return const Center(
child: Text('Say Hii! 👋'
,
style: TextStyle(fontSize: 20)),
);
}
} else {
return Center(child: CircularProgressIndicator(), ); } },),),
),
Container(
color: Colors.grey[200],
padding: const EdgeInsets.symmetric(
horizontal: 15,
vertical: 5,
),
child: Row(
children: [
//emoji button
IconButton(
onPressed: () {
FocusScope.of(context).unfocus();
setState(() => _showEmoji = !_showEmoji);
},
icon: const Icon(Icons.emoji_emotions,
color: Colors.blueAccent, size: 25)),
Flexible(
fit: FlexFit.loose,
child: TextField(
controller: MessageController,
maxLines: null,
onTap: () {
if (_showEmoji) {
setState(() => _showEmoji = !_showEmoji);
}
;
},
decoration: const InputDecoration(
border: InputBorder.none,
hintText: "Enter message"),)),
IconButton(
icon: const Icon(Icons.image,
color: Colors.blueAccent, size: 26),
onPressed: () async {
final ImagePicker picker = ImagePicker();
// Picking multiple images
final List<XFile> images =
await picker.pickMultiImage(imageQuality: 70);
// uploading & sending image one by one
for (var i in images) {
setState(() => _isUploading = true);
await sendChatImage(File(i.path));
setState(() => _isUploading = false);
}
},
),
IconButton(
onPressed: () async {
final ImagePicker picker = ImagePicker();
// Pick an image
final XFile? image = await picker.pickImage(
source: ImageSource.camera, imageQuality: 70);
if (image != null) {
await sendChatImage(File(image.path));
}
;
},
icon: const Icon(Icons.camera_alt_rounded,color: Colors.blueAccent, size: 26)),
IconButton(
onPressed: () {
sendMessage(MessageController.text, "text");
},
icon: Icon(
Icons.send,
color: Theme.of(context).colorScheme.secondary,
))
],
),
),
Offstage(
offstage: !_showEmoji,
child: SizedBox(
height: 250,
child: EmojiPicker(
textEditingController: MessageController,
config: Config(
columns: 7,
emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
))),
),
if (_isUploading)
const Align(
alignment: Alignment.centerRight,
child: Padding(
padding:
EdgeInsets.symmetric(vertical: 8, horizontal: 20),
child: CircularProgressIndicator(strokeWidth: 2))),
],
), )), ), ), ); }void _showBottomSheet(bool isMe, String? msg, String? msgid, String?
img) {
showModalBottomSheet(
context: context,
shape: const RoundedRectangleBorder(
borderRadius: BorderRadius.only(
topLeft: Radius.circular(20), topRight: Radius.circular(20))),
builder: (_) {
return ListView(
shrinkWrap: true,
children: [
//black divider
Container(
height: 4,
margin: EdgeInsets.symmetric(
vertical: MediaQuery.of(context).size.height * .015,
horizontal: MediaQuery.of(context).size.width * .4),
decoration: BoxDecoration(
color: Colors.grey, borderRadius: BorderRadius.circular(8)),
),
msgtype == "text"
?
//copy option
_OptionItem(
icon: const Icon(Icons.copy_all_rounded,
color: Colors.blue, size: 26),
name: 'Copy Text',
onTap: () async {
await Clipboard.setData(ClipboardData(text: msg))
.then((value) {
//for hiding bottom sheetNavigator.pop(context);
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text(
'Text Copied',
style: TextStyle(fontSize: 16),
),
duration: Duration(seconds: 1),
backgroundColor: Colors.lightBlue,
elevation: 12,
),
);
});
})
:
//save option
_OptionItem(
icon: const Icon(Icons.download_rounded,
color: Colors.blue, size: 26),
name: 'Save Image',
onTap: () async {
try {
await GallerySaver.saveImage(
"https://firebasestorage.googleapis.com/v0/b/weconnect1b5e0.appspot.com/o/images%2FlVMyQrGPK5huOGQ9LCBAXFQUx1
m1?alt=media&token=839ac1e6-a6e5-4a94-ab52-a55550fd00e7",
).then((success) {
//for hiding bottom sheet
Navigator.pop(context);
if (success != null && success) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text(
'Image Saved Successfully ',
style: TextStyle(fontSize: 16),
),
duration: Duration(seconds: 1),
backgroundColor: Colors.lightBlue,
elevation: 12,
),
);
}
});
} catch (e) {
print("Error occured");
}
}),
//separator or divider
if (isMe)
Divider(
color: Colors.black54,
endIndent: MediaQuery.of(context).size.width * .04,
indent: MediaQuery.of(context).size.width * .04,
),
//edit option
if (msgtype == "text" && isMe)
_OptionItem(
icon: const Icon(Icons.edit, color: Colors.blue, size: 26),
name: 'Edit Message',
onTap: () {
//for hiding bottom sheet
Navigator.pop(context);// _showMessageUpdateDialog();
}),
//delete option
if (isMe)
_OptionItem(
icon: const Icon(Icons.delete_forever,
color: Colors.red, size: 26),
name: 'Delete Message',
onTap: () async {
await deleteMessage(msg!, msgid).then((value) {
//for hiding bottom sheet
Navigator.pop(context);
});
}),
//separator or divider
Divider(
color: Colors.black54,
endIndent: MediaQuery.of(context).size.width * .04,
indent: MediaQuery.of(context).size.width * .04,
),
],
);
});
}
// delete message
Future<void> deleteMessage(String message, String? msgid) async {
await FirebaseFirestore.instance
.collection("chatrooms")
.doc(widget.chatRoom.chatroomid).collection("Messages")
.doc(msgid)
.delete();
}
}
class _OptionItem extends StatelessWidget {
final Icon icon;
final String name;
final VoidCallback onTap;
const _OptionItem(
{required this.icon, required this.name, required this.onTap});
@override
Widget build(BuildContext context) {
return InkWell(
onTap: () => onTap(),
child: Padding(
padding: EdgeInsets.only(
left: MediaQuery.of(context).size.width * .05,
top: MediaQuery.of(context).size.height * .015,
bottom: MediaQuery.of(context).size.height * .015),
child: Row(children: [
icon,
Flexible(
child: Text(' $name'
,
style: const TextStyle(
fontSize: 15,
color: Colors.black54,
letterSpacing: 0.5)))
]),
)); }}
