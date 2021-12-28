import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final userId;
  final Key key;
  final String userName;
  final String userImage;
  MessageBubble({
    required this.message,
    required this.isMe,
    required this.key,
    required this.userId,
    required this.userName,
    required this.userImage,

  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
             !isMe ?  Padding(
               padding: const EdgeInsets.only(left: 6.0),
               child: CircleAvatar(
                  backgroundImage: NetworkImage(userImage),
                ),
             ) : Container(),
              Container(
                decoration: BoxDecoration(
                  color: isMe ?  Color(0xff414149) : Color(0xffdcdcdc),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                    bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(16.0),
                    bottomRight: isMe ? Radius.circular(0) : Radius.circular(16.0),
                  ),
                    // border: Border.all(color: Color(0xff808080))
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16), //vertical -> top and bottom //horizontal -> left and right
                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    !isMe ? Text(userName, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xffc471ed)), textAlign: TextAlign.start,) : Text('.', style: TextStyle(fontSize: 0.0),),
                    !isMe ? SizedBox(height: 2.0) : SizedBox(height: 0.0),
                    Text(message, style: TextStyle(color: isMe ? Colors.white : Color(0xff808080),fontSize: 16.0)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );

  }
}
