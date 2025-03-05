import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import '../models/product_model.dart';
import '../../../project/data/models/project_model.dart';
import '../../../../core/services/settings_service.dart';

class SyncService {
  static Future<void> syncAll() async {
    await Future.wait([
      syncProducts(),
      syncProjects(),
    ]);
  }

  static Future<void> syncProducts() async {
    try {
      final dio = Dio();
      final settings = await SettingsService.getSettings();
      final baseUrl = 'http://${settings['host']}:${settings['port']}';
      final response = await dio.get('$baseUrl/api/counter/Product');

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        final products = data
            .map((item) => ProductModel(
                  id: item['logicalref'],
                  code: item['code'],
                  name: item['name'],
                  barcode: item['barcode'],
                  description: item['name'],
                ))
            .toList();

        // Hive box'ı aç
        final box = await Hive.openBox<ProductModel>('products');

        // Mevcut ürünleri temizle
        await box.clear();

        // Yeni ürünleri kaydet
        for (var product in products) {
          await box.add(product);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> syncProjects() async {
    try {
      final dio = Dio();
      final settings = await SettingsService.getSettings();
      final baseUrl = 'http://${settings['host']}:${settings['port']}';
      final response = await dio.get('$baseUrl/api/counter/Projects');

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        final projects = data
            .map((item) => ProjectModel(
                  id: item['id'],
                  description: item['aciqlama'],
                  isYeri: item['isYeri'],
                  anbar: item['anbar'],
                  createdAt: DateTime.parse(item['tarix']),
                ))
            .toList();

        final box = await Hive.openBox<ProjectModel>('projects');
        await box.clear();

        for (var project in projects) {
          await box.add(project);
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
