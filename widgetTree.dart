import 'package:firebase_auth/firebase_auth.dart';
import './screens/main_page.dart';
import 'authentication/auth.dart';
import 'package:flutter/material.dart';
import './authentication/login.dart';
import 'models/firebaseHelper.dart';
import 'models/usermodel.dart';
class WidgetTree extends StatefulWidget {
State<WidgetTree> createState() => _WidgetTreeState();
}
User? currentUser;
UserModel? thisUserModel;
void returnwidget() async {
currentUser = FirebaseAuth.instance.currentUser;
thisUserModel = await
FirebaseHelper.getUserModelById(currentUser!.uid);
}
class _WidgetTreeState extends State<WidgetTree> {
@override
void initState() {
super.initState();
returnwidget();
}
@overrideWidget build(BuildContext context) {
return StreamBuilder(
stream: Auth().authStateChanges,
builder: (context, snapshot) {
if (snapshot.hasData) {
return MainPage();
} else {
return const login();
}
},
);
}
}
