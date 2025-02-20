import 'package:birincisayim/core/repositories/generic_repository.dart';
import 'package:birincisayim/features/project/data/models/project_model.dart';

class ProjectRepository extends GenericRepository<ProjectModel> {
  ProjectRepository() : super('projects');
}
