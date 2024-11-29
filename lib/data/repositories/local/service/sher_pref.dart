import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesCustom{

  Future<String> getPass() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('password') ?? '';
  }

  Future<String> getLogin() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('login') ?? '';
  }

  Future<String> getCompany() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('company') ?? '';
  }

  Future<void> set({required String? login, required String? password, required String? company}) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (login != null) prefs.setString('login', login);
    if (password != null) prefs.setString('password', password);
    if (company != null) prefs.setString('company', company);
  }
}