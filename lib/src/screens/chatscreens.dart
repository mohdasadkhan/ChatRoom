import 'package:chatroom/src/const.dart';
import 'package:chatroom/src/widgets/chat/messages.dart';
import 'package:chatroom/src/widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('ChatRoom', style: TextStyle(color: Colors.white),),
        actions: [
          PopupMenuButton(onSelected: (value) {
            if(value == 'logout'){
              FirebaseAuth.instance.signOut();
            }
          }, itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app, color: app_color),
                    SizedBox(width: 10.0),
                    Text('Logout'),
                  ],
                ),
                value: 'logout',
              ),
            ];
          }),
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
          color: app_color
        ),
        child: Column(
          children: [
            Expanded(child: Messages()),
            NewMessage(),

          ],
        ),
      ),
    );
  }
}

