import 'dart:convert';
import 'package:dartchat/globalState.dart';
import 'package:dartchat/signup/imgPicker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController name = new TextEditingController();
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController mobile = new TextEditingController();

  final formKey = new GlobalKey<FormState>();
  GlobalState _store = GlobalState.instance;

  bool _validateAndSave() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void _validateAndSubmit() async {
    var userName = username.text;
    var userEmail = email.text;
    var pasSWord = password.text;

    Map data = {
      'userName': userName.toString(),
      'userEmail': userEmail.toString(),
      'pasSWord': pasSWord.toString(),
    };

    if (_validateAndSave()) {
      final response = await http.post('http://15.206.162.58:3000/user/signUp/',
          headers: {"Accept": "application/json"}, body: data);
      var responseCode = response.statusCode;

      if (responseCode == 409) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("User Registered"),
                content: Text("User Already Registered."),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            });
      } else if (responseCode == 500) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Invalid Email"),
                content: Text("Invalid Email-ID or Email Already Registered"),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            });
      } else if (responseCode == 201) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("User registered"),
                content: Text("User Registration Successful"),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      _loginRequest();
                    },
                  )
                ],
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Error"),
                content: Text("Fields Can't be Empty."),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            });
      }
    }
  }


  _save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);
    if (value != '0') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return ProfileMaker(
              user: username.text,
              mail: email.text,
              currentUser: username.text,
              authKey: value 
            );
        }),
      );
    }
  }

  Future<void> _loginRequest() async {
    var userName = username.text;
    var pasSWord = password.text;

    Map data = {
      'userName': userName.toString(),
      'pasSWord': pasSWord.toString()
    };

    _store.set('username', userName);
    _store.set('password', pasSWord);

    if (_validateAndSave()) {
      final response = await http.post('http://15.206.162.58:3000/user/login/',
          headers: {"Accept": "application/json"}, body: data);
      var responseCode = response.statusCode;
      // print('$responseCode');
      final res = json.decode(response.body);

      if (responseCode == 401) {
        print("User Unauthorized");
      } else if (responseCode == 200) {
        final token = res['token'];
        _save(token);
      }
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
            Navigator.pop(context);
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
              "ENTER YOUR DETAILS TO SIGNUP",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 20.0,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 250.0),
            padding: EdgeInsets.all(5.0),
            alignment: Alignment.center,
            child: CustomScrollView(
              scrollDirection: Axis.vertical,
              shrinkWrap: false,
              slivers: <Widget>[
                new SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  sliver: new SliverList(
                    delegate: new SliverChildBuilderDelegate(
                      (context, index) => new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 0.0),
                            child: Stack(
                              children: <Widget>[
                                SingleChildScrollView(
                                  child: Container(
                                    height: 540.0,
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
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 10.0,
                                            ),
                                            child: TextFormField(
                                              controller: username,
                                              autocorrect: false,
                                              autofocus: false,
                                              style: TextStyle(
                                                fontSize: 15.0,
                                              ),
                                              validator: (value) => value
                                                      .isEmpty
                                                  ? 'username can\'t be empty'
                                                  : null,
                                              onSaved: (value) =>
                                                  username.value,
                                              decoration: InputDecoration(
                                                hintText: "Username *",
                                                labelText:
                                                    "Enter Your Username *",
                                                border: InputBorder.none,
                                                filled: true,
                                                fillColor: Colors.white38,
                                                contentPadding:
                                                    EdgeInsets.all(5.0),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 10.0,
                                            ),
                                            child: TextFormField(
                                              controller: email,
                                              autocorrect: false,
                                              autofocus: false,
                                              style: TextStyle(
                                                fontSize: 15.0,
                                              ),
                                              validator: (value) =>
                                                  value.isEmpty
                                                      ? 'email can\'t be empty'
                                                      : null,
                                              onSaved: (value) => email.value,
                                              decoration: InputDecoration(
                                                hintText: "Email *",
                                                labelText: "Enter Your Email *",
                                                border: InputBorder.none,
                                                filled: true,
                                                fillColor: Colors.white38,
                                                contentPadding:
                                                    EdgeInsets.all(5.0),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 10.0,
                                            ),
                                            child: TextFormField(
                                              controller: password,
                                              autocorrect: false,
                                              autofocus: false,
                                              obscureText: true,
                                              style: TextStyle(
                                                fontSize: 15.0,
                                              ),
                                              validator: (value) => value
                                                      .isEmpty
                                                  ? 'password can\'t be empty'
                                                  : null,
                                              onSaved: (value) =>
                                                  password.value,
                                              decoration: InputDecoration(
                                                hintText: "password *",
                                                labelText:
                                                    "Enter Your Password *",
                                                border: InputBorder.none,
                                                filled: true,
                                                fillColor: Colors.white38,
                                                contentPadding:
                                                    EdgeInsets.all(5.0),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 20.0,
                                                      right: 5.0,
                                                      top: 10.0),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: 60.0,
                                                    child: MaterialButton(
                                                      onPressed: () {
                                                        _validateAndSubmit();
                                                      },
                                                      minWidth: 80.0,
                                                      color: Colors.black54,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 10.0,
                                                      ),
                                                      child: Text(
                                                        "SIGN UP",
                                                        style: TextStyle(
                                                          fontSize: 18.0,
                                                          color: Colors.white70,
                                                        ),
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
