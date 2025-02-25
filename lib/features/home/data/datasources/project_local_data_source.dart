import 'package:hive/hive.dart';
import '../../../project/data/models/project_model.dart';

abstract class ProjectLocalDataSource {
  Future<List<ProjectModel>> getProjects();
  Future<ProjectModel> createProject(
    String description,
    String isYeri,
    String anbar,
  );
  Future<void> deleteProject(String id);
}

class ProjectLocalDataSourceImpl implements ProjectLocalDataSource {
  final Box<ProjectModel> projectBox;

  ProjectLocalDataSourceImpl({required this.projectBox});

  @override
  Future<List<ProjectModel>> getProjects() async {
    return projectBox.values.toList();
  }

  @override
  Future<ProjectModel> createProject(
    String description,
    String isYeri,
    String anbar,
  ) async {
    final project = ProjectModel(
      id: (DateTime.now().millisecondsSinceEpoch.toInt() / 10000).toInt(),
      description: description,
      isYeri: int.parse(isYeri),
      anbar: int.parse(anbar),
      createdAt: DateTime.now(),
    );
    await projectBox.put(project.id, project);
    return project;
  }

  @override
  Future<void> deleteProject(String id) async {
    await projectBox.delete(id);
  }
}
