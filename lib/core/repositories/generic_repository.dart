import 'package:hive_flutter/hive_flutter.dart';

class GenericRepository<T> {
  final String boxName;

  GenericRepository(this.boxName);

  Future<Box<T>> openBox() async {
    return await Hive.openBox<T>(boxName);
  }

  Future<void> insert(T item) async {
    final box = await openBox();
    await box.add(item);
    print("Eklendi: $item");
  }

  Future<void> insertAll(List<T> items) async {
    final box = await openBox();
    await box.addAll(items);
    print("${items.length} öğe eklendi.");
  }

  Future<void> update(String id, T item) async {
    final box = await openBox();
    await box.put(id, item);
    print("Güncellendi: $item");
  }

  Future<void> delete(String id) async {
    final box = await openBox();
    await box.delete(id);
    print("Silindi: $id");
  }

  Future<List<T>> getAll() async {
    final box = await openBox();
    return box.values.toList();
  }

  Future<T?> getById(String id) async {
    final box = await openBox();
    return box.get(id);
  }

  Future<void> clear() async {
    final box = await openBox();
    await box.clear();
    print("Tüm veriler silindi.");
  }
}
