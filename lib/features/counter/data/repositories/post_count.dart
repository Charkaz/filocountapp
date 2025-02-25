import 'package:dio/dio.dart';
import '../models/count_model.dart';

class PostCount {
  static Future<int> post(CountModel count) async {
    try {
      final dio = Dio();

      // API'ye gönderilecek veriyi hazırla
      final Map<String, dynamic> data = {
        "projectId": count.projectId,
        "description": count.description,
        "controlGuid": count.controlGuid,
        "lines": count.lines
            .map((line) => {
                  "productId": line.product.id,
                  "productCode": line.product.code,
                  "productBarcode": line.product.barcode,
                  "productName": line.product.name,
                  "miqdar": line.quantity
                })
            .toList()
      };

      final response = await dio.post(
        'http://192.168.137.1:5000/api/counter/Counts',
        data: data,
      );

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception('Sunucu hatası: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
