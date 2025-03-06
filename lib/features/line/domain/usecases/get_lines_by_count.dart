import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/line_entity.dart';
import '../repositories/line_repository.dart';

class GetLinesByCount
    implements UseCase<List<LineEntity>, GetLinesByCountParams> {
  final LineRepository repository;

  GetLinesByCount(this.repository);

  @override
  Future<Either<Failure, List<LineEntity>>> call(
      GetLinesByCountParams params) async {
    return await repository.getLinesByCount(params.countId);
  }
}

class GetLinesByCountParams extends Equatable {
  final String countId;

  const GetLinesByCountParams({required this.countId});

  @override
  List<Object?> get props => [countId];
}
