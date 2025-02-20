import 'package:equatable/equatable.dart';

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
}
