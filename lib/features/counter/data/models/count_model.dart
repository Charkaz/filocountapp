import 'package:hive/hive.dart';

import '../../../line/data/models/line_model.dart';

part 'count_model.g.dart';

@HiveType(typeId: 1)
class CountModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int projectId;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final List<LineModel> lines;

  @HiveField(4)
  bool isSend;

  @HiveField(5)
  final String controlGuid;

  CountModel({
    required this.id,
    required this.projectId,
    required this.description,
    required this.lines,
    this.isSend = false,
    required this.controlGuid,
  });

  factory CountModel.fromJson(Map<String, dynamic> json) {
    return CountModel(
      id: json['id'] as String,
      projectId: json['projectId'] as int,
      description: json['description'] as String,
      lines: (json['lines'] as List).map((e) => LineModel.fromJson(e)).toList(),
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
