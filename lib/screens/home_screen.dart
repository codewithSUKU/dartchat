import 'package:dartchat/screens/MainPage.dart';
import 'package:flutter/material.dart';
// import 'package:dartchat/widegets/category_selector.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../widegets/favorite_contacts.dart';
import '../widegets/recent.dart';

class HomeScreen extends StatefulWidget {

  final String authKey;
  final String user;
  HomeScreen({this.authKey, this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  _save(String token) async {
    final value = token;
    print(value);
  }

  _remove(String token) async {
    token = '0';

  }

  Future<void> _deleteCall() async {
    final userName = widget.user;
    final token = widget.authKey;
    // print(userName);
    // print(token);
    final response =
        await http.delete('http://15.206.162.58:3000/user/$userName', headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    });
    var responseCode = response.statusCode;
    
    
    if (responseCode == 200) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Deleted!"),
              content: Text("User Deleted Successful"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    _remove(token);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return LoginPage();
                      }),
                    );
                  },
                )
              ],
            );
          });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.more_vert),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: () {},
        ),
        title: Text(
          'dartChat',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {
              _save('0');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {
              _deleteCall();
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          // CategorySelector(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  FavoriteContacts(
                    authKey: widget.authKey,
                  ),
                  RecentChats(
                    authKey: widget.authKey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
