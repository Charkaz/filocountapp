import 'package:equatable/equatable.dart';
import '../../data/models/project_model.dart';

class ProjectEntity extends Equatable {
  final int id;
  final String name;
  final String description;
  final String isYeri;
  final String anbar;
  final DateTime createdAt;

  const ProjectEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.isYeri,
    required this.anbar,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, description, isYeri, anbar, createdAt];

  ProjectModel toModel() => ProjectModel(
        id: id,
        description: description,
        isYeri: int.parse(isYeri),
        anbar: int.parse(anbar),
        createdAt: createdAt,
      );
}
