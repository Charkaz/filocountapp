import 'package:birincisayim/core/repositories/generic_repository.dart';
import '../models/count_model.dart';

class CountRepository extends GenericRepository<CountModel> {
  CountRepository(String boxName) : super(boxName);

  Future<List<CountModel>> getByProjectId(int projectId) async {
    final box = await openBox();
    return box.values.where((count) => count.projectId == projectId).toList();
  }

  Future<bool> updateIsSend(String countId) async {
    final box = await openBox();
    var count = box.values.firstWhere((count) => count.id == countId);
    await box.put(countId, count.copyWith(isSend: true));
    return true;
  }

  Future<void> initialize() async {
    await openBox();
  }
}
