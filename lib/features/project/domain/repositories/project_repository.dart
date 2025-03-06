import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/project_entity.dart';

abstract class ProjectRepository {
  Future<Either<Failure, List<ProjectEntity>>> getProjects();
  Future<Either<Failure, List<ProjectEntity>>> getProjectsFromRemote();
  Future<Either<Failure, void>> deleteProject(int id);
}
