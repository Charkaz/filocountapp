import 'package:birincisayim/core/repositories/generic_repository.dart';

import 'package:birincisayim/features/counter/data/models/count_model.dart';

class CountRepository extends GenericRepository<CountModel> {
  CountRepository() : super('counts');

  Future<List<CountModel>> getByProjectId(String projectId) async {
    final box = await openBox();
    final projectIdInt = int.tryParse(projectId) ?? 0;
    return box.values
        .where((count) => count.projectId == projectIdInt)
        .toList();
  }

  Future<bool> updateIsSend(String countId) async {
    final box = await openBox();
    var count = box.values.where((count) => count.id == countId).first;
    await box.put(countId, count.copyWith(isSend: true));
    return true;
  }
}
