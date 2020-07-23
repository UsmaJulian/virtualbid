import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:provider/provider.dart';
import 'package:virtualbidapp/src/pages/home_page.dart';
import 'package:virtualbidapp/src/pages/signinup_page.dart';
import 'package:virtualbidapp/src/services/auth_service.dart';
import 'package:virtualbidapp/src/pages/password_renew.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _email = '';
  String _password = '';
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
        body: Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage('assets/logo/logo.png'),
            height: 200,
            width: 200,
          ),
          Text(
            'Bienvenido',
            style: TextStyle(
                color: Color(0xff005549), fontWeight: FontWeight.w700),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) =>
                    value.isEmpty ? 'Email no puede estar vacio' : null,
                onChanged: (value) {
                  _email = value.trim();
                  setState(() {});
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: TextFormField(
                controller: _passwordController,
                obscureText: _obscureText,
                autofocus: false,
                decoration: InputDecoration(
                    labelText: 'Contraseña',
                    suffixIcon: GestureDetector(
                      child: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )),
                validator: (value) =>
                    value.isEmpty ? 'Password no puede estar vacio' : null,
                onChanged: (value) {
                  _password = value.trim();
                  setState(() {});
                }),
          ),
          ButtonTheme(
            buttonColor: Color(0xff005549),
            minWidth: 260,
            height: 40,
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  'Iniciar sesión ',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w400),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _signInWithEmailAndPassword();
                  }
                }),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PasswordRenew()));
                  },
                  child: Text('Olvidaste tu contraseña?')),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text('Aún no tienes Cuenta? '),
                  FlatButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInUpPage()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Text('Puedes registrarte!',
                          style: TextStyle(color: Color(0xff88ba25))),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 90.0),
              child: GoogleSignInButton(
                text: 'Inicia Sesión con Google',
                borderRadius: 20.0,
                onPressed: () async {
                  await authService.googleSignIn();
                },
              ),
            ),
          ),
        ],
      ),
    ));
  }

  void _signInWithEmailAndPassword() async {
    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ))
        .user;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  userID: user.uid,
                  userInfo: user,
                )));
  }
}
