import 'package:chatting_app/authentication.dart';
import 'package:chatting_app/chatroom.dart';
import 'package:chatting_app/database.dart';
import 'package:chatting_app/sharedpreferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  final Function toggle;
  Register(this.toggle);
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formkey = GlobalKey<FormState>();
  bool isLoad = false;
  AuthenticationD authenticationD = new AuthenticationD();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController names = new TextEditingController();
  TextEditingController mails = new TextEditingController();
  TextEditingController passs = new TextEditingController();
  signUpForm() async {
    if (formkey.currentState.validate()) {
      Map<String, String> userInfoMap = {
        "name": names.text,
        "mail": mails.text
      };

      HelperFunction.saveUserMail(mails.text);
      HelperFunction.saveUserName(names.text);
      setState(() {
        isLoad = true;
      });
      authenticationD.signUpWithMail(mails.text, passs.text).then((val) {
        //print("${val.uid}");

        databaseMethods.uploadUserDetails(userInfoMap);
        HelperFunction.saveUserLoginSharedPreference(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom()));
      });
    }
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
                          "  Register",
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
                                child: Form(
                                  key: formkey,
                                  child: Column(
                                    children: <Widget>[
                                      Column(
                                        children: [
                                          TextFormField(
                                            validator: (val) {
                                              return val.isEmpty ||
                                                      val.length < 2
                                                  ? "Add more letters"
                                                  : null;
                                            },
                                            controller: names,
                                            decoration: InputDecoration(
                                              labelText: 'NAME',
                                              labelStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                          TextFormField(
                                            validator: (val) {
                                              return RegExp(
                                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+")
                                                      .hasMatch(val)
                                                  ? null
                                                  : "Enter correct email";
                                            },
                                            controller: mails,
                                            decoration: InputDecoration(
                                              labelText: 'EMAIL',
                                              labelStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                          TextFormField(
                                            obscureText: true,
                                            validator: (val) {
                                              return val.length > 6
                                                  ? null
                                                  : "Pass should be more than 6 char";
                                            },
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
                                      SizedBox(height: 18.0),
                                      Container(
                                        height: 50.0,
                                        child: GestureDetector(
                                          onTap: () {
                                            signUpForm();
                                          },
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            shadowColor: Colors.greenAccent,
                                            color: Colors.green,
                                            elevation: 7.0,
                                            child: Center(
                                              child: Text(
                                                'REGISTER',
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
                                              'Have an account? Login',
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
