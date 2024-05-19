//Auth.dart

import 'package:firebase_auth/firebase_auth.dart';
class Auth {
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
User? get currentUser => _firebaseAuth.currentUser;
Stream<User?> get authStateChanges =>
_firebaseAuth.authStateChanges();
Future<void> sendPasswordResetEmail({
required String email,
}) async {
await _firebaseAuth.sendPasswordResetEmail(email: email);
}
Future<void> signOut() async {
await _firebaseAuth.signOut();
}
}
