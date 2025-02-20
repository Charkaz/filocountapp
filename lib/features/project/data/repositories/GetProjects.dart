import 'package:birincisayim/core/services/dio_helper.dart';
import '../models/project_model.dart';

class GetProjectsFromApi {
  static Future<List<ProjectModel>> getAllProjects() async {
    try {
      final response = await DioHelper.instance.getData(endpoint: '/projects');
      return (response.data as List)
          .map((json) => ProjectModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
