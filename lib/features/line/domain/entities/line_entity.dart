import 'package:equatable/equatable.dart';
import '../../../product/domain/entities/product_entity.dart';
import '../../data/models/line_model.dart';

class LineEntity extends Equatable {
  final String id;
  final String countId;
  final ProductEntity product;
  final double quantity;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LineEntity({
    required this.id,
    required this.countId,
    required this.product,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props =>
      [id, countId, product, quantity, createdAt, updatedAt];

  factory LineEntity.fromJson(Map<String, dynamic> json) {
    return LineEntity(
      id: json['id'] as String,
      countId: json['countId'] as String,
      product: ProductEntity.fromJson(json['product'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'countId': countId,
      'product': product.toJson(),
      'quantity': quantity,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  LineModel toModel() {
    return LineModel(
      id: id,
      countId: countId,
      product: product.toModel(),
      quantity: quantity,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
