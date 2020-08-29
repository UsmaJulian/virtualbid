import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:virtualbidapp/src/pages/home_page.dart';
import 'package:virtualbidapp/src/services/user_management.dart';

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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => HomePage()));
                }),
            title: Text(
              'AJUSTES',
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
        floatingActionButton: FloatingActionButton(
            mini: true,
            child: Icon(CupertinoIcons.person_add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  ),
                  title: Center(
                      child: Text(
                    'Bienvenido!!!',
                    style: TextStyle(fontSize: 22.0),
                  )),
                  content: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5.0),
                    child: Text(
                      'Si eres ADMINISTRADOR puedes ingresar.',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancelar ',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    UserManagement().handleAuth()));
                      },
                      child: Text(
                        'Ingresar ',
                        style: TextStyle(
                          color: Color(0xff005549),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }));
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
    ]);

    return actionItems;
  }

  /// Dispose method to close out and cleanup objects.
  @override
  void dispose() {
    super.dispose();
  }
}
