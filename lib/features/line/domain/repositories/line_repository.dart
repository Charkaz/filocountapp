import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/line_entity.dart';

abstract class LineRepository {
  Future<Either<Failure, List<LineEntity>>> getLinesByCount(int countId);
  Future<Either<Failure, LineEntity>> getLineByBarcode({
    required String barcode,
    required int countId,
  });
  Future<Either<Failure, void>> addLine(LineEntity line);
  Future<Either<Failure, void>> updateLine(LineEntity line);
  Future<Either<Failure, void>> deleteLine(int id);
  Future<Either<Failure, void>> updateQuantity(int id, double quantity);
}
