import '../../../../core/services/dio_helper.dart';
import '../models/project_model.dart';

abstract class ProjectRemoteDataSource {
  Future<List<ProjectModel>> getProjects();
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final DioHelper dioHelper;

  ProjectRemoteDataSourceImpl({required this.dioHelper});

  @override
  Future<List<ProjectModel>> getProjects() async {
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
