import 'package:birincisayim/features/line/data/services/line_service.dart';
import 'package:birincisayim/features/line/domain/repositories/line_repository.dart';
import 'package:dio/dio.dart';
import '../models/count_model.dart';
import '../../../../core/services/settings_service.dart';

class PostCount {
  static Future<int> post(CountModel count) async {
    try {
      final dio = Dio();
      final baseUrl = SettingsService.getBaseUrl();

      var lines = await LineService.getLinesByCount(count.id);

      // API'ye gönderilecek veriyi hazırla
      final Map<String, dynamic> data = {
        "projectId": count.projectId,
        "description": count.description,
        "controlGuid": count.controlGuid,
        "lines": lines
            .map((line) => {
                  "productId": line.product.id,
                  "productCode": line.product.code,
                  "productBarcode": line.product.barcode,
                  "productName": line.product.name,
                  "miqdar": line.quantity,
                })
            .toList(),
      };

      print('Gönderilen veri: $data'); // Debug için

      final response = await dio.post(
        '$baseUrl/api/counter/Counts',
        data: data,
      );

      print('Sunucu yanıtı: ${response.data}'); // Debug için

      return response.statusCode ?? 500;
    } on DioException catch (e) {
      print('DioException: ${e.message}'); // Debug için
      if (e.response != null) {
        print('Hata detayı: ${e.response?.data}'); // Debug için
        return e.response?.statusCode ?? 500;
      }
      throw Exception(e.type == DioExceptionType.connectionError
          ? 'Sunucu ile bağlantı kurulamadı'
          : 'Ağ hatası: ${e.message}');
    } catch (e) {
      print('Genel hata: $e'); // Debug için
      throw Exception('Beklenmeyen bir hata oluştu: $e');
    }
  }
}
