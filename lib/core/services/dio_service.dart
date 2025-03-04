import 'package:dio/dio.dart';
import 'settings_service.dart';

class DioService {
  late final Dio _dio;

  DioService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: SettingsService.getBaseUrl(),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) => status! < 500,
      ),
    );

    // İnterceptors ekleyebiliriz
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));

    // URL değişikliklerini dinle
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Her istekte base URL'i güncelle
        options.baseUrl = SettingsService.getBaseUrl();
        return handler.next(options);
      },
    ));
  }

  Dio get dio => _dio;

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      print('Dio Hatası: ${e.type}');
      print('Hata Mesajı: ${e.message}');
      print('Hata Yanıtı: ${e.response?.data}');
      rethrow;
    }
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      print('Dio Hatası: ${e.type}');
      print('Hata Mesajı: ${e.message}');
      print('Hata Yanıtı: ${e.response?.data}');
      rethrow;
    }
  }
}
