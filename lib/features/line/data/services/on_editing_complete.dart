import 'package:flutter/material.dart';
import '../../domain/entities/line_entity.dart';
import 'package:birincisayim/ui/lines_page/bloc/lines_bloc/lines_bloc.dart'
    as lines_bloc;
import '../../../counter/data/models/count_model.dart';
import '../../../product/data/services/product_service.dart';
import '../../../product/domain/entities/product_entity.dart';
import 'line_service.dart';

class OnEditingComplete {
  static Future<void> onEditingComplete(
    lines_bloc.LinesBloc bloc,
    TextEditingController miqdarController,
    TextEditingController barcodeController,
    BuildContext context,
    CountModel count,
  ) async {
    if (barcodeController.text.isEmpty) return;

    try {
      final product = await ProductService.getByBarcode(barcodeController.text);
      if (product == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ürün bulunamadı')),
          );
        }
        return;
      }

      final quantity = double.parse(miqdarController.text);
      final line = LineEntity(
        id: DateTime.now().millisecondsSinceEpoch,
        countId: count.id,
        product: ProductEntity(
          id: product.id,
          code: product.code,
          name: product.name,
          barcode: product.barcode,
          description: product.description,
        ),
        quantity: quantity,
        createdAt: DateTime.now(),
      );

      await LineService.addLine(line);
      bloc.add(lines_bloc.ListLineEvent(count.id));

      barcodeController.clear();
      miqdarController.clear();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: ${e.toString()}')),
        );
      }
    }
  }
}
