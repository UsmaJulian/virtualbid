import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:virtualbidapp/src/pages/home_page.dart';

import 'package:virtualbidapp/src/pages/signin_page.dart';

import 'package:virtualbidapp/src/services/auth_service.dart';

void main() {
  initializeDateFormatting().then((_) {
    WidgetsFlutterBinding.ensureInitialized();

    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthService.instance(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Virtual Bid',
        theme: ThemeData(
          primaryColor: Color(0xff568a00),
          fontFamily: 'Roboto',
          primaryIconTheme: IconThemeData(
            color: Color(0xff005549),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Consumer(builder: (context, AuthService authService, _) {
          switch (authService.status) {
            case AuthStatus.Uninitialized:
              return Scaffold(
                  body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Bienvenido',
                      style: TextStyle(
                        color: Color(0xff005549),
                        fontFamily: 'Roboto',
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    CupertinoActivityIndicator()
                  ],
                ),
              ));
            case AuthStatus.Authenticated:
              return HomePage(
                userID: authService.user.id,
                userInfo: authService.user,
              );
            case AuthStatus.Authenticating:
              return SignInPage();
            case AuthStatus.Unauthenticated:
              return SignInPage();
          }
          return null;
        }),
      ),
    );
  }
}
