// import 'package:dartchat/globalState.dart';
import 'package:dartchat/screens/chat_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RecentChats extends StatefulWidget {
  @override
  _RecentChatScreen createState() => _RecentChatScreen();
}

class _RecentChatScreen extends State<RecentChats> {
  // GlobalState _store = GlobalState.instance;

  Map data;
  List userData;
  final avatarUrl = 'http://15.206.162.58:3000/';
  bool loading = false;

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
    // var responseCode = response.statusCode;
    // print('Dio responseCode : $responseCode');

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
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: ListView.builder(
            itemCount: userData == null ? 0 : userData.length,
            itemBuilder: (BuildContext context, int index) {
              final data = userData[index];
              
              print(data["name"]);
              
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
                    top: 5.0,
                    bottom: 5.0,
                    right: 20.0,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      topLeft: Radius.circular(20.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 35.0,
                            child: Align(
                              alignment: Alignment.center,
                              child: loading ? Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CircularProgressIndicator(),
                                ],
                              ),
                            ) : Text("No Data"),
                            ),
                            // backgroundImage:  NetworkImage(avatarUrl + data["avatar"]),
                          ),
                          SizedBox(width: 10.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(data['name'],
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                              SizedBox(height: 5.0,),
                              Text(data['sender'],
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                              SizedBox(height: 5.0,),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: Text(
                                  data['about'],
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
