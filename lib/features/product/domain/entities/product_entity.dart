import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final int id;
  final String code;
  final String name;
  final String barcode;
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
