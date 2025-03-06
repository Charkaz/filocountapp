import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/repositories/project_repository.dart';
import '../datasources/project_local_data_source.dart';
import '../datasources/project_remote_data_source.dart';
import '../models/project_model.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectLocalDataSource localDataSource;
  final ProjectRemoteDataSource remoteDataSource;

  ProjectRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<ProjectEntity>>> getProjects() async {
    try {
      final localProjects = await localDataSource.getProjects();
      return Right(localProjects.map((project) => project.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProjectEntity>>> getProjectsFromRemote() async {
    try {
      final remoteProjects = await remoteDataSource.getProjects();
      // Update local storage with remote data
      await _updateLocalStorage(remoteProjects);
      return Right(
          remoteProjects.map((project) => project.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProject(int id) async {
    try {
      await localDataSource.deleteProject(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  Future<void> _updateLocalStorage(List<ProjectModel> projects) async {
    try {
      // First delete all existing projects
      final existingProjects = await localDataSource.getProjects();
      for (var project in existingProjects) {
        await localDataSource.deleteProject(project.id);
      }

      // Then save all new projects
      for (var project in projects) {
        await localDataSource.addProject(project);
      }
    } catch (e) {
      throw Exception('Error updating local storage: ${e.toString()}');
    }
  }
}
