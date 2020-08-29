import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:virtualbidapp/src/pages/home_page.dart';
import 'package:virtualbidapp/src/pages/manage_streaming_page.dart';
import 'package:virtualbidapp/src/pages/signin_page.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class UserManagement {
  Widget handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return UserManagement().autorizeAccess(context) ?? Container();
        }
        return SignInPage();
      },
    );
  }

  autorizeAccess(BuildContext context) {
    final user = _auth.currentUser;
    print(user.uid);
    FirebaseFirestore.instance
        .collection('/users')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((documents) {
      documents.docs.forEach((element) async {
        if (await element.data()['role'] == 'admin') {
          Navigator.pop(context);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ManageStream()));
        } else {
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomePage()));
        }
      });
    });
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }
}
