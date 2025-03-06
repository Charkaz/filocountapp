import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      final products = await localDataSource.getProducts();
      return Right(products.map((model) => model.toEntity()).toList());
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, ProductEntity?>> getProductByBarcode(
      String barcode) async {
    try {
      final product = await localDataSource.getProductByBarcode(barcode);
      return Right(product?.toEntity());
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addProduct(ProductEntity product) async {
    try {
      await localDataSource.addProduct(ProductModel.fromEntity(product));
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(ProductEntity product) async {
    try {
      await localDataSource.updateProduct(ProductModel.fromEntity(product));
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      await localDataSource.deleteProduct(id);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }
}
