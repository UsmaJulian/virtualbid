import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:virtualbidapp/src/pages/signin_page.dart';
import 'package:virtualbidapp/src/services/auth_service.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    var actionItems = getListOfActionButtons();
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
            'MIS AJUSTES',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
                color: Color(0xff005549)),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 90.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 2,
          children: List.generate(actionItems.length, (index) {
            return Center(
                child: ButtonTheme(
              colorScheme: ColorScheme.dark(),
              minWidth: 150.0,
              child: actionItems[index],
            ));
          }),
        ),
      ),
    );
  }

  List<Widget> getListOfActionButtons() {
    var actionItems = List<Widget>();

    actionItems.addAll([
      ButtonTheme(
        buttonColor: Color(0xff005549),
        minWidth: 160,
        height: 40,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            "WIFI",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            AppSettings.openWIFISettings();
          },
        ),
      ),
      ButtonTheme(
        buttonColor: Color(0xff005549),
        minWidth: 160,
        height: 40,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            "Bluetooth",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            AppSettings.openBluetoothSettings();
          },
        ),
      ),
      ButtonTheme(
        buttonColor: Color(0xff005549),
        minWidth: 160,
        height: 40,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            "Fecha",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            AppSettings.openDateSettings();
          },
        ),
      ),
      ButtonTheme(
        buttonColor: Color(0xff005549),
        minWidth: 160,
        height: 40,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            "Notificaciones",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            AppSettings.openNotificationSettings();
          },
        ),
      ),
      ButtonTheme(
        buttonColor: Color(0xff005549),
        minWidth: 160,
        height: 40,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            "Sonido",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            AppSettings.openSoundSettings();
          },
        ),
      ),
      ButtonTheme(
        buttonColor: Color(0xff005549),
        minWidth: 160,
        height: 40,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            "Almacenamiento interno",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            AppSettings.openInternalStorageSettings();
          },
        ),
      ),
      ButtonTheme(
        buttonColor: Color(0xff005549),
        minWidth: 160,
        height: 40,
        child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Text(
              'Salir',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              _signOut();
            }),
      )
    ]);

    return actionItems;
  }

  /// Dispose method to close out and cleanup objects.
  @override
  void dispose() {
    super.dispose();
  }

  void _signOut() async {
    AuthService authService = AuthService.instance();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
        (route) => false);
    try {
      await authService.signOut();
    } catch (e) {}
  }
}
