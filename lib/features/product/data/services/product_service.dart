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
}
