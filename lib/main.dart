import 'package:flutter/material.dart';
import 'package:dartchat/MainPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      // routes: <String,WidgetBuilder>{
      //   '/SignUpPage': (BuildContext context)=> new SignUpPage(),
      // },
    );
  }
}

//auth: new Auth()
