import 'package:birincisayim/features/project/data/models/project_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

import '../../domain/repositories/project_repository.dart';
import '../datasources/project_local_data_source.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectLocalDataSource localDataSource;

  ProjectRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<ProjectModel>>> getProjects() async {
    try {
      final projects = await localDataSource.getProjects();
      return Right(projects);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProjectModel>> createProject(
    String name,
    String description,
    String isYeri,
    String anbar,
  ) async {
    try {
      final project = await localDataSource.createProject(
        name,
        description,
        isYeri,
        anbar,
      );
      return Right(project);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProject(String id) async {
    try {
      await localDataSource.deleteProject(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}
