import 'package:hive/hive.dart';

import '../../../line/data/models/line_model.dart';

part 'count_model.g.dart';

@HiveType(typeId: 1)
class CountModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int projectId;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String controlGuid;

  @HiveField(4)
  bool isSend;

  @HiveField(5)
  final List<LineModel> lines;

  CountModel({
    required this.id,
    required this.projectId,
    required this.description,
    required this.controlGuid,
    this.isSend = false,
    required this.lines,
  });

  factory CountModel.fromJson(Map<String, dynamic> json) {
    return CountModel(
      id: json['id'] as int,
      projectId: json['projectId'] as int,
      description: json['description'] as String,
      controlGuid: json['controlGuid'] as String,
      isSend: json['isSend'] as bool,
      lines: (json['lines'] as List<dynamic>)
          .map((e) => LineModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'description': description,
      'controlGuid': controlGuid,
      'isSend': isSend,
      'lines': lines.map((e) => e.toJson()).toList(),
    };
  }
}
