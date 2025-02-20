import 'package:hive/hive.dart';

import '../models/project_model.dart';

class ProjectService {
  static Box<ProjectModel>? _box;

  static Future<void> initializeRepository() async {
    if (_box != null) return;
    _box = await Hive.openBox<ProjectModel>('projects');
  }

  static Future<List<ProjectModel>> listProject() async {
    await initializeRepository();
    return _box!.values.toList();
  }

  static Future<void> clear() async {
    await initializeRepository();
    await _box!.clear();
  }

  static Future<void> insertAll(List<ProjectModel> projects) async {
    await initializeRepository();
    for (var project in projects) {
      await _box!.put(project.id, project);
    }
  }
}
