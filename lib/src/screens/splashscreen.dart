import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.cyan,
              Colors.white70,
            ]
          )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome to ChatRoom', style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold, fontSize: 30.0)),
            ],
          ),
        ),
      ),
    );
  }
}
