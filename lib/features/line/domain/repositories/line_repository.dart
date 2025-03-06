import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/line_entity.dart';

abstract class LineRepository {
  Future<Either<Failure, List<LineEntity>>> getLinesByCount(String countId);
  Future<Either<Failure, LineEntity>> getLineByBarcode({
    required String barcode,
    required int countId,
  });
  Future<Either<Failure, void>> addLine(LineEntity line);
  Future<Either<Failure, void>> updateLine(LineEntity line);
  Future<Either<Failure, void>> deleteLine(String id);
  Future<Either<Failure, void>> updateQuantity(String id, double quantity);
}
