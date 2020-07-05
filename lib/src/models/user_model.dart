import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class User with ChangeNotifier {
  String id;
  String displayName;
  String photoUrl;
  String email;
  String phone;
  String identityCard;
  int paddle;

  User(
      {this.id,
      this.displayName,
      this.photoUrl,
      this.email,
      this.phone,
      this.identityCard,
      this.paddle});

  factory User.fromFirestore(DocumentSnapshot userDoc) {
    Map userData = userDoc.data;
    return User(
      id: userDoc.documentID,
      displayName: userData['displayName'],
      photoUrl: userData['photoUrl'],
      email: userData['email'],
      phone: userData['phone'],
      identityCard: userData['identityCard'],
      paddle: userData['paddle'],
    );
  }

  void setFromFireStore(DocumentSnapshot userDoc) {
    Map userData = userDoc.data;
    this.id = userDoc.documentID;
    this.displayName = userData['displayName'];
    this.photoUrl = userData['photoUrl'];
    this.email = userData['email'];
    this.phone = userData['phone'];
    this.identityCard = userData['identityCard'];
    this.paddle = userData['paddle'];
    notifyListeners();
  }
}
