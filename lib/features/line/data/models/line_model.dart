import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/line_entity.dart';
import '../../../product/data/models/product_model.dart';

part 'line_model.g.dart';

@HiveType(typeId: 2)
class LineModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String countId;

  @HiveField(2)
  final ProductModel product;

  @HiveField(3)
  double quantity;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  DateTime updatedAt;

  LineModel({
    required this.id,
    required this.countId,
    required this.product,
    required this.quantity,
    required this.createdAt,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? createdAt;

  void updateQuantity(double newQuantity) {
    quantity = newQuantity;
    updatedAt = DateTime.now();
    save();
  }

  factory LineModel.fromJson(Map<String, dynamic> json) {
    return LineModel(
      id: json['id'] as String,
      countId: json['countId'] as String,
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
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

  factory LineModel.fromEntity(LineEntity entity) {
    return LineModel(
      id: entity.id,
      countId: entity.countId,
      product: ProductModel(
        id: entity.product.id,
        code: entity.product.code,
        name: entity.product.name,
        barcode: entity.product.barcode,
        description: entity.product.description,
      ),
      quantity: entity.quantity,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  LineEntity toEntity() {
    return LineEntity(
      id: id,
      countId: countId,
      product: product.toEntity(),
      quantity: quantity,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory LineModel.create({
    required String countId,
    required ProductModel product,
    required double quantity,
  }) {
    final now = DateTime.now();
    final uuid = Uuid();
    return LineModel(
      id: uuid.v4(),
      countId: countId,
      product: product,
      quantity: quantity,
      createdAt: now,
      updatedAt: now,
    );
  }
}
