import 'package:birincisayim/core/services/dio_helper.dart';
import '../models/count_model.dart';

class PostCount {
  static Future<String> post(CountModel count) async {
    try {
      final response = await DioHelper.instance.postData(
        endpoint: '/counts',
        data: count.toJson(),
      );
      return response.data['id'].toString();
    } catch (e) {
      rethrow;
    }
  }
}
