import 'package:chatting_app/register.dart';
import 'package:chatting_app/signin.dart';
import 'package:flutter/material.dart';

class AuthenWidget extends StatefulWidget {
  @override
  _AuthenWidgetState createState() => _AuthenWidgetState();
}

class _AuthenWidgetState extends State<AuthenWidget> {
  bool showSignIn = true;
  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView);
    } else {
      return Register(toggleView);
    }
  }
}
