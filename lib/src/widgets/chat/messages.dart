import 'package:chatroom/src/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {

  void takeCurrentUserId()async{
    currentUserId = await FirebaseAuth.instance.currentUser!.uid;
  }
  String currentUserId = '';

  @override
  Widget build(BuildContext context) {
    takeCurrentUserId();
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chat').orderBy('createdAt', descending: true).snapshots(),
      builder: (context,AsyncSnapshot<QuerySnapshot>  chatSnapshot){
        if(chatSnapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }
        final chatDocs = chatSnapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, index) => MessageBubble(
            message: chatDocs[index]['text'],
            isMe: currentUserId == chatDocs[index]['userId'],
            key: ValueKey(chatDocs[index].id),
            userId: chatDocs[index]['userId'],
            userName: chatDocs[index]['username'],
            userImage: chatDocs[index]['userImage'],
          )
        );
      },
    );
  }
}
