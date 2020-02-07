import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:dartchat/screens/chat_screen.dart';
import 'dart:convert';

class FavoriteContacts extends StatefulWidget {

  final String authKey;
  FavoriteContacts({this.authKey});

  @override
  _FavoriteContactsState createState() => _FavoriteContactsState();
}

class _FavoriteContactsState extends State<FavoriteContacts> {

  Map data;
  List userData;
  final String avatarUrl = 'http://15.206.162.58:3000/';
  bool loading = false;
  var progressString = "";

  Future<List<void>> getData() async {

    final token = widget.authKey;
    // print("fav : $token");

    try {
      Dio dio = Dio();
      dio.options.headers['Accept'] = "application/json";
      dio.options.headers['Authorization'] = "Bearer $token";
      dio.options.followRedirects = false;

      var response = await dio.get(
        "http://15.206.162.58:3000/chat/",
            onReceiveProgress: (rec, total) {
              // print("Rec : $rec , Total : $total");
              setState(() {
                loading = true;
                progressString = ((rec / total * 100).toStringAsFixed(0) + "%");
          });
        }
      );
      var res = json.encode(response.data);
      final data = json.decode(res);

      var result = data["users"];

      setState(() {
        loading = false;
        progressString = "Completed";
        userData = result;
      });
      return userData;
    } on DioError catch (err) {
      var responseCode = err.response.statusCode;
      print(responseCode);
    }

    setState(() {
      // loading = true;
      // progressString = "Completed";
      print(progressString);
    });
    return userData;
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
                          Container(
                            // color: Theme.of(context).primaryColor,
                            child: loading
                                ? Container(
                                    child: CircleAvatar(
                                      radius: 35,
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            CircularProgressIndicator(),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text("Loading $progressString", 
                                                  style: TextStyle(
                                                    fontSize: 6.0,
                                                  ),
                                                ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 34.8,
                                    backgroundImage: NetworkImage(avatarUrl + data['avatar']),
                                  ),
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
