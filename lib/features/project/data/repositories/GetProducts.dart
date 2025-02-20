import 'package:birincisayim/commons/DioHelper.dart';

import 'package:dio/dio.dart';

import '../../../product/data/models/product_model.dart';
import '../../../product/domain/entities/product_entity.dart';

class GetProductsFromApi {
  static Future<List<ProductEntity>> getAllProducts() async {
    var dio = DioHelper.instance;
    Response res = await dio.get("/api/counter/product");
    var data = res.data["data"] as List;
    var products = data.map((e) => ProductModel.fromJson(e)).toList();
    return products.map((e) => e.toEntity()).toList();
  }
}
