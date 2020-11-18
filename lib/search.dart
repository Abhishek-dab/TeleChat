import 'package:chatting_app/chatroom.dart';
import 'package:chatting_app/conversations.dart';
import 'package:chatting_app/database.dart';
import 'package:chatting_app/sharedpreferences.dart';
import 'package:chatting_app/userdetials.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchUser extends StatefulWidget {
  @override
  _SearchUserState createState() => _SearchUserState();
}

String _myName;
String yName;

class _SearchUserState extends State<SearchUser> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  UserDetails userDetails = new UserDetails();
  TextEditingController searchText = new TextEditingController();
  ChatRoom chatRoom = new ChatRoom();
  QuerySnapshot searchsnapshot;

  Widget searchList() {
    return searchsnapshot != null
        ? ListView.builder(
            itemCount: searchsnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return searchTile(
                userName: searchsnapshot.docs[index].data()["name"],
                userMail: searchsnapshot.docs[index].data()["mail"],
              );
            })
        : Container();
  }

  startSearch() {
    databaseMethods.getUserByName(searchText.text).then((val) {
      setState(() {
        searchsnapshot = val;
      });
    });
  }

  createRoom({String userName}) {
    if (userName != UserDetails.myName) {
      String chatroomId = getChatRoomId(userName, UserDetails.myName);
      List<String> users = [userName, UserDetails.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": chatroomId
      };
      DatabaseMethods().createChatRoom(chatroomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(chatroomId)));
    } else {}
  }

  Widget searchTile({String userName, String userMail}) {
    yName = userName;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              Text(
                userMail,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createRoom(userName: userName);
            },
            child: Container(
              child: Material(
                borderRadius: BorderRadius.circular(20.0),
                shadowColor: Colors.greenAccent,
                color: Colors.green,
                elevation: 7.0,
                child: Center(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    child: Text(
                      'MESSAGE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  getUserInfo() async {
    _myName = await HelperFunction.getUserName();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search User'),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.orange[900],
          Colors.orange[800],
          Colors.orange[400]
        ])),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchText,
                      decoration: InputDecoration(
                        hintText: 'SEARCH',
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        startSearch();
                      },
                      child: Container(
                          padding: EdgeInsets.all(12),
                          child: Icon(Icons.search))),
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
