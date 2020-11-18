import 'package:chatting_app/database.dart';
import 'package:chatting_app/search.dart';
import 'package:chatting_app/userdetials.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();
  Stream chatMessageStream;
  Widget ChatMessageList() {
    return Container(
      margin: EdgeInsets.only(bottom: 70.0),
      child: StreamBuilder(
        stream: chatMessageStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return MessageContainer(
                        snapshot.data.docs[index].data()["message"],
                        snapshot.data.docs[index].data()["sendby"] ==
                            UserDetails.myName);
                  })
              : Container();
        },
      ),
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendby": UserDetails.myName,
        "time": DateTime.now().microsecondsSinceEpoch
      };
      databaseMethods.addConversationMsgs(widget.chatRoomId, messageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    databaseMethods.getConversationMsgs(widget.chatRoomId).then((val) {
      setState(() {
        chatMessageStream = val;
      });
    });
    super.initState();
  }

  //String k = yName;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          //: StackFit.expand,
          children: [
            ChatMessageList(),
            Positioned(
              bottom: 0.0,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 24),
                height: 70,
                width: width,
                color: Theme.of(context).primaryColor,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Send a message..',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      iconSize: 25,
                      color: Colors.white,
                      onPressed: () {
                        sendMessage();
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageContainer extends StatelessWidget {
  final String message;
  final bool sendby;
  MessageContainer(this.message, this.sendby);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: sendby ? 0 : 18, right: sendby ? 18 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      alignment: sendby ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.80,
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: sendby
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23))
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23)),
          color: sendby ? Theme.of(context).primaryColor : Colors.redAccent,
        ),
        child:
            Text(message, style: TextStyle(color: Colors.white, fontSize: 15)),
      ),
    );
  }
}
