// import 'package:dartchat/globalState.dart';
import 'package:dartchat/models/chat.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ChatScreen extends StatefulWidget {

  final String sender;
  final String avatar;
  ChatScreen({
    this.sender,
    this.avatar,
  });

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {

  // GlobalState _store = GlobalState.instance;
  
  final TextEditingController _messageController = TextEditingController();

  final List<ChatMessage> _messages = <ChatMessage>[];

  Map data;
  List userData;
  final String avatarUrl = 'http://15.206.162.58:3000/';
  
  Future getData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key);
    
    http.Response response =
        await http.get('http://15.206.162.58:3000/user/', headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $value",
    });
    data = json.decode(response.body);
    setState(() {
      userData = data["data"];
      // print("${_store.get("user")}");
    });
    // print();
  }

  void _handleSubmitted(String msg) {
    _messageController.clear();
    // print(msg);
    ChatMessage message = ChatMessage(
      message: msg,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  Widget _messageFieldWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.insert_emoticon),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              controller: _messageController,
              onSubmitted: _handleSubmitted,
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.attach_file),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              _handleSubmitted(_messageController.text);
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
    // _handleSubmitted(String msg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Container(
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(avatarUrl + widget.avatar),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 15.0),
                  child: Text(widget.sender),
                ),
              ),
            ],
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.call),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {
              //For Audio Call
            },
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {
              //For Video Call
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      
body: GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: <Widget>[
          Expanded(
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
                  padding: EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (_, int index) => _messages[index],
                  itemCount: _messages.length,
                ),
              ),
            ),
          ),
          _messageFieldWidget(),
        ],
      ),
    ),
    );
  }
}
