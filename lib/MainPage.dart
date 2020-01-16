import 'package:dartchat/globalState.dart';
import 'package:dartchat/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:dartchat/signup/sign.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _username = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  final formKey = new GlobalKey<FormState>();
  GlobalState _store = GlobalState.instance;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  bool _validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  Future<List> _loginRequest() async {
    var userName = _username.text;
    var pasSWord = _password.text;

    Map data = {
      'userName': userName.toString(),
      'pasSWord': pasSWord.toString()
    };
    if (_validateAndSave()) {
      final response = await http.post('http://15.206.162.58:3000/user/login/',
          headers: {"Accept": "application/json"}, body: data);
      var responseCode = response.statusCode;
      print('$responseCode');
      final res = json.decode(response.body);

      if (responseCode == 401) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Invalid Input"),
                content: Text("Kindly check your username and password"),
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
        print("User Unauthorized");
      }
      else if (responseCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }),
        );
        final token = res['token'];
        _store.set('token', token);
        final _token = _store.get(token);

        // Navigator.of(context).pushNamed('/HomePage');
        // print(_store.set('token', token));

        if (_token != '') {
          _store.set('token', token);
          // print(token);
        }
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Username And Password Required to Login."),
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
    // return _loginRequest();
    // print (token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            margin: EdgeInsets.only(top: 120.0),
            padding: EdgeInsets.all(1.0),
            alignment: Alignment.topCenter,
            child: Text(
              "Wellcome Aliens",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 25.0,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 200.0),
            padding: EdgeInsets.all(1.0),
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
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Stack(
                              children: <Widget>[
                                SingleChildScrollView(
                                  child: Container(
                                    height: 300.0,
                                    width: 320.0,
                                    margin: EdgeInsets.all(10.0),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                      vertical: 10.0,
                                    ),
                                    child: new Form(
                                      key: formKey,
                                      child: new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 10.0,
                                            ),
                                            child: TextFormField(
                                              controller: _username,
                                              autocorrect: true,
                                              autofocus: false,
                                              style: TextStyle(
                                                fontSize: 15.0,
                                              ),
                                              validator: (value) => value
                                                      .isEmpty
                                                  ? 'username can\'t be empty'
                                                  : null,
                                              onSaved: (value) =>
                                                  _username.value,
                                              decoration: InputDecoration(
                                                hintText: "username",
                                                labelText:
                                                    "Enter Your Username",
                                                // errorText: _validate ? 'Username Can\'t Be Empty' : null,
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
                                              vertical: 25.0,
                                            ),
                                            child: TextFormField(
                                              controller: _password,
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
                                                  _password.value,
                                              decoration: InputDecoration(
                                                hintText: "password",
                                                labelText:
                                                    "Enter Your Password",
                                                //errorText: _validatePass ? 'Password Can\'t Be Empty' : null,
                                                border: InputBorder.none,
                                                filled: true,
                                                fillColor: Colors.white38,
                                                contentPadding:
                                                    EdgeInsets.all(5.0),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                        _loginRequest();
                                                      },
                                                      minWidth: 80.0,
                                                      color: Colors.black54,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 10.0,
                                                      ),
                                                      child: Text(
                                                        "Login",
                                                        style: TextStyle(
                                                          fontSize: 18.0,
                                                          color: Colors.white70,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10.0,
                                                      right: 20.0,
                                                      top: 10.0),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: 60.0,
                                                    child: MaterialButton(
                                                      onPressed: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                          return SignupPage();
                                                        }));
                                                      },
                                                      minWidth: 80.0,
                                                      color: Colors.black54,
                                                      padding: EdgeInsets.only(
                                                        top: 2.0,
                                                      ),
                                                      child: Text(
                                                        "Sign Up",
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
