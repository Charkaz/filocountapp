import 'package:hive/hive.dart';
import '../../domain/entities/project_entity.dart';

part 'project_model.g.dart';

@HiveType(typeId: 0)
class ProjectModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final int isYeri;

  @HiveField(3)
  final int anbar;

  @HiveField(4)
  final DateTime createdAt;

  ProjectModel({
    required this.id,
    required this.description,
    required this.isYeri,
    required this.anbar,
    required this.createdAt,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      description: json['description'],
      isYeri: json['isYeri'],
      anbar: json['anbar'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'isYeri': isYeri,
      'anbar': anbar,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  ProjectEntity toEntity() => ProjectEntity(
        id: id,
        name: '',
        description: description,
        isYeri: isYeri.toString(),
        anbar: anbar.toString(),
        createdAt: createdAt,
      );
}
