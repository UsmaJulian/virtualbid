import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtualbidapp/src/pages/home_page.dart';
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
  // ignore: unused_field
  String _email = '';
  // ignore: unused_field
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Form(
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
              'Bienvenido Administrador',
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
              child: TextFormField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  autofocus: false,
                  decoration: InputDecoration(
                      labelText: 'Contraseña',
                      suffixIcon: GestureDetector(
                        child: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
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
              ],
            ),
          ],
        ),
      ),
    ));
  }

  void _signInWithEmailAndPassword() async {
    // ignore: unused_local_variable
    final User user = (await _auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ))
        .user;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }
}
