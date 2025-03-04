import 'package:shared_preferences/shared_preferences.dart';

class BarcodeService {
  static const String _weightedPrefixKey = 'weighted_prefix';
  static const String _unitPrefixKey = 'unit_prefix';

  static Future<String> getWeightedPrefix() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_weightedPrefixKey) ?? '27';
  }

  static Future<String> getUnitPrefix() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_unitPrefixKey) ?? '29';
  }

  static Future<void> saveBarcodeSettings({
    required String weightedPrefix,
    required String unitPrefix,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_weightedPrefixKey, weightedPrefix);
    await prefs.setString(_unitPrefixKey, unitPrefix);
  }

  static Future<BarcodeParseResult> parseBarcode(String barcode) async {
    final weightedPrefix = await getWeightedPrefix();
    final unitPrefix = await getUnitPrefix();

    if (barcode.startsWith(weightedPrefix)) {
      // For weighted products, extract quantity from barcode
      // Format: PPPPPPWWWWWC where P=product code, W=weight in grams, C=check digit
      final productCode = barcode.substring(0, 6);
      final weightInGrams = int.tryParse(barcode.substring(6, 11)) ?? 0;
      final quantity = weightInGrams / 1000.0; // Convert grams to kilograms

      return BarcodeParseResult(
        type: BarcodeType.weighted,
        productBarcode: productCode,
        quantity: quantity,
      );
    } else if (barcode.startsWith(unitPrefix)) {
      // For unit products, extract quantity from barcode
      // Format: PPPPPPQQQQC where P=product code, Q=quantity, C=check digit
      final productCode = barcode.substring(0, 6);
      final quantity = int.tryParse(barcode.substring(6, 10)) ?? 1;

      return BarcodeParseResult(
        type: BarcodeType.unit,
        productBarcode: productCode,
        quantity: quantity.toDouble(),
      );
    } else {
      // Regular barcode, no quantity information
      return BarcodeParseResult(
        type: BarcodeType.regular,
        productBarcode: barcode,
        quantity: 1,
      );
    }
  }
}

enum BarcodeType {
  weighted,
  unit,
  regular,
}

class BarcodeParseResult {
  final BarcodeType type;
  final String productBarcode;
  final double quantity;

  BarcodeParseResult({
    required this.type,
    required this.productBarcode,
    required this.quantity,
  });
}
