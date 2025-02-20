import 'package:birincisayim/core/repositories/generic_repository.dart';
import 'package:birincisayim/features/product/data/models/product_model.dart';

class ProductRepository extends GenericRepository<ProductModel> {
  ProductRepository() : super('products');

  Future<ProductModel?> getByBarcode(String barcode) async {
    final products = await getAll();
    try {
      return products.firstWhere((product) => product.barcode == barcode);
    } catch (e) {
      return null;
    }
  }
}
