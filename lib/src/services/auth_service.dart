import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:virtualbidapp/src/models/user_model.dart';

enum AuthStatus {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated
}

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth;
  GoogleSignInAccount _googleUser;
  User _user = new User();

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(id: user.uid) : null;
  }

  final Firestore _db = Firestore.instance;
  AuthStatus _status = AuthStatus.Uninitialized;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  AuthService.instance() : _auth = FirebaseAuth.instance {
    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _status = AuthStatus.Unauthenticated;
    } else {
      DocumentSnapshot userSnap =
          await _db.collection('users').document(firebaseUser.uid).get();

      _user.setFromFireStore(userSnap);
      _status = AuthStatus.Authenticated;
    }
    notifyListeners();
  }

  Future<FirebaseUser> googleSignIn() async {
    _status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      this._googleUser = googleUser;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      AuthResult authResult = await _auth.signInWithCredential(credential);
      FirebaseUser user = authResult.user;
      await updateUserData(user);
    } catch (e) {
      _status = AuthStatus.Uninitialized;
      notifyListeners();
      return null;
    }
    return null;
  }

  Future<FirebaseUser> handleAppleSignIn() async {
    _status = AuthStatus.Authenticating;
    notifyListeners();
    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);
    switch (result.status) {
      case AuthorizationStatus.authorized:
        try {
          print("successfull sign in");
          final AppleIdCredential appleIdCredential = result.credential;
          OAuthProvider oAuthProvider =
              new OAuthProvider(providerId: "apple.com");
          final AuthCredential credential = oAuthProvider.getCredential(
            idToken: String.fromCharCodes(appleIdCredential.identityToken),
            accessToken:
                String.fromCharCodes(appleIdCredential.authorizationCode),
          );
          AuthResult authResult =
              await FirebaseAuth.instance.signInWithCredential(credential);
          FirebaseUser user = authResult.user;
          await updateUserData(user);
        } catch (e) {
          print("error");
          _status = AuthStatus.Uninitialized;
          notifyListeners();
        }
        break;
      case AuthorizationStatus.error:
        print('User auth error');
        break;
      case AuthorizationStatus.cancelled:
        print('User cancelled');
        break;
    }
    return null;
  }

  Future<DocumentSnapshot> updateUserData(FirebaseUser user) async {
    DocumentReference userRef = _db.collection('users').document(user.uid);
    userRef.setData({
      'uid': user.uid,
      'email': user.email,
      'lastSign': DateTime.now(),
      'photoURL': user.photoUrl,
      'displayName': user.displayName,
      'phone': user.phoneNumber,
      'paddle': 0
    }, merge: true);
    DocumentSnapshot userData = await userRef.get();
    return userData;
  }

  Future registerWithEmailAndPassword(
    String email,
    String password,
    String name,
    String phone,
    int paddle,
  ) async {
    _status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser user = result.user;
      _status = AuthStatus.Authenticated;
      await updateUserData(user);
      await _db.collection('users').document(user.uid).updateData({
        'displayName': name,
        'phone': phone,
      });

      notifyListeners();

      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  signOut() {
    _auth.signOut();
    _status = AuthStatus.Unauthenticated;
    notifyListeners();
  }

  AuthStatus get status => _status;
  User get user => _user;
  GoogleSignInAccount get googleUser => _googleUser;
}
