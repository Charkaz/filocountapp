import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../project/data/models/project_model.dart';
import '../../domain/repositories/project_repository.dart';

// Events
abstract class ProjectEvent extends Equatable {
  const ProjectEvent();

  @override
  List<Object?> get props => [];
}

class LoadProjects extends ProjectEvent {}

class CreateProject extends ProjectEvent {
  final String name;
  final String description;
  final String isYeri;
  final String anbar;

  const CreateProject({
    required this.name,
    required this.description,
    required this.isYeri,
    required this.anbar,
  });

  @override
  List<Object?> get props => [name, description, isYeri, anbar];
}

class DeleteProject extends ProjectEvent {
  final String id;

  const DeleteProject({required this.id});

  @override
  List<Object?> get props => [id];
}

// States
abstract class ProjectState extends Equatable {
  const ProjectState();

  @override
  List<Object?> get props => [];
}

class ProjectInitial extends ProjectState {}

class ProjectLoading extends ProjectState {}

class ProjectsLoaded extends ProjectState {
  final List<ProjectModel> projects;

  const ProjectsLoaded({required this.projects});

  @override
  List<Object?> get props => [projects];
}

class ProjectError extends ProjectState {
  final String message;

  const ProjectError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Bloc
class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ProjectRepository repository;

  ProjectBloc({required this.repository}) : super(ProjectInitial()) {
    on<LoadProjects>(_onLoadProjects);
    on<CreateProject>(_onCreateProject);
    on<DeleteProject>(_onDeleteProject);
  }

  Future<void> _onLoadProjects(
    LoadProjects event,
    Emitter<ProjectState> emit,
  ) async {
    emit(ProjectLoading());
    final result = await repository.getProjects();
    result.fold(
      (failure) => emit(ProjectError(message: failure.message)),
      (projects) => emit(ProjectsLoaded(projects: projects)),
    );
  }

  Future<void> _onCreateProject(
    CreateProject event,
    Emitter<ProjectState> emit,
  ) async {
    emit(ProjectLoading());
    final result = await repository.createProject(
      event.description,
      event.isYeri,
      event.anbar,
    );
    if (emit.isDone) return;

    await result.fold(
      (failure) async => emit(ProjectError(message: failure.message)),
      (project) async {
        final projectsResult = await repository.getProjects();
        if (emit.isDone) return;

        await projectsResult.fold(
          (failure) async => emit(ProjectError(message: failure.message)),
          (projects) async => emit(ProjectsLoaded(projects: projects)),
        );
      },
    );
  }

  Future<void> _onDeleteProject(
    DeleteProject event,
    Emitter<ProjectState> emit,
  ) async {
    emit(ProjectLoading());
    final result = await repository.deleteProject(event.id);
    if (emit.isDone) return;

    await result.fold(
      (failure) async => emit(ProjectError(message: failure.message)),
      (_) async {
        final projectsResult = await repository.getProjects();
        if (emit.isDone) return;

        await projectsResult.fold(
          (failure) async => emit(ProjectError(message: failure.message)),
          (projects) async => emit(ProjectsLoaded(projects: projects)),
        );
      },
    );
  }
}
