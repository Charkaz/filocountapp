import 'package:hive/hive.dart';
import '../../domain/entities/line_entity.dart';
import '../../../product/domain/entities/product_entity.dart';

part 'line_model.g.dart';

@HiveType(typeId: 2)
class LineModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int countId;

  @HiveField(2)
  final ProductEntity product;

  @HiveField(3)
  double quantity;

  @HiveField(4)
  final DateTime createdAt;

  LineModel({
    required this.id,
    required this.countId,
    required this.product,
    required this.quantity,
    required this.createdAt,
  });

  void updateQuantity(double newQuantity) {
    quantity = newQuantity;
    save();
  }

  factory LineModel.fromJson(Map<String, dynamic> json) {
    return LineModel(
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

  factory LineModel.fromEntity(LineEntity entity) {
    return LineModel(
      id: entity.id,
      countId: entity.countId,
      product: entity.product,
      quantity: entity.quantity,
      createdAt: entity.createdAt,
    );
  }

  LineEntity toEntity() {
    return LineEntity(
      id: id,
      countId: countId,
      product: product,
      quantity: quantity,
      createdAt: createdAt,
    );
  }

  factory LineModel.create({
    required int countId,
    required ProductEntity product,
    required double quantity,
  }) {
    return LineModel(
      id: DateTime.now().millisecondsSinceEpoch,
      countId: countId,
      product: product,
      quantity: quantity,
      createdAt: DateTime.now(),
    );
  }
}
