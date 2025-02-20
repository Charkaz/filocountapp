import 'package:hive/hive.dart';
import '../models/line_model.dart';
import '../../../product/data/models/product_model.dart';
import '../../../counter/data/models/count_model.dart';

class LineService {
  static Box<LineModel>? _box;

  static Future<void> initializeRepository() async {
    if (_box != null) return;
    _box = await Hive.openBox<LineModel>('lines');
  }

  static Future<List<LineModel>> getLinesByCount(int countId) async {
    await initializeRepository();
    final lines =
        _box!.values.where((line) => line.countId == countId).toList();
    lines.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return lines;
  }

  static Future<void> addLine(LineModel line) async {
    await initializeRepository();
    await _box!.add(line);
  }

  static Future<void> updateLine(LineModel line) async {
    await initializeRepository();
    await _box!.put(line.id, line);
  }

  static Future<void> deleteLine(int id) async {
    await initializeRepository();
    final line = _box!.values.firstWhere((line) => line.id == id);
    await line.delete();
  }

  static Future<LineModel?> listLinesByProduct({
    required ProductModel product,
    required CountModel count,
  }) async {
    await initializeRepository();
    try {
      return _box!.values.firstWhere(
        (line) =>
            line.product.barcode == product.barcode && line.countId == count.id,
      );
    } catch (e) {
      return null;
    }
  }
}
