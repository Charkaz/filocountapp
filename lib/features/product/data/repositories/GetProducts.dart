import 'package:birincisayim/core/services/dio_helper.dart';
import '../models/product_model.dart';

class GetProductsFromApi {
  static Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await DioHelper.instance.getData(endpoint: '/products');
      return (response.data as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
