import 'dart:io';

import 'package:chatroom/src/const.dart';
import 'package:chatroom/src/widgets/image_picker/user_image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);
  bool isLoading;
  final void Function(
      String email,
      String password,
      String userName,
      bool isLogin,
      BuildContext ctx,
      File image,
      ) submitFn;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;

  String _userEmail = '';

  String _userUserName = '';

  String _userPassword = '';

  File _userImageFile = File('NA');

  void _pickedImage(File image){
    _userImageFile = image;
  }

  void trySubmit(BuildContext context){
    final isValid = _formKey.currentState!.validate();
    if(_userImageFile.toString().length<=15 && !_isLogin){
      Fluttertoast.showToast(
        msg: 'Please pick an Image.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
      return;
    }
    else if(isValid && _userImageFile!='NA'){
      FocusScope.of(context).unfocus();
      _formKey.currentState!.save();
      // send values to our auth request...
      widget.submitFn(
          _userEmail.trim(),
          _userPassword.trim(),
          _userUserName.trim(),
          _isLogin,
          context,
          _userImageFile
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  !_isLogin ? UserImagePicker(imagePickFn: _pickedImage) : Container(),
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value){
                      if(!value!.contains('@')){
                        return 'Please enter a valid email address';
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                    ),
                    onSaved: (value){
                      _userEmail = value.toString();
                    },
                  ),
                  !_isLogin ? TextFormField(
                    key: ValueKey('username'),
                    validator: (value){
                      if(value!.length<4){
                        return 'password must contains 4 characters';
                      }
                    },
                    decoration: InputDecoration(labelText: 'Username'),
                    onSaved: (value){
                      _userUserName = value.toString();
                    },
                  ) : Container(),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value){
                      if(value!.length<6){
                        return 'password must contains 6 characters';
                      }
                    },
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                    onSaved: (value){
                      _userPassword = value.toString();
                    },
                  ),
                  SizedBox(height: 20.0),
                  if(widget.isLoading)CircularProgressIndicator(),
                  if(!widget.isLoading)ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: app_color
                    ),
                      child: Text(_isLogin ? 'Login' : 'SignUp'),onPressed: (){
                    trySubmit(context);
                  }),
                  if(!widget.isLoading)TextButton(
                    child: Text(_isLogin ? 'Create New Account' : 'I already have an account', style: TextStyle(color: app_color),),onPressed: (){
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
