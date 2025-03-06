import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/count_model.dart';
import '../../../../core/services/settings_service.dart';
import '../../../line/domain/repositories/line_repository.dart';
import '../../../line/domain/usecases/get_lines_by_count.dart';

class PostCount {
  static Future<int> post(
      CountModel count, LineRepository lineRepository) async {
    try {
      final dio = Dio();
      final baseUrl = SettingsService.getBaseUrl();

      final getLinesByCount = GetLinesByCount(lineRepository);
      final result =
          await getLinesByCount(GetLinesByCountParams(countId: count.id));

      final lines = result.fold(
        (failure) =>
            throw Exception('Satırlar alınamadı: ${failure.toString()}'),
        (lines) => lines,
      );

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

      debugPrint('Gönderilen veri: $data'); // Debug için

      final response = await dio.post(
        '$baseUrl/api/counter/Counts',
        data: data,
      );

      debugPrint('Sunucu yanıtı: ${response.data}'); // Debug için

      return response.statusCode ?? 500;
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}'); // Debug için
      if (e.response != null) {
        debugPrint('Hata detayı: ${e.response?.data}'); // Debug için
        return e.response?.statusCode ?? 500;
      }
      throw Exception(e.type == DioExceptionType.connectionError
          ? 'Sunucu ile bağlantı kurulamadı'
          : 'Ağ hatası: ${e.message}');
    } catch (e) {
      debugPrint('Genel hata: $e'); // Debug için
      throw Exception('Beklenmeyen bir hata oluştu: $e');
    }
  }
}
