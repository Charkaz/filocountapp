import 'package:hive/hive.dart';
import '../models/line_model.dart';

abstract class LineLocalDataSource {
  Future<List<LineModel>> getLinesByCount(String countId);
  Future<LineModel?> getLineByBarcode({
    required String barcode,
    required int countId,
  });
  Future<void> addLine(LineModel line);
  Future<void> updateLine(LineModel line);
  Future<void> deleteLine(String id);
  Future<void> updateQuantity(String id, double quantity);
}

class LineLocalDataSourceImpl implements LineLocalDataSource {
  final Box<LineModel> lineBox;

  LineLocalDataSourceImpl({required this.lineBox});

  @override
  Future<List<LineModel>> getLinesByCount(String countId) async {
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
  Future<void> deleteLine(String id) async {
    try {
      final key = lineBox.keys.firstWhere(
        (k) => lineBox.get(k)?.id == id,
        orElse: () => throw Exception('Line not found'),
      );
      await lineBox.delete(key);
    } catch (e) {
      throw Exception('Silme işlemi başarısız: ${e.toString()}');
    }
  }

  @override
  Future<void> updateQuantity(String id, double quantity) async {
    try {
      final key = lineBox.keys.firstWhere(
        (k) => lineBox.get(k)?.id == id,
        orElse: () => throw Exception('Line not found'),
      );
      if (quantity < 0) {
        throw Exception("Miktar eksi olamaz!");
      }
      final line = lineBox.get(key);
      if (line != null) {
        final updatedLine = LineModel(
          id: line.id,
          countId: line.countId,
          product: line.product,
          quantity: quantity,
          createdAt: line.createdAt,
        );
        await lineBox.put(key, updatedLine);
      }
    } catch (e) {
      throw Exception('Miktar güncelleme başarısız: ${e.toString()}');
    }
  }
}
