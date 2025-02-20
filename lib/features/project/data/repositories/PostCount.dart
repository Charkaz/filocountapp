import 'package:birincisayim/commons/DioHelper.dart';
import 'package:birincisayim/features/counter/data/models/count_model.dart';
import 'package:dio/dio.dart';
import 'package:birincisayim/features/line/data/services/line_service.dart';

import '../../../line/data/models/line_model.dart';
import '../../../product/data/models/product_model.dart';

class PostCount {
  static Future<int?> post(CountModel count) async {
    var dio = DioHelper.instance;
    await LineService.initializeRepository();
    final lineEntities = await LineService.getLinesByCount(count.id);
    final lines = lineEntities
        .map((entity) => LineModel(
              id: entity.id,
              countId: entity.countId,
              product: ProductModel(
                id: entity.product.id,
                code: entity.product.code,
                name: entity.product.name,
                barcode: entity.product.barcode,
                description: entity.product.description,
              ).toEntity(),
              quantity: entity.quantity,
              createdAt: entity.createdAt,
            ))
        .toList();

    final countWithLines = CountModel(
      id: count.id,
      projectId: count.projectId,
      controlGuid: count.controlGuid,
      description: count.description,
      isSend: count.isSend,
      lines: lines,
    );

    Response res =
        await dio.post("/api/counter/counts", data: countWithLines.toJson());
    return res.statusCode;
  }
}
