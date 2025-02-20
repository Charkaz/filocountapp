import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'product_entity.g.dart';

@HiveType(typeId: 5)
class ProductEntity extends Equatable {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String code;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String barcode;

  @HiveField(4)
  final String description;

  const ProductEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.barcode,
    required this.description,
  });

  @override
  List<Object?> get props => [id, code, name, barcode, description];

  factory ProductEntity.fromJson(Map<String, dynamic> json) {
    return ProductEntity(
      id: json['id'] as int,
      code: json['code'] as String,
      name: json['name'] as String,
      barcode: json['barcode'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'barcode': barcode,
      'description': description,
    };
  }
}
