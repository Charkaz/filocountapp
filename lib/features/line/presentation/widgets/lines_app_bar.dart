import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../counter/data/models/count_model.dart';
import '../../../product/domain/usecases/ProductService.dart';
import '../dialogs/product_search_dialog.dart';

class LinesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final CountModel count;
  final TextEditingController barcodeController;
  final ProductService productService;

  const LinesAppBar({
    super.key,
    required this.count,
    required this.barcodeController,
    required this.productService,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      title: Text(
        count.description,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: IconButton(
        icon:
            const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white, size: 24),
          onPressed: () async {
            final products = await productService.listProject();
            if (!context.mounted) return;

            showDialog(
              context: context,
              builder: (context) => ProductSearchDialog(
                products: products,
                onBarcodeSelected: (barcode) {
                  barcodeController.text = barcode;
                },
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.camera, color: Colors.white, size: 24),
          onPressed: () {
            /*  Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => CameraCounting(count: count),
              ),
            );
            */
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
