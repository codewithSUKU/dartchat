import 'package:flutter/material.dart';
import 'package:dartchat/screens/MainPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      theme: ThemeData(
        primarySwatch: Colors.teal,
        accentColor: Colors.white
      ),
    );
  }
}

//auth: new Auth()
