import 'package:hive/hive.dart';
import '../../domain/entities/line_entity.dart';
import '../models/line_model.dart';

class LineService {
  static Box<LineModel>? _box;

  static Future<void> initializeRepository() async {
    if (_box != null) return;
    _box = await Hive.openBox<LineModel>('lines');
  }

  static Future<List<LineEntity>> getLinesByCount(int countId) async {
    await initializeRepository();
    final lines =
        _box!.values.where((line) => line.countId == countId).toList();
    return lines
        .map((line) => LineEntity(
              id: line.id,
              countId: line.countId,
              product: line.product,
              quantity: line.quantity,
              createdAt: line.createdAt,
            ))
        .toList();
  }

  static Future<LineEntity?> getLineByBarcode({
    required String barcode,
    required int countId,
  }) async {
    await initializeRepository();
    try {
      final line = _box!.values.firstWhere(
        (line) => line.product.barcode == barcode && line.countId == countId,
      );
      return LineEntity(
        id: line.id,
        countId: line.countId,
        product: line.product,
        quantity: line.quantity,
        createdAt: line.createdAt,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<void> addLine(LineEntity line) async {
    await initializeRepository();
    await _box!.add(LineModel.fromEntity(line));
  }

  static Future<void> updateLine(LineEntity line) async {
    await initializeRepository();
    await _box!.put(line.id, LineModel.fromEntity(line));
  }

  static Future<void> deleteLine(int id) async {
    await initializeRepository();
    await _box!.delete(id);
  }

  static Future<void> updateQuantity(int id, double quantity) async {
    await initializeRepository();
    final line = _box!.get(id);
    if (line != null) {
      final updatedLine = LineModel(
        id: line.id,
        countId: line.countId,
        product: line.product,
        quantity: quantity,
        createdAt: line.createdAt,
      );
      await _box!.put(id, updatedLine);
    }
  }
}
