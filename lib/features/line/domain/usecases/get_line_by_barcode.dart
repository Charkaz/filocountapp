import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/line_entity.dart';
import '../repositories/line_repository.dart';

class GetLineByBarcode implements UseCase<LineEntity, GetLineByBarcodeParams> {
  final LineRepository repository;

  GetLineByBarcode(this.repository);

  @override
  Future<Either<Failure, LineEntity>> call(
      GetLineByBarcodeParams params) async {
    return await repository.getLineByBarcode(
      barcode: params.barcode,
      countId: params.countId,
    );
  }
}

class GetLineByBarcodeParams extends Equatable {
  final String barcode;
  final int countId;

  const GetLineByBarcodeParams({
    required this.barcode,
    required this.countId,
  });

  @override
  List<Object?> get props => [barcode, countId];
}
