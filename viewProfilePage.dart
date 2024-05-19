import 'package:cached_network_image/cached_network_image.dart';
import 'package:first_app/models/usermodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//view profile screen -- to view profile of user
class ViewProfileScreen extends StatefulWidget {
final UserModel user;
const ViewProfileScreen({super.key, required this.user});
@override
State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}
class _ViewProfileScreenState extends State<ViewProfileScreen> {
@override
Widget build(BuildContext context) {
return GestureDetector(
// for hiding keyboard
onTap: () => FocusScope.of(context).unfocus(),
child: Scaffold(
//app bar
appBar: AppBar(title: Text(widget.user.fullname!)),
//body
body: Padding(
padding: EdgeInsets.symmetric(
horizontal: MediaQuery.of(context).size.width * .05),child: SingleChildScrollView(
child: Column(
children: [
// for adding some space
SizedBox(
width: MediaQuery.of(context).size.width,
height: MediaQuery.of(context).size.height * .03),
//user profile picture
ClipRRect(
borderRadius: BorderRadius.circular(
MediaQuery.of(context).size.height * .1),
child: CachedNetworkImage(
width: MediaQuery.of(context).size.height * .2,
height: MediaQuery.of(context).size.height * .2,
fit: BoxFit.cover,
imageUrl: widget.user.profilepic!,
placeholder: (context, url) => CircleAvatar(
backgroundColor: Colors.blue[600],
child: Icon(
Icons.person,
size: 60,
color: Colors.yellow[700],
),
),
errorWidget: (context, url, error) => const CircleAvatar(
child: Icon(CupertinoIcons.person)),
),
),
// for adding some space
SizedBox(height: MediaQuery.of(context).size.height * .03),// user email label
Text(widget.user.email!,
style:
const TextStyle(color: Colors.black87, fontSize: 16)),
// for adding some space
SizedBox(height: MediaQuery.of(context).size.height * .02),
//user about
Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Text(
"${widget.user.stream!} ${widget.user.batch!}"
,
style: const TextStyle(
color: Colors.black87,
fontWeight: FontWeight.w500,
fontSize: 15),
),
],
),
],
),
),
)),
);
}
}
