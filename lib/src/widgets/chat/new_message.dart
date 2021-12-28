import 'package:chatroom/src/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {

  TextEditingController _enteredMessage = TextEditingController();
  String newMessage = '';

  void _sendMessage() async{
    // FocusScope.of(context).unfocus();    //to unfocus keyboard
    final user = await FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();


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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                onPressed: newMessage.isEmpty ? null : _sendMessage,
              )
            ],
          ),
        ),
      ],
    );
  }
}
