import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtualbidapp/src/pages/home_page.dart';

class WelcomePage extends StatefulWidget {
  final authservice;

  const WelcomePage({Key key, this.authservice}) : super(key: key);
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Timer timer;
  @override
  void initState() {
    timer = new Timer(Duration(seconds: 1), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Bienvenido',
            style: TextStyle(
              color: Color(0xff005549),
              fontFamily: 'Roboto',
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          CupertinoActivityIndicator()
        ],
      ),
    ));
  }
}
