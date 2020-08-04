import 'package:flutter/material.dart';
import 'package:virtualbidapp/src/pages/signin_page.dart';
import 'package:virtualbidapp/src/services/auth_service.dart';
import 'package:provider/provider.dart';

class SignInUpPage extends StatefulWidget {
  @override
  _SignInUpPageState createState() => _SignInUpPageState();
}

class _SignInUpPageState extends State<SignInUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  String name = '';
  String email = '';
  String password = '';
  String phone = '';

  int paddle;
  String error = '';
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
        body: SingleChildScrollView(
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
            'Registro',
            style: TextStyle(
                color: Color(0xff005549), fontWeight: FontWeight.w700),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Nombre completo',
                    ),
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                    validator: (value) =>
                        value.isEmpty ? 'ingresar un nombre' : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    validator: (value) =>
                        value.isEmpty ? 'ingresar un email' : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Teléfono',
                    ),
                    onChanged: (value) {
                      setState(() {
                        phone = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: TextFormField(
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      suffixIcon: GestureDetector(
                        child: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onTap: () => _obscureText = !_obscureText,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    validator: (value) =>
                        value.length < 6 ? 'ingresar una contraseña' : null,
                  ),
                ),
              ],
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
                  'Registrarme',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w400),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    dynamic result =
                        await authService.registerWithEmailAndPassword(
                            email, password, name, phone, paddle);
                    Navigator.pop(context);
                    if (result == null) {
                      setState(() {
                        error = 'que error mostrar';
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Error'),
                            content: Text(error),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Ok'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      });
                    }
                  }
                }),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 90.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text('Ya tienes Cuenta? '),
                    FlatButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 16.0,
                        ),
                        child: Text('Puedes iniciar sesión!',
                            style: TextStyle(color: Color(0xff88ba25))),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
