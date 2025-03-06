import '../../data/repositories/count_repository.dart';
import '../../data/models/count_model.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class CountService {
  static late CountRepository repository;
  static final _uuid = Uuid();
  static late Box<CountModel> _box;

  static Future<void> initializeRepository() async {
    _box = await Hive.openBox<CountModel>('counts');
    repository = CountRepository('counts');
    await repository.initialize();
  }

  static Future<CountModel> createCount({
    required String title,
    required int projectId,
  }) async {
    final count = CountModel(
      id: _uuid.v4(),
      projectId: projectId,
      description: title,
      controlGuid: _uuid.v4(),
      lines: [],
      isSend: false,
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
    await initializeRepository();
    return _box.values.where((count) => count.projectId == projectId).toList();
  }

  static Future<List<CountModel>> listCounts() async {
    return await repository.getAll();
  }

  static Future<bool> updateIsSend(String countId) async {
    return await repository.updateIsSend(countId);
  }

  static Future<void> deleteCount(String id) async {
    await _box.delete(id);
  }

  static Future<void> updateCount(CountModel count) async {
    await _box.put(count.id, count);
  }
}
