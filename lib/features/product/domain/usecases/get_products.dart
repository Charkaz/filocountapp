import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';
import 'package:equatable/equatable.dart';

class GetProducts implements UseCase<List<ProductEntity>, NoParams> {
  final ProductRepository repository;

  GetProducts(this.repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(NoParams params) async {
    return await repository.getProducts();
  }
}

class GetProductByBarcode
    implements UseCase<ProductEntity?, GetProductByBarcodeParams> {
  final ProductRepository repository;

  GetProductByBarcode(this.repository);

  @override
  Future<Either<Failure, ProductEntity?>> call(
      GetProductByBarcodeParams params) async {
    return await repository.getProductByBarcode(params.barcode);
  }
}

class GetProductByBarcodeParams extends Equatable {
  final String barcode;

  const GetProductByBarcodeParams({required this.barcode});

  @override
  List<Object?> get props => [barcode];
}
