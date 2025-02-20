import 'package:flutter/material.dart';
import 'package:birincisayim/ui/lines_page/bloc/lines_bloc/lines_bloc.dart'
    as lines_bloc;
import '../../../counter/data/models/count_model.dart';

import '../../../product/data/services/product_service.dart';

import '../../data/models/line_model.dart';
import 'LineSerivce.dart';

class OnEditingComplete {
  static Future<void> onEditingComplete(
    lines_bloc.LinesBloc bloc,
    TextEditingController miqdarController,
    TextEditingController barcodeController,
    BuildContext context,
    CountModel countModel,
  ) async {
    try {
      var product = await ProductService.getByBarcode(barcodeController.text);
      if (product != null) {
        var count = CountModel(
          id: countModel.id,
          projectId: countModel.projectId,
          controlGuid: countModel.controlGuid,
          description: countModel.description,
          isSend: countModel.isSend,
          lines: [],
        );

        var checkLine = await LineService.listLinesByProduct(
          product: product,
          count: count,
        );

        if (checkLine != null) {
          checkLine.quantity += double.parse(miqdarController.text);
          await LineService.updateLine(checkLine);
        } else {
          var line = LineModel.create(
            countId: count.id,
            product: product,
            quantity: double.parse(miqdarController.text),
          );
          await LineService.addLine(line);
        }

        bloc.add(lines_bloc.ListLineEvent(count.id));
        miqdarController.clear();
        barcodeController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
