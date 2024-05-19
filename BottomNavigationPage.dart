import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/models/chatRoomModel.dart';
import 'package:first_app/models/firebaseHelper.dart';
import 'package:first_app/screens/Home.dart';
import 'package:first_app/screens/allChats.dart';
import 'package:first_app/screens/help.dart';
import '../models/usermodel.dart';
import 'post.dart';
import 'search.dart';
import 'package:flutter/material.dart';
class MainPage extends StatefulWidget {
// final UserModel? userModel;
// final User? firebaseUser;
// const MainPage(
// {super.key, required this.userModel, required this.firebaseUser});
@override
State<MainPage> createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> {
int currentindex = 0;
void initState() {
super.initState();
fetchlist();
}List mypages = [Help()];
Future<void> fetchlist() async {
User? currentUser = FirebaseAuth.instance.currentUser;
UserModel? userModel =
await FirebaseHelper.getUserModelById(currentUser!.uid);
List pages = [
Home(userModel: userModel, firebaseUser: currentUser),
Post(),
chats(userModel: userModel, firebaseUser: currentUser),
Search(userModel: userModel, firebaseUser: currentUser)
];
setState(() {
mypages = pages;
});
}
void onTap(int index) {
setState(() {
currentindex = index;
});
}
@override
Widget build(BuildContext context) {
return Scaffold(
body: mypages[currentindex],
bottomNavigationBar: BottomNavigationBar(
currentIndex: currentindex,
onTap: onTap,
type: BottomNavigationBarType.fixed,
selectedItemColor: Color.fromARGB(255, 5, 4, 4),unselectedItemColor:
Color.fromARGB(255, 157, 157, 157).withOpacity(0.9),
showSelectedLabels: false,
showUnselectedLabels: false,
elevation: 0,
// ignore: prefer_const_literals_to_create_immutables
items: [
const BottomNavigationBarItem(
icon: Icon(Icons.home), label: 'Home'),
const BottomNavigationBarItem(
icon: Icon(Icons.add_box), label: 'Post'),
const BottomNavigationBarItem(
icon: Icon(Icons.message_rounded), label: 'Chats'),
const BottomNavigationBarItem(
icon: Icon(Icons.search), label: 'Search'),
]),
);
}
}
