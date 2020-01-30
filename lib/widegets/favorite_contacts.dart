import 'package:dartchat/globalState.dart';
import 'package:flutter/material.dart';
import 'package:dartchat/screens/chat_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteContacts extends StatefulWidget {
  @override
  _FavoriteContactsState createState() => _FavoriteContactsState(); 
}

class _FavoriteContactsState extends State<FavoriteContacts> {

  GlobalState _store = GlobalState.instance;
  
  Map data;
  List userData;

  Future getData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key);

    final username = _store.get('username');
    final password = _store.get('password');

    print("prefs $username");
    print("prefs $password");
    // Map cred = {

    //   'userName': username,
    //   'pasSWord': password
    // }; 

    http.Response response =
        await http.get('http://15.206.162.58:3000/chat/', headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $value",
    },
    // body: cred,
    );
    data = json.decode(response.body);
    
    setState(() {
      userData = data["users"];
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Favorite Contacts',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_horiz,
                  ),
                  iconSize: 30.0,
                  color: Colors.blueGrey,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Container(
            height: 120.0,
            child: ListView.builder(
              padding: EdgeInsets.only(left: 8.0, right: 10.0),
              scrollDirection: Axis.horizontal,
              itemCount: userData == null ? 0 : userData.length,
              itemBuilder: (BuildContext context, int index) {
                final img = userData[index];
                // debugPrint(img["avatar"]);
                return GestureDetector(
                  onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(),
                  ),
                ),
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 6.0,
                      right: 12.0,
                      top: 5.0,
                      bottom: 10.0,

                    ),
                    child: Padding(
                    padding: EdgeInsets.only(left:10.0),
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 34.8,
                          backgroundImage: NetworkImage('http://15.206.162.58:3000/' + img["avatar"]),
                        ),
                        
                        SizedBox(height: 6.0),
                        Text(
                          img["name"],
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}