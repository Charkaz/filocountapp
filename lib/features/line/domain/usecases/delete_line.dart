import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/line_repository.dart';

class DeleteLine implements UseCase<void, DeleteLineParams> {
  final LineRepository repository;

  DeleteLine(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteLineParams params) async {
    return await repository.deleteLine(params.id);
  }
}

class DeleteLineParams extends Equatable {
  final String id;

  const DeleteLineParams({required this.id});

  @override
  List<Object?> get props => [id];
}
