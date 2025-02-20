import '../../data/repositories/count_repository.dart';
import '../../data/models/count_model.dart';

class CountService {
  static late CountRepository repository;

  static Future<void> initializeRepository() async {
    repository = CountRepository("counts");
  }

  static Future<void> insert(CountModel count) async {
    await initializeRepository();
    await repository.insert(count);
  }

  static Future<void> insertAll(List<CountModel> counts) async {
    await initializeRepository();
    await repository.insertAll(counts);
  }

  static Future<void> clear() async {
    await initializeRepository();
    await repository.clear();
  }

  static Future<List<CountModel>> listCountByProj(int projectId) async {
    await initializeRepository();
    return await repository.getByProjectId(projectId);
  }

  static Future<List<CountModel>> listCounts() async {
    await initializeRepository();
    return await repository.getAll();
  }

  static Future<bool> updateIsSend(int countId) async {
    await initializeRepository();
    return await repository.updateIsSend(countId);
  }
}
