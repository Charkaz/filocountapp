import 'package:equatable/equatable.dart';
import '../../../product/domain/entities/product_entity.dart';

class LineEntity extends Equatable {
  final int id;
  final int countId;
  final ProductEntity product;
  final double quantity;
  final DateTime createdAt;

  const LineEntity({
    required this.id,
    required this.countId,
    required this.product,
    required this.quantity,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, countId, product, quantity, createdAt];

  factory LineEntity.fromJson(Map<String, dynamic> json) {
    return LineEntity(
      id: json['id'] as int,
      countId: json['countId'] as int,
      product: ProductEntity.fromJson(json['product'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'countId': countId,
      'product': product.toJson(),
      'quantity': quantity,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
