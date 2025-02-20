import 'package:hive/hive.dart';
import '../models/line_model.dart';

abstract class LineLocalDataSource {
  Future<List<LineModel>> getLinesByCount(int countId);
  Future<LineModel?> getLineByBarcode({
    required String barcode,
    required int countId,
  });
  Future<void> addLine(LineModel line);
  Future<void> updateLine(LineModel line);
  Future<void> deleteLine(int id);
  Future<void> updateQuantity(int id, double quantity);
}

class LineLocalDataSourceImpl implements LineLocalDataSource {
  final Box<LineModel> lineBox;

  LineLocalDataSourceImpl({required this.lineBox});

  @override
  Future<List<LineModel>> getLinesByCount(int countId) async {
    return lineBox.values.where((line) => line.countId == countId).toList();
  }

  @override
  Future<LineModel?> getLineByBarcode({
    required String barcode,
    required int countId,
  }) async {
    try {
      return lineBox.values.firstWhere(
        (line) => line.product.barcode == barcode && line.countId == countId,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addLine(LineModel line) async {
    await lineBox.add(line);
  }

  @override
  Future<void> updateLine(LineModel line) async {
    await lineBox.put(line.id, line);
  }

  @override
  Future<void> deleteLine(int id) async {
    await lineBox.delete(id);
  }

  @override
  Future<void> updateQuantity(int id, double quantity) async {
    final line = lineBox.get(id);
    if (line != null) {
      final updatedLine = LineModel(
        id: line.id,
        countId: line.countId,
        product: line.product,
        quantity: quantity,
        createdAt: line.createdAt,
      );
      await lineBox.put(id, updatedLine);
    }
  }
}
