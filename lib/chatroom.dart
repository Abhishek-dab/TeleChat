import 'package:chatting_app/authentication.dart';
import 'package:chatting_app/authwidget.dart';
import 'package:chatting_app/conversations.dart';
import 'package:chatting_app/database.dart';
import 'package:chatting_app/search.dart';
import 'package:chatting_app/sharedpreferences.dart';
import 'package:chatting_app/signin.dart';
import 'package:chatting_app/userdetials.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthenticationD authenticationD = new AuthenticationD();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomsStream;
  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                      snapshot.data.docs[index]
                          .data()["chatroomId"]
                          .toString()
                          .replaceAll("_", " ")
                          .replaceAll(UserDetails.myName, ""),
                      snapshot.data.docs[index].data()["chatroomId"]);
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();

    super.initState();
  }

  getUserInfo() async {
    UserDetails.myName = await HelperFunction.getUserName();
    databaseMethods.getChatRooms(UserDetails.myName).then((val) {
      setState(() {
        chatRoomsStream = val;
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        title: const Text('Chat App'),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchUser()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 9),
                child: Icon(Icons.search)),
          ),
          GestureDetector(
            onTap: () {
              authenticationD.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AuthenWidget()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: chatRoomList(),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoom;
  ChatRoomsTile(this.userName, this.chatRoom);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationScreen(chatRoom)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 15,
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Colors.red, spreadRadius: 2, blurRadius: 5)
                  ],
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(50)),
              child: Text(
                userName.substring(0, 1).toUpperCase(),
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.65,
              padding: EdgeInsets.only(left: 20),
              child: Text(
                userName,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
