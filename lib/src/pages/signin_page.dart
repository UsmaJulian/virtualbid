import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:provider/provider.dart';
import 'package:virtualbidapp/src/pages/signinup_page.dart';
import 'package:virtualbidapp/src/services/auth_service.dart';
import 'package:virtualbidapp/src/pages/password_renew.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
        body: Column(
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
          style:
              TextStyle(color: Color(0xff005549), fontWeight: FontWeight.w700),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
              )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: TextFormField(
            obscureText: _obscureText,
            decoration: InputDecoration(
                labelText: 'Contraseña',
                suffixIcon: GestureDetector(
                  child: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onTap: () => _obscureText = !_obscureText,
                )),
          ),
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
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
              ),
              onPressed: () {}),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PasswordRenew()));
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
    ));
  }
}
