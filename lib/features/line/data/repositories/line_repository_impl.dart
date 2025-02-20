import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/line_entity.dart';
import '../../domain/repositories/line_repository.dart';
import '../datasources/line_local_data_source.dart';
import '../models/line_model.dart';

class LineRepositoryImpl implements LineRepository {
  final LineLocalDataSource localDataSource;

  LineRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<LineEntity>>> getLinesByCount(int countId) async {
    try {
      final lines = await localDataSource.getLinesByCount(countId);
      return Right(lines.map((line) => line.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LineEntity>> getLineByBarcode({
    required String barcode,
    required int countId,
  }) async {
    try {
      final line = await localDataSource.getLineByBarcode(
        barcode: barcode,
        countId: countId,
      );
      if (line != null) {
        return Right(line.toEntity());
      } else {
        return const Left(CacheFailure(message: 'Line not found'));
      }
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addLine(LineEntity line) async {
    try {
      await localDataSource.addLine(LineModel.fromEntity(line));
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateLine(LineEntity line) async {
    try {
      await localDataSource.updateLine(LineModel.fromEntity(line));
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteLine(int id) async {
    try {
      await localDataSource.deleteLine(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateQuantity(int id, double quantity) async {
    try {
      await localDataSource.updateQuantity(id, quantity);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}
