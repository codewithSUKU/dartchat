import 'dart:convert';
// import 'package:dartchat/globalState.dart';
import 'package:dartchat/screens/MainPage.dart';
import 'package:dartchat/widegets/recent.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PageScreen extends StatefulWidget {
  @override
  _PageScreeState createState() => _PageScreeState();
}

class _PageScreeState extends State<PageScreen> {

  // GlobalState _store = GlobalState.instance;
  
  _save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);
  }
  Map data;
  List userData;

  Future getData() async {
    
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key);
    print(value);
    http.Response response =
        await http.get('http://15.206.162.58:3000/user/', headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $value",
    });
    // debugPrint(response.body);
    data = json.decode(response.body);
    setState(() {
      userData = data["data"];
    });
    // debugPrint(userData.toString());
    final userName = userData[0]["username"];
    print(userName);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> _deleteCall() async {
    final userName = userData[0]["username"];

    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key);
    
    final response =
        await http.delete('http://15.206.162.58:3000/user/$userName', headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $value",
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
          icon: Icon(Icons.menu),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: () {},
        ),
        title: Text(
          'Chats',
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
                  // FavoriteContacts(),
                  RecentChats(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}