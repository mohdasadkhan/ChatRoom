import 'dart:io';

import 'package:chatroom/src/const.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker({required this.imagePickFn});
  final void Function(File pickedImage) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage = File('Your initial file');

  void _pickImage() async {
    var pickedImageFile = await ImagePicker.platform.pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150, maxHeight: 120);
    setState(() {
      _pickedImage = File(pickedImageFile!.path);
    });
    widget.imagePickFn(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40.0,
          backgroundImage: _pickedImage != null ? FileImage(_pickedImage) : null,
          backgroundColor: Colors.grey,
        ),
        TextButton.icon(
            icon: Icon(Icons.image),
            label: Text('Add Image', style: TextStyle(color: app_color),),
            onPressed: _pickImage,
        ),
      ],
    );
  }
}