import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/project_repository.dart';

class DeleteProject implements UseCase<void, DeleteProjectParams> {
  final ProjectRepository repository;

  DeleteProject(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteProjectParams params) async {
    return await repository.deleteProject(params.id);
  }
}

class DeleteProjectParams extends Equatable {
  final int id;

  const DeleteProjectParams({required this.id});

  @override
  List<Object?> get props => [id];
}
