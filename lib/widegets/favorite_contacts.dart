// import 'dart:io';
// import 'package:dartchat/globalState.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:dartchat/screens/chat_screen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteContacts extends StatefulWidget {
  @override
  _FavoriteContactsState createState() => _FavoriteContactsState();
}

class _FavoriteContactsState extends State<FavoriteContacts> {
  // GlobalState _store = GlobalState.instance;

  Map data;
  List userData;
  final String avatarUrl = 'http://15.206.162.58:3000/';

  Future getData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key);

    Dio dio = Dio();
          dio.options.headers['Accept'] = "application/json";
          dio.options.headers['Authorization'] = "Bearer $value";
          dio.options.followRedirects = false;
    
    var response = await dio.get("http://15.206.162.58:3000/chat/");
    var res = json.encode(response.data);
    final data = json.decode(res);

    var result = data["users"];

    setState(() {
      userData = result;
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
                final data = userData[index];
                // debugPrint(img["avatar"]);
                return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          sender: data['name'],
                          avatar: data['avatar'],
                        ),
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
                        padding: EdgeInsets.only(left: 10.0),
                        child: Column(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 34.8,
                              backgroundImage: NetworkImage(avatarUrl + data['avatar']),
                            ),
                            SizedBox(height: 6.0),
                            Text(
                              data["name"],
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
