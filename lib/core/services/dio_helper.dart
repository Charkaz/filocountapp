import 'package:dio/dio.dart';

class DioHelper {
  static DioHelper? _instance;
  late Dio dio;
  bool isOffline = true; // Default to offline mode

  DioHelper._() {
    dio = Dio(
      BaseOptions(
        baseUrl: isOffline ? 'http://localhost' : 'YOUR_ACTUAL_SERVER_URL',
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (isOffline) {
            // Skip actual network requests in offline mode
            handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.unknown,
                message: 'Offline mode active',
              ),
            );
            return;
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ),
    );
  }

  static DioHelper get instance {
    _instance ??= DioHelper._();
    return _instance!;
  }

  static Future<void> init() async {
    instance; // Initialize the singleton
  }

  void setOfflineMode(bool offline) {
    isOffline = offline;
    dio.options.baseUrl =
        isOffline ? 'http://localhost' : 'YOUR_ACTUAL_SERVER_URL';
  }

  Future<Response> getData({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    if (isOffline) {
      // Return empty success response in offline mode
      return Response(
        requestOptions: RequestOptions(path: endpoint),
        data: [],
        statusCode: 200,
      );
    }

    try {
      final response = await dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> postData({
    required String endpoint,
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParameters,
  }) async {
    if (isOffline) {
      // Return success response in offline mode
      return Response(
        requestOptions: RequestOptions(path: endpoint),
        data: data,
        statusCode: 200,
      );
    }

    try {
      final response = await dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } catch (error) {
      rethrow;
    }
  }
}
