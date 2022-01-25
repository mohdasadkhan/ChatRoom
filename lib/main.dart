import 'package:chatroom/src/screens/authscreen.dart';
import 'package:chatroom/src/screens/chatscreens.dart';
import 'package:chatroom/src/screens/splashscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const app_color =Color(0xff5089C6);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        backgroundColor: app_color,
        accentColor: app_color,
        brightness: Brightness.dark,
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: app_color,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          )
        ),
      ),
      // home: AuthScreen()
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot){
          if(userSnapshot.connectionState == ConnectionState.waiting){
            return SplashScreen();
          }
          if(userSnapshot.hasData){
            return ChatScreen();
            // return SplashScreen();
          }
          return AuthScreen();
        },
      )
    );
  }
}
