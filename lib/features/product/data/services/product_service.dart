import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import '../models/product_model.dart';

class ProductService {
  static Box<ProductModel>? _box;

  static Future<void> initializeRepository() async {
    if (_box != null) return;
    _box = await Hive.openBox<ProductModel>('products');
  }

  static Future<List<ProductModel>> listProject() async {
    await initializeRepository();
    return _box!.values.toList();
  }

  static Future<ProductModel?> getByBarcode(String barcode) async {
    await initializeRepository();
    try {
      return _box!.values.firstWhere(
        (product) => product.barcode == barcode,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<void> addProduct(ProductModel product) async {
    await initializeRepository();
    await _box!.put(product.id, product);
  }

  static Future<void> updateProduct(ProductModel product) async {
    await initializeRepository();
    await _box!.put(product.id, product);
  }

  static Future<void> deleteProduct(String id) async {
    await initializeRepository();
    await _box!.delete(id);
  }

  static Future<void> clear() async {
    await initializeRepository();
    await _box!.clear();
  }

  static Future<void> insertAll(List<ProductModel> products) async {
    await initializeRepository();
    for (var product in products) {
      await _box!.put(product.id, product);
    }
  }

  static Future<void> syncProducts() async {
    try {
      final dio = Dio();
      final response =
          await dio.get('http://192.168.137.1:5000/api/counter/Product');

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        final products = data
            .map((item) => ProductModel(
                  id: item['logicalref'],
                  code: item['code'],
                  name: item['name'],
                  barcode: item['barcode'],
                  description: item[
                      'name'], // API'den description gelmediği için name'i kullanıyoruz
                ))
            .toList();

        // Hive box'ı aç
        final box = await Hive.openBox<ProductModel>('products');

        // Mevcut ürünleri temizle
        await box.clear();

        // Yeni ürünleri kaydet
        for (var product in products) {
          await box.add(product);
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
