import 'package:flutter/foundation.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../data/datasources/product_local_data_source.dart';
import '../../domain/entities/product_entity.dart';
import 'package:hive/hive.dart';
import '../../data/models/product_model.dart';

class ProductService {
  static late ProductRepositoryImpl repository;

  static Future<void> initializeRepository() async {
    final box = await Hive.openBox<ProductModel>('products');
    final dataSource = ProductLocalDataSourceImpl(productBox: box);
    repository = ProductRepositoryImpl(localDataSource: dataSource);
  }

  static Future<void> insertAll(List<ProductEntity> products) async {
    for (var product in products) {
      await repository.addProduct(product);
    }
  }

  static Future<void> clear() async {
    // Clear functionality will need to be implemented in repository if needed
  }

  static Future<List<ProductEntity>> listProject() async {
    final result = await repository.getProducts();
    return result.fold(
      (failure) => [],
      (products) => products,
    );
  }

  static Future<ProductEntity?> getByBarcode(String barcode) async {
    debugPrint('ProductService.getByBarcode called with barcode: $barcode');
    final result = await repository.getProductByBarcode(barcode);
    return result.fold(
      (failure) => null,
      (product) => product,
    );
  }
}
