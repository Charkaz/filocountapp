import 'package:hive/hive.dart';
import '../../../product/data/models/product_model.dart';
import '../../../counter/data/models/count_model.dart';
import '../../data/models/line_model.dart';

class LineService {
  static Box<LineModel>? _box;

  static Future<void> initializeRepository() async {
    if (_box != null) return;
    _box = await Hive.openBox<LineModel>('lines');
  }

  static Future<void> addLine(LineModel line) async {
    await initializeRepository();
    await _box!.add(line);
  }

  static Future<void> updateLine(LineModel line) async {
    await initializeRepository();
    await _box!.put(line.id, line);
  }

  static Future<void> deleteLine(String id) async {
    await initializeRepository();
    await _box!.delete(id);
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
