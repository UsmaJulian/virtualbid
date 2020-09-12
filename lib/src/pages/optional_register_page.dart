import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:virtualbidapp/src/pages/home_page.dart';

class OptionalRegister extends StatefulWidget {
  @override
  _OptionalRegisterState createState() => _OptionalRegisterState();
}

class _OptionalRegisterState extends State<OptionalRegister> {
  // ignore: unused_field
  Future<void> _launched;
  String _phone = '+573148930583';
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String phone = '';
  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          title: Center(child: Text('Bienvenido!')),
          content: Text(
            'A continuación te tenemos algunas opciones de registro :',
            textAlign: TextAlign.justify,
          ),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.red),
                )),
            FlatButton(
                onPressed: () {
                  setState(() {
                    _launched = _makePhoneCall('tel:$_phone');
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      FontAwesomeIcons.phoneSquare,
                      color: Color(0xff568a00),
                      size: 15,
                    ),
                    Text('LLamar',
                        style: TextStyle(
                          color: Color(0xff005549),
                        )),
                  ],
                )),
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      FontAwesomeIcons.mailBulk,
                      color: Color(0xff568a00),
                      size: 15,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text('Correo',
                        style: TextStyle(
                          color: Color(0xff005549),
                        )),
                  ],
                )),
          ],
        ),
      );
    });
    super.initState();
  }

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
            'REGISTRO',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              color: Color(0xff005549),
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
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
            //de,para,asunto
            ButtonTheme(
              buttonColor: Color(0xff005549),
              minWidth: 260,
              height: 40,
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    'Enviar Datos',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w400),
                  ),
                  onPressed: () {
                    _sendMail(email, name, phone);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMail(String email, String name, String phone) async {
    final url =
        "mailto:virtualbid2020@gmail.com?subject=Solicitud de información&body=Hola BirtualVid,\n Mi nombre es: $name,\n me gustaria recibir la información necesaria para registro.\n mi correo electronico es : $email \n mi número télefonico es : $phone";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Error en el envio $url';
    }
  }
}
