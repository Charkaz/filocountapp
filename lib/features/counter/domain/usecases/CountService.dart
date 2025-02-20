import '../../data/repositories/count_repository.dart';
import '../../data/models/count_model.dart';

class CountService {
  static late CountRepository repository;

  static Future<void> initializeRepository() async {
    repository = CountRepository("Counts");
  }

  static Future<void> insert(CountModel count) async {
    await repository.insert(count);
  }

  static Future<void> insertAll(List<CountModel> counts) async {
    await repository.insertAll(counts);
  }

  static Future<void> clear() async {
    await repository.clear();
  }

  static Future<List<CountModel>> listCountByProj(int projectId) async {
    return await repository.getByProjectId(projectId);
  }

  static Future<List<CountModel>> listCounts() async {
    return await repository.getAll();
  }

  static Future<bool> updateIsSend(int countId) async {
    return await repository.updateIsSend(countId);
  }
}
