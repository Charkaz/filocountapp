import 'package:birincisayim/commons/ServerUrlHelper.dart';
import 'package:dio/dio.dart';

class DioHelper {
  DioHelper._();

  static final Dio _dio = Dio();

  static Dio get instance => _dio;
  
  static Future<void> init() async {
    var ipAddress = await ServerUrlHelper.getUrl();
    if(ipAddress == ""){
      ipAddress = "http://localhost";
    }
    _dio.options = BaseOptions(
      baseUrl: "http://$ipAddress", // Base URL
      headers: {
        "Accept": "application/json",
      },
    );
  }
}
