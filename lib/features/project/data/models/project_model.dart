import 'package:hive/hive.dart';
import '../../domain/entities/project_entity.dart';

part 'project_model.g.dart';

@HiveType(typeId: 0)
class ProjectModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String isYeri;

  @HiveField(4)
  final String anbar;

  @HiveField(5)
  final DateTime createdAt;

  ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.isYeri,
    required this.anbar,
    required this.createdAt,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      isYeri: json['isYeri'] as String,
      anbar: json['anbar'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isYeri': isYeri,
      'anbar': anbar,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  ProjectEntity toEntity() => ProjectEntity(
        id: id,
        name: name,
        description: description,
        isYeri: isYeri,
        anbar: anbar,
        createdAt: createdAt,
      );
}
