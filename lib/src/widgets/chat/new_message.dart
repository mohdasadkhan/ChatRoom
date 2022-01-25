import 'dart:convert';
import 'dart:io';

import 'package:chatroom/src/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;

class NewMessage extends StatefulWidget {

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {

  final String serverKey = 'AAAAz6X5GJM:APA91bGcOwERlW-xaXOSVW1A388ruIwLdPJCwi9RWpQix87ARQap0tDWi5jMTs80sTd5qwCCfxBO3odIa9YZwkcWwaxDZZvUq4s0SI01dsrg-PctSEdzHLfuoTjZov1oQXaSPFJtcEcF';
  TextEditingController _enteredMessage = TextEditingController();
  String newMessage = '';
  var user;
  var userData;
  List tokenList = []; //232 , 23


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

  }

  void getData() async {
     user = await FirebaseAuth.instance.currentUser;
     userData = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

  }


  void _sendMessage() async{
    // FocusScope.of(context).unfocus();    //to unfocus keyboard
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage.text,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
      'userImage': userData['image_url'],
    });

    _enteredMessage.clear();
    setState(() {
      newMessage = '';
    });
  }

  void _sendNotification() async{
    for(int i=0; i<tokenList.length; ++i){
      if(userData['token']!=tokenList[i]){
        sendNotification(tokenList[i], _enteredMessage.text);
      }
    }
  }


    Future<http.Response> sendNotification(String peerToken, String content) async {
      final response = await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: "key=$serverKey"
        },
        body: jsonEncode({
          "to": peerToken,
          "priority": "high",
          "data": {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "type": "100",
            // "user_id": userID,
            "title": content,
            // "message": globalName,
            "time": DateTime.now().millisecondsSinceEpoch,
            "sound": "default",
            "vibrate": "300",
          },
          "notification": {
            "vibrate": "300",
            "priority": "high",
            "body": content,
            "title": userData['username'],
            "sound": "default",
          }
        }),
      );
      return response;
    }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 0.0,
          height: 0.0,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context,AsyncSnapshot<QuerySnapshot>  chatSnapshot){
              if(chatSnapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator());
              }
              final chatDocs = chatSnapshot.data!.docs;
              tokenList.clear();
              return ListView.builder(
                  reverse: true,
                  itemCount: chatDocs.length,
                  itemBuilder: (ctx, index) {
                    tokenList.add(chatDocs[index]['token']);
                    return Container();
                  }
              );
            },
          ),
        ),
        Container(
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(
                color: Color(0xff808080),
                blurRadius: 1.0,
              ),]
          ),
          height: 0.5,
        ),
        Container(
          height: 55.0,
          padding: EdgeInsets.only(left: 10.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  cursorColor: app_color,
                  controller: _enteredMessage,
                  decoration: InputDecoration(

                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: app_color),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: app_color),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: app_color),
                      ),
                      hintText: 'Send a message...'
                  ),

                  onChanged: (String newValue){
                    setState(() {
                      newMessage = newValue;
                    });
                  },
                ),
              ),
              IconButton(color: newMessage.isNotEmpty ? app_color : Theme.of(context).primaryColor, icon: Icon(Icons.send),
                onPressed: (){
                  // newMessage.isEmpty ? null : _sendMessage,
                  if(!newMessage.isEmpty){
                    _sendNotification();
                    _sendMessage();
                  }
                }
              )
            ],
          ),
        ),
      ],
    );
  }
}
