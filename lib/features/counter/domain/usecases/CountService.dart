import '../../data/repositories/count_repository.dart';
import '../../data/models/count_model.dart';
import '../../../line/data/models/line_model.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class CountService {
  static late CountRepository repository;
  static final _uuid = Uuid();

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
    final counts = await repository.getByProjectId(projectId);
    return counts..sort((a, b) => b.id.compareTo(a.id));
  }

  static Future<List<CountModel>> listCounts() async {
    return await repository.getAll();
  }

  static Future<bool> updateIsSend(String countId) async {
    return await repository.updateIsSend(countId);
  }

  static Future<void> deleteCount(String countId) async {
    try {
      // Önce sayıma ait satırları sil
      final linesBox = await Hive.openBox<LineModel>('lines');
      final linesToDelete =
          linesBox.values.where((line) => line.countId == countId).toList();
      for (var line in linesToDelete) {
        final key =
            linesBox.keys.firstWhere((k) => linesBox.get(k)?.id == line.id);
        await linesBox.delete(key);
      }

      // Sonra sayımı sil
      final countsBox = await Hive.openBox<CountModel>('counts');
      final countKey =
          countsBox.keys.firstWhere((k) => countsBox.get(k)?.id == countId);
      await countsBox.delete(countKey);
    } catch (e) {
      print('Silme hatası: $e');
      rethrow;
    }
  }
}
