import 'package:hive/hive.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel?> getProductByBarcode(String barcode);
  Future<void> addProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final Box<ProductModel> productBox;

  ProductLocalDataSourceImpl({required this.productBox});

  @override
  Future<List<ProductModel>> getProducts() async {
    return productBox.values.toList();
  }

  @override
  Future<ProductModel?> getProductByBarcode(String barcode) async {
    try {
      return productBox.values.firstWhere(
        (product) => product.barcode == barcode,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addProduct(ProductModel product) async {
    await productBox.put(product.id, product);
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    await productBox.put(product.id, product);
  }

  @override
  Future<void> deleteProduct(String id) async {
    await productBox.delete(id);
  }
}
