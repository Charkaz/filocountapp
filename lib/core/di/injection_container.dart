import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import '../../features/counter/data/models/count_model.dart';
import '../../features/line/data/models/line_model.dart';
import '../../features/product/data/models/product_model.dart';
import '../../features/project/data/models/project_model.dart';
import '../services/dio_helper.dart';
import '../../features/home/data/repositories/project_repository_impl.dart';
import '../../features/home/domain/repositories/project_repository.dart';
import '../../features/home/presentation/bloc/project_bloc.dart';
import '../../features/home/data/datasources/project_local_data_source.dart';
import '../../features/counter/domain/usecases/CountService.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Services
  sl.registerSingleton<DioHelper>(DioHelper.instance);

  // Hive Boxes
  final projectBox = await Hive.openBox<ProjectModel>('projects');
  final productBox = await Hive.openBox<ProductModel>('products');
  final lineBox = await Hive.openBox<LineModel>('lines');
  final countBox = await Hive.openBox<CountModel>('counts');

  // Register Boxes
  sl.registerSingleton<Box<ProjectModel>>(projectBox);
  sl.registerSingleton<Box<ProductModel>>(productBox);
  sl.registerSingleton<Box<LineModel>>(lineBox);
  sl.registerSingleton<Box<CountModel>>(countBox);

  // Initialize Services
  await CountService.initializeRepository();

  // Repositories
  sl.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(localDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<ProjectLocalDataSource>(
    () => ProjectLocalDataSourceImpl(projectBox: sl()),
  );

  // BLoCs
  sl.registerFactory(
    () => ProjectBloc(repository: sl()),
  );

  // Use cases
  // TODO: Register your use cases here

  // BLoC / View Models
  // TODO: Register your BLoCs/ViewModels here
}
