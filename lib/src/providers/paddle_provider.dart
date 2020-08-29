import 'package:shared_preferences/shared_preferences.dart';

class UserPaddle {
  static final UserPaddle _instance = new UserPaddle._internal();

  factory UserPaddle() {
    return _instance;
  }
  UserPaddle._internal();
  SharedPreferences _paleta;
  initPrefs() async {
    this._paleta = await SharedPreferences.getInstance();
  }

  get getpaleta {
    return _paleta.getInt('paleta') ?? '';
  }

  set setpaleta(int value) {
    _paleta.setInt('paleta', value);
  }
}
