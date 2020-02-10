// import 'dart:convert';
import 'dart:io';
import 'package:dartchat/screens/MainPage.dart';
import 'package:dartchat/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart';

class ProfileMaker extends StatelessWidget {
  final String authKey;
  final String currentUser;
  final String mail;
  final String user;

  ProfileMaker({this.user, this.mail, this.currentUser, this.authKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: ProfileMakerScreen(
          username: this.user,
          email: this.mail,
          sender: this.currentUser,
          token: this.authKey),
    );
  }
}

class ProfileMakerScreen extends StatefulWidget {
  ProfileMakerScreen({this.username, this.email, this.sender, this.token});

  final String email;
  final String sender;
  final String token;
  final String username;

  @override
  State<StatefulWidget> createState() => _ProfileMakerState();
}

class _ProfileMakerState extends State<ProfileMakerScreen> {
  TextEditingController about = new TextEditingController();
  TextEditingController birthday = new TextEditingController();
  final formKey = new GlobalKey<FormState>();
  TextEditingController mobile = new TextEditingController();
  TextEditingController name = new TextEditingController();

  File _image;
  bool uploading = false;
  String progressString;

  bool _validateAndSave() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = image;
      } else {
        _image = null;
      }
    });
  }

  Future<void> _validateAndSubmit(BuildContext context) async {
    var userName = widget.username;
    var naMe = name.text;
    var birthDay = birthday.text;
    var aboutUser = about.text;
    var sendUser = widget.sender;
    var userMobile = mobile.text;
    var avatar = _image != null ? basename(_image.path) : '';

    final avatarName = avatar.split("-").last;

    try {
      FormData data = FormData.fromMap({
        "username": userName.toString(),
        "name": naMe.toString(),
        "birthday": birthDay.toString(),
        "about": aboutUser.toString(),
        "sender": sendUser.toString(),
        "mobile": userMobile.toString(),
        "avatar": _image != null
            ? await MultipartFile.fromFile(_image.path,
                filename: avatarName.toString())
            : Text('Invalid Avatar'),
      });

      if (_validateAndSave()) {
        final token = widget.token;

        try {
          Dio dio = Dio();
          dio.options.headers['Accept'] = "application/json";
          dio.options.headers['Authorization'] = "Bearer $token";
          dio.options.headers['Content-Type'] = "multipart/form-data";
          dio.options.followRedirects = false;

          var response = await dio.post("http://15.206.162.58:3000/chat/",
              data: data, onSendProgress: (int rec, int total) {
            // print("Send : $rec , total : $total");

            setState(() {
              uploading = true;
              progressString = ((rec / total * 100).toString());
              print(progressString);
            });
          });

          var responseCode = response.statusCode;
          print('Dio responseCode : $responseCode');

          setState(() {
            uploading = false;
          });

          // if (responseCode == 201) {
          // //   var snackBar = SnackBar(
          // //     content: Text("Profile Created"),
          // //   );
          //   // Scaffold.of(context).showSnackBar(snackBar);

          //   // Navigator.pushReplacement(
          //   //   context,
          //   //   MaterialPageRoute(builder: (context) {
          //   //     return HomeScreen(
          //   //       authKey: widget.token,
          //   //       user: widget.username,
          //   //     );
          //   //   }),
          //   // );
          // }  
        } on DioError catch (err) {
          var responseCode = err.response.statusCode;
          print(responseCode);
          // if (responseCode == 401) {
          //   // var snackBar = SnackBar(
          //   //   content: Text("User Unauthorized"),
          //   // );
          //   // Scaffold.of(context).showSnackBar(snackBar);
          // } else if (responseCode == 409) {
          //   // var snackBar = SnackBar(
          //   //   content: Text("Profile Already Exit"),
          //   // );
          //   // Scaffold.of(context).showSnackBar(snackBar);
          // }
        }
      }
    } catch (err) {
      print(err);
    }

    Future.delayed(Duration(milliseconds: 100), () {
      Navigator.pushReplacement(
        this.context,
        MaterialPageRoute(builder: (context) {
          return HomeScreen(
            authKey: widget.token,
            user: widget.username,
          );
        }),
      );
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
            child: uploading
                // == false
                ? Container(
                    height: 150.0,
                    width: 200.0,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      border: Border.all(),
                    ),
                    child: Container(
                      color: Colors.black54,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(
                            backgroundColor: Colors.blue,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            "Uploading File : $progressString",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : CustomScrollView(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                      : Image.asset(
                                                          'assets/images/demo-avatar.png',
                                                          fit: BoxFit.fill,
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(top: 130.0),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.camera,
                                                size: 30.0,
                                                color: Theme.of(context)
                                                    .primaryColor,
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
                                                    validator: (value) => value
                                                            .isEmpty
                                                        ? 'name can\'t be empty'
                                                        : null,
                                                    onSaved: (value) =>
                                                        name.value,
                                                    decoration: InputDecoration(
                                                      hintText: "Name",
                                                      labelText:
                                                          "Enter Your Name",
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
                                                    validator: (value) => value
                                                            .isEmpty
                                                        ? 'Mobile can\'t be empty'
                                                        : null,
                                                    onSaved: (value) =>
                                                        mobile.value,
                                                    decoration: InputDecoration(
                                                      hintText: "Mobile",
                                                      labelText:
                                                          "Enter Your Mobile",
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
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: <Widget>[
                                                    Container(
                                                      child: Expanded(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 50.0,
                                                                  right: 50.0,
                                                                  top: 10.0,
                                                                  bottom: 10.0),
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 60.0,
                                                            child:
                                                                MaterialButton(
                                                              minWidth: 120.0,
                                                              height: 50.0,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                horizontal:
                                                                    10.0,
                                                              ),
                                                              child: Text(
                                                                "Continue",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                  color: Colors
                                                                      .white70,
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                if (_image ==
                                                                    null) {
                                                                  var snackBar =
                                                                      SnackBar(
                                                                    content: Text(
                                                                        "Please Choose A Profile Picture & Fill Your Details."),
                                                                  );
                                                                  Scaffold.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          snackBar);
                                                                } else {
                                                                  _validateAndSubmit(
                                                                      context);
                                                                }
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
