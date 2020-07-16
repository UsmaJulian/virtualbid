import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MessagesPage extends StatefulWidget {
  final args;

  const MessagesPage({this.args});
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(25),
            ),
          ),
          backgroundColor: Color(0xff88ba25),
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(
                FontAwesomeIcons.angleLeft,
                color: Color(0xff005549),
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            'MIS MENSAJES',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
                color: Color(0xff005549)),
          ),
        ),
      ),
      body: Center(
          child: widget.args != null
              ? Text(widget.args)
              : Text('No tienes mensajes')),
    );
  }
}
