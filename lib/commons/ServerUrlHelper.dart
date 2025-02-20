import 'package:shared_preferences/shared_preferences.dart';

class ServerUrlHelper{

  static Future<void> setUrl(String ipAddress) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('url', ipAddress);
  }

  static Future<String?> getUrl() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('url');
  }
}