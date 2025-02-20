import '../../data/repositories/count_repository.dart';
import '../../data/models/count_model.dart';
import 'package:hive/hive.dart';

class CountService {
  static late CountRepository repository;

  static Future<void> initializeRepository() async {
    final box = await Hive.openBox<CountModel>('counts');
    repository = CountRepository('counts');
    await repository.initialize();
  }

  static Future<CountModel> createCount({
    required String title,
    required int projectId,
  }) async {
    final count = CountModel(
      id: DateTime.now().millisecondsSinceEpoch,
      projectId: projectId,
      description: title,
      controlGuid: DateTime.now().toString(),
      lines: [],
    );
    await repository.insert(count);
    return count;
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
    final counts = await repository.getByProjectId(projectId);
    return counts..sort((a, b) => b.id.compareTo(a.id));
  }

  static Future<List<CountModel>> listCounts() async {
    return await repository.getAll();
  }

  static Future<bool> updateIsSend(int countId) async {
    return await repository.updateIsSend(countId);
  }
}
