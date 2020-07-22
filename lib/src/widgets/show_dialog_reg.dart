import 'package:flutter/material.dart';
import 'package:virtualbidapp/src/pages/home_page.dart';

Future<void> showdialogReg(
  BuildContext context,userID
) {
  return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Colors.white,
          title: Text('Registro exitoso'),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Aceptar',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage(userID: userID)));
              },
            ),
          ],
        );
      });
}
