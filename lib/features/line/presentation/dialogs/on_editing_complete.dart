import 'package:birincisayim/features/line/presentation/bloc/line_bloc.dart';
import 'package:birincisayim/features/product/data/models/product_model.dart';
import 'package:flutter/material.dart';
import '../../../counter/data/models/count_model.dart';
import '../../../product/data/services/product_service.dart';
import '../../data/models/line_model.dart';
import '../../domain/entities/line_entity.dart';
import '../../domain/usecases/get_lines_by_count.dart';

class OnEditingComplete {
  static Future<void> onEditingComplete(
    LinesBloc bloc,
    TextEditingController miqdarController,
    TextEditingController barcodeController,
    BuildContext context,
    CountModel count,
    bool isSingleMode,
  ) async {
    if (barcodeController.text.isEmpty) return;

    try {
      final quantityController = TextEditingController(
        text: isSingleMode ? "1" : "",
      );

      ProductModel? product;
      if (barcodeController.text.startsWith("27")) {
        product = await ProductService.getByBarcode(
            barcodeController.text.substring(0, 7));
        debugPrint(barcodeController.text.substring(0, 7));

        product = await ProductService.getByBarcode(
            barcodeController.text.substring(0, 7));
        quantityController.text =
            (double.parse(barcodeController.text.substring(7, 12)) / 1000)
                .toString();
      } else {
        product = await ProductService.getByBarcode(barcodeController.text);
      }
      if (product == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ürün bulunamadı')),
          );
        }
        return;
      }

      final result =
          await bloc.getLinesByCount(GetLinesByCountParams(countId: count.id));
      LineEntity? existingLine;
      result.fold(
        (failure) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Hata: ${failure.toString()}')),
            );
          }
        },
        (lines) {
          try {
            existingLine = lines.firstWhere(
              (line) => line.product.barcode == product!.barcode,
            );
          } catch (_) {
            existingLine = null;
          }
        },
      );

      if (!context.mounted) return;

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: EdgeInsets.zero,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.inventory_2_outlined,
                              color: Colors.blue,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              product!.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey[850]!,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.qr_code,
                              size: 16,
                              color: Colors.white70,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              product.barcode,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (existingLine != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 20,
                                color: Colors.blue.withOpacity(0.8),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Mevcut Miktar',
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${existingLine!.quantity}',
                                      style: TextStyle(
                                        color: Colors.blue.withOpacity(0.8),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      TextField(
                        controller: quantityController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        autofocus: true,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            try {
                              final number =
                                  double.parse(value.replaceAll(',', '.'));
                              if (number <= 0) {
                                quantityController.text = '';
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Miktar 0\'dan büyük olmalıdır')),
                                );
                              }
                            } catch (_) {
                              quantityController.text = '';
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Geçerli bir miktar giriniz')),
                              );
                            }
                          }
                        },
                        decoration: InputDecoration(
                          labelText:
                              existingLine != null ? 'Yeni Miktar' : 'Miktar',
                          labelStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                          hintText: existingLine != null
                              ? 'Yeni miktarı girin'
                              : 'Miktar girin',
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: const Color(0xFF1E1E1E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey[850]!,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 1,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.shopping_basket_outlined,
                            color: Colors.grey[400],
                            size: 20,
                          ),
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Adet',
                              style: TextStyle(
                                color: Colors.blue.withOpacity(0.8),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Actions
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'İptal',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            try {
                              final newQuantity =
                                  quantityController.text.isEmpty
                                      ? 1.0
                                      : double.parse(quantityController.text
                                          .replaceAll(',', '.'));

                              if (newQuantity <= 0) {
                                throw Exception(
                                    'Miktar 0\'dan büyük olmalıdır');
                              }

                              if (existingLine != null) {
                                bloc.add(UpdateQuantityEvent(
                                  id: existingLine!.id,
                                  countId: count.id,
                                  quantity:
                                      existingLine!.quantity + newQuantity,
                                ));
                              } else {
                                final line = LineModel.create(
                                  countId: count.id,
                                  product: product!,
                                  quantity: newQuantity,
                                );
                                bloc.add(AddLineEvent(line: line.toEntity()));
                              }

                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              }
                            }
                          },
                          child: const Text(
                            'Kaydet',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

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
