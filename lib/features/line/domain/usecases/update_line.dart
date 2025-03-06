import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/line_entity.dart';
import '../repositories/line_repository.dart';

class UpdateLine implements UseCase<void, UpdateLineParams> {
  final LineRepository repository;

  UpdateLine(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateLineParams params) async {
    return await repository.updateLine(params.line);
  }
}

class UpdateLineParams extends Equatable {
  final LineEntity line;

  const UpdateLineParams({required this.line});

  @override
  List<Object?> get props => [line];
}
