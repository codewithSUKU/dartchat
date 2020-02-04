import 'dart:convert';
import 'dart:io';
import 'package:dartchat/screens/MainPage.dart';
import 'package:dartchat/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';


class ProfileMaker extends StatelessWidget {
  final String user;
  final String mail;
  final String currentUser;
  final String authKey;

  ProfileMaker({
    this.user,
    this.mail,
    this.currentUser,
    this.authKey
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: ProfileMakerScreen(
        username: this.user,
        email: this.mail,
        sender: this.currentUser,
        token: this.authKey
      ),
    );
  }
}

class ProfileMakerScreen extends StatefulWidget {

  final String username;
  final String email;
  final String sender;
  final String token;

  ProfileMakerScreen({
    this.username,
    this.email,
    this.sender,
    this.token
  });

  @override
  State<StatefulWidget> createState() => _ProfileMakerState();
}

class _ProfileMakerState extends State<ProfileMakerScreen> {


  TextEditingController name = new TextEditingController();
  TextEditingController birthday = new TextEditingController();
  TextEditingController about = new TextEditingController();
  TextEditingController mobile = new TextEditingController();


  final formKey = new GlobalKey<FormState>();
  

  bool _validateAndSave() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  File _image;

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      // print(_image);
    });
  }

  Future _validateAndSubmit() async {
    
    var userName = widget.username;
    var naMe = name.text;
    var birthDay = birthday.text;
    var aboutUser = about.text;
    var sendUser = widget.sender;
    var userMobile = mobile.text;
    var avatar = basename(_image.path);

    // print('$avatar');

    Map data = {
      'username': userName.toString(),
      'name': naMe.toString(),
      'birthday': birthDay.toString(),
      'about': aboutUser.toString(),
      'sender': sendUser.toString(),
      'mobile': userMobile.toString(),
      'avatar': _image.path
    };

    if (_validateAndSave()) {
      var value = widget.token;
      print(data);
      print(avatar);
      final response = await http.post('http://15.206.162.58:3000/chat/',
          headers: {
            "Accept": "application/json; charset=UTF-8",
            "Authorization": "Bearer $value",
          }, 
          body: data);
      var responseCode = response.statusCode;
      print('$responseCode');
      final res = json.decode(response.body);
      print('$res');



    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_left),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) {
                return LoginPage();
              }),
            );
          },
        ),
      ),
      resizeToAvoidBottomPadding: false,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/images/bg.jpeg',
            fit: BoxFit.cover,
            color: Colors.black54,
            colorBlendMode: BlendMode.darken,
          ),
          Container(
            margin: EdgeInsets.only(top: 100.0),
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.topCenter,
            child: Text(
              "CREATE YOUR PROFILE",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 20.0,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 150.0),
            padding: EdgeInsets.all(5.0),
            alignment: Alignment.center,
            child: CustomScrollView(
              scrollDirection: Axis.vertical,
              shrinkWrap: false,
              slivers: <Widget>[
                new SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  sliver: new SliverList(
                    delegate: new SliverChildBuilderDelegate(
                      (context, index) => new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 35.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 20.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.center,
                                      child: CircleAvatar(
                                        radius: 100.0,
                                        backgroundColor:
                                            Theme.of(context).splashColor,
                                        child: ClipOval(
                                          child: SizedBox(
                                            width: 200.0,
                                            height: 200.0,
                                            child: (_image != null)
                                                ? Image.file(_image,
                                                    fit: BoxFit.fill)
                                                : Image.network(
                                                    "https://cdn4.iconfinder.com/data/icons/man-and-woman/154/man-human-person-login-512.png",
                                                    fit: BoxFit.fill,
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 130.0),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.camera,
                                          size: 30.0,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        onPressed: () {
                                          _getImage();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 0.0),
                            child: Stack(
                              children: <Widget>[
                                SingleChildScrollView(
                                  child: Container(
                                    height: 510.0,
                                    width: 320.0,
                                    margin: EdgeInsets.only(top: 10.0),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                      vertical: 10.0,
                                    ),
                                    child: Form(
                                      key: formKey,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 10.0,
                                            ),
                                            child: TextFormField(
                                              controller: name,
                                              autocorrect: false,
                                              autofocus: false,
                                              style: TextStyle(
                                                fontSize: 15.0,
                                              ),
                                              validator: (value) =>
                                                  value.isEmpty
                                                      ? 'name can\'t be empty'
                                                      : null,
                                              onSaved: (value) => name.value,
                                              decoration: InputDecoration(
                                                hintText: "Name",
                                                labelText: "Enter Your Name",
                                                border: InputBorder.none,
                                                filled: true,
                                                fillColor: Colors.white38,
                                                contentPadding:
                                                    EdgeInsets.all(5.0),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 10.0,
                                            ),
                                            child: TextFormField(
                                              controller: birthday,
                                              autocorrect: false,
                                              autofocus: false,
                                              style: TextStyle(
                                                fontSize: 15.0,
                                              ),
                                              validator: (value) => value
                                                      .isEmpty
                                                  ? 'age can\'t be empty'
                                                  : null,
                                              onSaved: (value) =>
                                                  birthday.value,
                                              decoration: InputDecoration(
                                                hintText: "Birthday",
                                                labelText:
                                                    "Enter Your Birthday",
                                                border: InputBorder.none,
                                                filled: true,
                                                fillColor: Colors.white38,
                                                contentPadding:
                                                    EdgeInsets.all(5.0),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 10.0,
                                            ),
                                            child: TextFormField(
                                              controller: about,
                                              autocorrect: false,
                                              autofocus: false,
                                              style: TextStyle(
                                                fontSize: 15.0,
                                              ),
                                              validator: (value) => value
                                                      .isEmpty
                                                  ? 'about can\'t be empty'
                                                  : null,
                                              onSaved: (value) =>
                                                  about.value,
                                              decoration: InputDecoration(
                                                hintText: "About",
                                                labelText:
                                                    "Describe Youreself",
                                                border: InputBorder.none,
                                                filled: true,
                                                fillColor: Colors.white38,
                                                contentPadding:
                                                    EdgeInsets.all(5.0),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 10.0,
                                            ),
                                            child: TextFormField(
                                              controller: mobile,
                                              autocorrect: false,
                                              autofocus: false,
                                              style: TextStyle(
                                                fontSize: 15.0,
                                              ),
                                              validator: (value) =>
                                                  value.isEmpty
                                                      ? 'Mobile can\'t be empty'
                                                      : null,
                                              onSaved: (value) => mobile.value,
                                              decoration: InputDecoration(
                                                hintText: "Mobile",
                                                labelText: "Enter Your Mobile",
                                                border: InputBorder.none,
                                                filled: true,
                                                fillColor: Colors.white38,
                                                contentPadding:
                                                    EdgeInsets.all(5.0),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Row(
                                            // crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Container(
                                                child: Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 50.0,
                                                        right: 50.0,
                                                        top: 10.0,
                                                        bottom: 10.0
                                                        ),
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: 60.0,
                                                      child: MaterialButton(
                                                        minWidth: 120.0,
                                                        height: 50.0,
                                                        color: Theme.of(context).primaryColor,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 10.0,
                                                        ),
                                                        child: Text(
                                                          "Continue",
                                                          style: TextStyle(
                                                            fontSize: 18.0,
                                                            color:
                                                                Colors.white70,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          _validateAndSubmit();
                                                          // uploadPic(context);
                                                          // print("${widget.username}");
                                                          // print("${widget.email}");
                                                          // print("${widget.sender}");
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      childCount: 1,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
