import 'package:hive/hive.dart';
import '../models/project_model.dart';

abstract class ProjectLocalDataSource {
  Future<List<ProjectModel>> getProjects();
  Future<void> deleteProject(int id);
  Future<void> addProject(ProjectModel project);
}

class ProjectLocalDataSourceImpl implements ProjectLocalDataSource {
  final Box<ProjectModel> projectBox;

  ProjectLocalDataSourceImpl({required this.projectBox});

  @override
  Future<List<ProjectModel>> getProjects() async {
    return projectBox.values.toList();
  }

  @override
  Future<void> deleteProject(int id) async {
    try {
      final key = projectBox.keys.firstWhere(
        (k) => projectBox.get(k)?.id == id,
        orElse: () => throw Exception('Project not found'),
      );
      await projectBox.delete(key);
    } catch (e) {
      throw Exception('Silme işlemi başarısız: ${e.toString()}');
    }
  }

  @override
  Future<void> addProject(ProjectModel project) async {
    await projectBox.put(project.id, project);
  }
}
