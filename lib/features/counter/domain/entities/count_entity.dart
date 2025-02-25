import 'package:equatable/equatable.dart';
import '../../../line/domain/entities/line_entity.dart';

class CountEntity extends Equatable {
  final int id;
  final int projectId;
  final String description;
  final List<LineEntity> lines;
  final bool isSend;
  final String controlGuid;

  const CountEntity({
    required this.id,
    required this.projectId,
    required this.description,
    required this.lines,
    required this.isSend,
    required this.controlGuid,
  });

  @override
  List<Object?> get props =>
      [id, projectId, description, lines, isSend, controlGuid];

  factory CountEntity.fromJson(Map<String, dynamic> json) {
    return CountEntity(
      id: json['id'] as int,
      projectId: json['projectId'] as int,
      description: json['description'] as String,
      lines:
          (json['lines'] as List).map((e) => LineEntity.fromJson(e)).toList(),
      isSend: json['isSend'] as bool? ?? false,
      controlGuid: json['controlGuid'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'description': description,
      'lines': lines.map((e) => e.toJson()).toList(),
      'isSend': isSend,
      'controlGuid': controlGuid,
    };
  }
}
