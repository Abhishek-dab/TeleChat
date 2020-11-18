import 'package:chatting_app/authentication.dart';
import 'package:chatting_app/chatroom.dart';
import 'package:chatting_app/database.dart';
import 'package:chatting_app/sharedpreferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  AuthenticationD authenticationD = new AuthenticationD();
  TextEditingController mails = new TextEditingController();
  TextEditingController passs = new TextEditingController();
  bool isLoad = false;
  QuerySnapshot snapshot;
  String ka = " Register First Before Login";
  signInFrom() {
    HelperFunction.saveUserMail(mails.text);
    databaseMethods.getUserByMail(mails.text).then((val) {
      snapshot = val;
      HelperFunction.saveUserName(snapshot.docs[0].data()["name"]);
    });
    setState(() {
      isLoad = true;
    });

    authenticationD.signInWithMail(mails.text, passs.text).then((val) {
      if (val != null) {
        HelperFunction.saveUserLoginSharedPreference(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom()));
      } else {
        setState(() {
          ka = "Account Not Found Register First";
          isLoad = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.orange[900],
          Colors.orange[800],
          Colors.orange[400]
        ])),
        child: isLoad
            ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 80,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Chat App",
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "  Login",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          ka,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60))),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    top: 35.0, left: 20.0, right: 20.0),
                                child: Column(
                                  children: <Widget>[
                                    Column(
                                      children: [
                                        TextField(
                                          controller: mails,
                                          decoration: InputDecoration(
                                            labelText: 'EMAIL',
                                            labelStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey),
                                          ),
                                        ),
                                        SizedBox(height: 20.0),
                                        TextField(
                                          obscureText: true,
                                          controller: passs,
                                          decoration: InputDecoration(
                                            labelText: 'PASSWORD',
                                            labelStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 38.0),
                                    Container(
                                      height: 50.0,
                                      child: GestureDetector(
                                        onTap: () {
                                          signInFrom();
                                        },
                                        child: Material(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          shadowColor: Colors.greenAccent,
                                          color: Colors.green,
                                          elevation: 7.0,
                                          child: Center(
                                            child: Text(
                                              'LOGIN',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5.0),
                                    Container(
                                      alignment: Alignment(1.0, 0.0),
                                      padding: EdgeInsets.only(
                                          top: 15.0, left: 20.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          widget.toggle();
                                        },
                                        child: Container(
                                          child: Text(
                                            'New account? Register',
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ], //a
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
