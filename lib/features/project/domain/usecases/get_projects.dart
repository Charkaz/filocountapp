import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/project_entity.dart';
import '../repositories/project_repository.dart';

class GetProjects implements UseCase<List<ProjectEntity>, NoParams> {
  final ProjectRepository repository;

  GetProjects(this.repository);

  @override
  Future<Either<Failure, List<ProjectEntity>>> call(NoParams params) async {
    return await repository.getProjects();
  }
}
