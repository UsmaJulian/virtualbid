import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:virtualbidapp/src/pages/messages_page.dart';
import 'package:virtualbidapp/src/pages/welcome_page.dart';
import 'package:virtualbidapp/src/providers/paddle_provider.dart';
import 'package:virtualbidapp/src/providers/push_notifications_provider.dart';

// ignore: non_constant_identifier_names
bool USE_FIRESTORE_EMULATOR = false;
void main() async {
  final UserPaddle _paddle = new UserPaddle();
  WidgetsFlutterBinding.ensureInitialized();
  _paddle.initPrefs();
  await Firebase.initializeApp();
  if (USE_FIRESTORE_EMULATOR) {
    FirebaseFirestore.instance.settings = Settings(
        host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
  }
  initializeDateFormatting().then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  @override
  void initState() {
    final pushProvider = new PushNotificationsProvider();
    pushProvider.intiNotifications();
    pushProvider.mensajesStream.listen((argumento) {
      print('argumento en el main: $argumento');
      // Navigator.pushNamed(context, 'message');
      navigatorKey.currentState.pushNamed('message', arguments: argumento);
    });
    initPlatformState();
    super.initState();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Virtual Bid',
      theme: ThemeData(
        accentColor: Color(0xff005549),
        primaryColor: Color(0xff568a00),
        fontFamily: 'Roboto',
        primaryIconTheme: IconThemeData(
          color: Color(0xff005549),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => WelcomePage(),
        'message': (BuildContext context) => MessagesPage(),
      },
    );
  }
}
