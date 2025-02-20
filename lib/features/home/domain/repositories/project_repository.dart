import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../project/data/models/project_model.dart';

abstract class ProjectRepository {
  Future<Either<Failure, List<ProjectModel>>> getProjects();
  Future<Either<Failure, ProjectModel>> createProject(
    String name,
    String description,
    String isYeri,
    String anbar,
  );
  Future<Either<Failure, void>> deleteProject(String id);
}
