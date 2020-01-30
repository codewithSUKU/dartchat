import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String _name = "Admin";

  final String message;
  ChatMessage({this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 8.0,
        bottom: 8.0,
        left: 80.0,
      ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 50,
      decoration: BoxDecoration(
        color: Colors.yellow[100],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          bottomLeft: Radius.circular(15.0),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _name,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.39,
                    margin: EdgeInsets.all(5.0),
                    child: Text(
                      message,
                      maxLines: null,
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 2.0),
              child: CircleAvatar(
                child: Text(
                  _name[0],
                  style: TextStyle(
                    color: Colors.yellowAccent,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
