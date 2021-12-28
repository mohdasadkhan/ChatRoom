import 'dart:io';

import 'package:chatroom/src/widgets/auth_form_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../const.dart';

class AuthScreen extends StatefulWidget {

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;

  void _submitAuthForm(
      String email,
      String password,
      String username,
      bool isLogin,
      BuildContext ctx,
      File image,
      ) async {
    UserCredential credential;
    try{
      setState(() {
        true;
      });
      if(isLogin){
        credential = await _auth.signInWithEmailAndPassword(email: email, password: password);

      }
      else{
        credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        //storind user data

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child('${credential.user!.uid}.jpg');
        await ref.putFile(image);

        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set(
            {
              'username': username,
              'email': email,
              'image_url': url,
            });
      }

    } on PlatformException catch(err){
      setState(() {
        isLoading = false;
      });
      var message = 'An error occured, Please check your credentials';
      if(err.message!=null){
        message = err.message.toString();
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    }
    catch(err){
      setState(() {
        isLoading = false;
      });
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_color,
      body: AuthForm(_submitAuthForm, isLoading)
    );
  }
}
