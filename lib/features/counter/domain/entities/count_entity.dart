import 'package:equatable/equatable.dart';
import '../../../line/domain/entities/line_entity.dart';

class CountEntity extends Equatable {
  final int id;
  final int projectId;
  final String description;
  final String controlGuid;
  final bool isSend;
  final List<LineEntity>? lines;

  const CountEntity({
    required this.id,
    required this.projectId,
    required this.controlGuid,
    required this.description,
    this.isSend = false,
    this.lines,
  });

  @override
  List<Object?> get props => [
        id,
        projectId,
        controlGuid,
        description,
        isSend,
        lines,
      ];
}
