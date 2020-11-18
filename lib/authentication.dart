import 'package:chatting_app/userdetials.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationD {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserDetails _userfromfirebase(User user) {
    return user != null ? UserDetails(userId: user.uid) : null;
  }

  Future signInWithMail(String email, String pass) async {
    try {
      UserCredential result =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      User firebaseUser = result.user;
      return _userfromfirebase(firebaseUser);
    } catch (e) {
      print(e);
    }
  }

  Future signUpWithMail(String email, String pass) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      User firebaseUser = result.user;
      return _userfromfirebase(firebaseUser);
    } catch (e) {
      print(e);
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
