import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _hostKey = 'api_host';
  static const String _portKey = 'api_port';
  static const String _weightedPrefixKey = 'weighted_prefix';
  static const String _unitPrefixKey = 'unit_prefix';
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveApiSettings({
    required String host,
    required String port,
  }) async {
    await _prefs.setString(_hostKey, host);
    await _prefs.setString(_portKey, port);
  }

  static Future<void> saveBarcodeSettings({
    required String weightedPrefix,
    required String unitPrefix,
  }) async {
    await _prefs.setString(_weightedPrefixKey, weightedPrefix);
    await _prefs.setString(_unitPrefixKey, unitPrefix);
  }

  static String getApiHost() {
    return _prefs.getString(_hostKey) ?? '192.168.1.100';
  }

  static String getApiPort() {
    return _prefs.getString(_portKey) ?? '5000';
  }

  static String getBaseUrl() {
    final host = getApiHost();
    final port = getApiPort();
    return 'http://$host:$port';
  }

  static String getWeightedPrefix() {
    return _prefs.getString(_weightedPrefixKey) ?? '27';
  }

  static String getUnitPrefix() {
    return _prefs.getString(_unitPrefixKey) ?? '29';
  }

  // Barkod tipini ve miktarını hesapla
  static ({bool isWeighted, double? quantity}) parseBarcode(String barcode) {
    final weightedPrefix = getWeightedPrefix();
    final unitPrefix = getUnitPrefix();

    if (barcode.startsWith(weightedPrefix) && barcode.length >= 13) {
      // Çekili ürün - Son 6 hane miktarı temsil eder (000000-999999)
      // Örnek: 2700000123456 -> 12.345 kg
      final weightStr = barcode.substring(7, 13);
      final weight = int.tryParse(weightStr);
      if (weight != null) {
        return (
          isWeighted: true,
          quantity: weight / 1000
        ); // gram -> kg dönüşümü
      }
    } else if (barcode.startsWith(unitPrefix)) {
      // Adetli ürün - Varsayılan miktar 1
      return (isWeighted: false, quantity: 1);
    }

    // Tanımlanamayan barkod
    return (isWeighted: false, quantity: null);
  }
}
