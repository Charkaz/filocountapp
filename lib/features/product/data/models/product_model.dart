import 'package:hive/hive.dart';
import '../../domain/entities/product_entity.dart';

part 'product_model.g.dart';

@HiveType(typeId: 4)
class ProductModel extends HiveObject {
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

  ProductModel({
    required this.id,
    required this.code,
    required this.name,
    required this.barcode,
    required this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
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

  ProductEntity toEntity() => ProductEntity(
        id: id,
        code: code,
        name: name,
        barcode: barcode,
        description: description,
      );

  factory ProductModel.fromEntity(ProductEntity entity) => ProductModel(
        id: entity.id,
        code: entity.code,
        name: entity.name,
        barcode: entity.barcode,
        description: entity.description,
      );
}
