import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  String id;
  String displayName;
  String photoUrl;
  String email;
  String phone;

  int paddle;

  UserModel(
      {this.id,
      this.displayName,
      this.photoUrl,
      this.email,
      this.phone,
      this.paddle});

  factory UserModel.fromFirestore(DocumentSnapshot userDoc) {
    Map userData = userDoc.data();
    return UserModel(
      id: userDoc.id,
      displayName: userData['displayName'],
      photoUrl: userData['photoUrl'],
      email: userData['email'],
      phone: userData['phone'],
      paddle: userData['paddle'],
    );
  }

  void setFromFireStore(DocumentSnapshot userDoc) {
    Map userData = userDoc.data();
    this.id = userDoc.id;
    this.displayName = userData['displayName'];
    this.photoUrl = userData['photoUrl'];
    this.email = userData['email'];
    this.phone = userData['phone'];

    this.paddle = userData['paddle'];
    notifyListeners();
  }
}
