import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'features/counter/data/models/count_model.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'core/services/dio_helper.dart';
import 'features/home/presentation/bloc/project_bloc.dart';
import 'features/line/data/models/line_model.dart';
import 'features/product/data/models/product_model.dart';
import 'features/project/data/models/project_model.dart';
import 'features/product/domain/entities/product_entity.dart';
import 'core/di/injection_container.dart' as di;

final getIt = GetIt.instance;

Future<void> requestCameraPermission() async {
  try {
    final status = await Permission.camera.status;
    if (!status.isGranted) {
      final result = await Permission.camera.request();
      debugPrint('Camera permission result: $result');
      if (!result.isGranted) {
        debugPrint('Camera permission denied');
      }
    } else {
      debugPrint('Camera permission already granted');
    }
  } catch (e) {
    debugPrint('Camera permission error: $e');
  }
}

Future<void> initHive() async {
  try {
    await Hive.initFlutter();
    debugPrint('Hive.initFlutter completed successfully');

    // Register adapters with detailed error handling
    try {
      if (!Hive.isAdapterRegistered(4)) {
        debugPrint('Attempting to register ProductAdapter...');
        Hive.registerAdapter(ProductModelAdapter());
        debugPrint('ProductAdapter registered successfully');
      } else {
        debugPrint('ProductAdapter was already registered');
      }
    } catch (e) {
      debugPrint('Error registering ProductAdapter: $e');
      rethrow;
    }

    try {
      if (!Hive.isAdapterRegistered(0)) {
        debugPrint('Attempting to register ProjectAdapter...');
        Hive.registerAdapter(ProjectModelAdapter());
        debugPrint('ProjectAdapter registered successfully');
      } else {
        debugPrint('ProjectAdapter was already registered');
      }
    } catch (e) {
      debugPrint('Error registering ProjectAdapter: $e');
      rethrow;
    }

    try {
      if (!Hive.isAdapterRegistered(1)) {
        debugPrint('Attempting to register CountAdapter...');
        Hive.registerAdapter(CountModelAdapter());
        debugPrint('CountAdapter registered successfully');
      } else {
        debugPrint('CountAdapter was already registered');
      }
    } catch (e) {
      debugPrint('Error registering CountAdapter: $e');
      rethrow;
    }

    try {
      if (!Hive.isAdapterRegistered(2)) {
        debugPrint('Attempting to register LineAdapter...');
        Hive.registerAdapter(LineModelAdapter());
        debugPrint('LineAdapter registered successfully');
      } else {
        debugPrint('LineAdapter was already registered');
      }
    } catch (e) {
      debugPrint('Error registering LineAdapter: $e');
      rethrow;
    }

    debugPrint('All adapters registration completed');

    // Open boxes with error handling
    try {
      debugPrint('Opening boxes...');
      await Hive.openBox<ProjectModel>('projects');
      await Hive.openBox<CountModel>('counts');
      await Hive.openBox<LineModel>('lines');
      final productsBox = await Hive.openBox<ProductModel>('products');
      debugPrint('All boxes opened successfully');

      // Clear existing products for testing
      await productsBox.clear();
      debugPrint('Cleared existing products');

      // Add sample products
      final sampleProducts = [
        ProductModel(
          id: 1,
          code: "P001",
          name: "Coca Cola 330ml",
          barcode: "8690555012345",
          description: "Coca Cola Kutu 330ml",
        ),
        ProductModel(
          id: 2,
          code: "P002",
          name: "Ülker Çikolatalı Gofret",
          barcode: "8690555067890",
          description: "Ülker Çikolatalı Gofret 40gr",
        ),
        ProductModel(
          id: 3,
          code: "P003",
          name: "Lay's Classic",
          barcode: "8690555098765",
          description: "Lay's Classic Patates Cipsi 150gr",
        ),
        ProductModel(
          id: 4,
          code: "P004",
          name: "Eti Burçak",
          barcode: "8690555034567",
          description: "Eti Burçak Bisküvi 123gr",
        ),
        ProductModel(
          id: 5,
          code: "P005",
          name: "Sütaş Ayran",
          barcode: "8690555089012",
          description: "Sütaş Ayran 300ml",
        ),
        ProductModel(
          id: 6,
          code: "P006",
          name: "Kent Gofret",
          barcode: "8690555023456",
          description: "Kent Gofret 35gr",
        ),
        ProductModel(
          id: 7,
          code: "P007",
          name: "Eti Canga",
          barcode: "8690555045678",
          description: "Eti Canga Çikolata 45gr",
        ),
        ProductModel(
          id: 8,
          code: "P008",
          name: "Pepsi Cola 1L",
          barcode: "8690555078901",
          description: "Pepsi Cola Pet Şişe 1L",
        ),
        ProductModel(
          id: 9,
          code: "P009",
          name: "Sobranie Siqara",
          barcode: "4033100024351",
          description: "Sobranie Siqara",
        ),
      ];

      for (var product in sampleProducts) {
        await productsBox.add(product);
        debugPrint(
            'Added product: ${product.name} with barcode: ${product.barcode}');
      }

      // Verify products were added
      final allProducts = productsBox.values.toList();
      debugPrint('Total products in database: ${allProducts.length}');
      for (var product in allProducts) {
        debugPrint('Stored product: ${product.name} - ${product.barcode}');
      }
    } catch (e) {
      debugPrint('Error opening boxes: $e');
      rethrow;
    }
  } catch (e) {
    debugPrint('Fatal error in initHive: $e');
    rethrow;
  }
}

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    debugPrint('Flutter binding initialized');

    // Request camera permission first
    debugPrint('Requesting camera permission...');
    await requestCameraPermission();
    debugPrint('Camera permission handled');

    // Initialize Hive
    debugPrint('Initializing Hive...');
    await initHive();
    debugPrint('Hive initialized successfully');

    // Initialize services
    debugPrint('Initializing dependencies...');
    await initializeDependencies();
    debugPrint('Dependencies initialized');

    debugPrint('Initializing Dio...');
    await DioHelper.init();
    debugPrint('Dio initialized');

    debugPrint('Starting app...');
    runApp(const MyApp());
  } catch (e, stackTrace) {
    debugPrint('=== ERROR DETAILS ===');
    debugPrint('Error: $e');
    debugPrint('Stack trace: $stackTrace');
    debugPrint('===================');

    runApp(MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Uygulama Başlatılamadı',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  e.toString(),
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  stackTrace.toString().split('\n').take(3).join('\n'),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<ProjectBloc>()..add(LoadProjects()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Birinci Sayım',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomePage(),
      ),
    );
  }
}
