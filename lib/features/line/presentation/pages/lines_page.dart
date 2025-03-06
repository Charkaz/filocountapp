import 'package:birincisayim/features/counter/data/models/count_model.dart';
import 'package:birincisayim/features/line/presentation/bloc/line_bloc.dart';
import 'package:birincisayim/features/product/domain/usecases/ProductService.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

import '../../data/repositories/line_repository_impl.dart';
import '../../data/datasources/line_local_data_source.dart';
import '../../domain/usecases/get_lines_by_count.dart';
import '../../domain/usecases/add_line.dart';
import '../../domain/usecases/update_line.dart';
import '../../domain/usecases/delete_line.dart';
import '../../domain/usecases/update_quantity.dart';

import '../../data/models/line_model.dart';
import '../widgets/barcode_text.dart';
import '../widgets/lines_app_bar.dart';
import '../widgets/product_list_container.dart';

class LinesPage extends StatefulWidget {
  final CountModel count;
  const LinesPage({required this.count, super.key});

  @override
  State<LinesPage> createState() => _LinesPageState();
}

class _LinesPageState extends State<LinesPage> {
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController miqdarController = TextEditingController();
  final FocusNode barcodeFocusNode = FocusNode();
  LinesBloc? bloc;
  late ProductService productService;

  @override
  void initState() {
    super.initState();
    _initializeBloc();
    productService = ProductService();
    productService.initializeRepository();
  }

  Future<void> _initializeBloc() async {
    final box = await Hive.openBox<LineModel>('lines');
    final dataSource = LineLocalDataSourceImpl(lineBox: box);
    final repository = LineRepositoryImpl(localDataSource: dataSource);

    setState(() {
      bloc = LinesBloc(
        getLinesByCount: GetLinesByCount(repository),
        addLine: AddLine(repository),
        updateLine: UpdateLine(repository),
        deleteLine: DeleteLine(repository),
        updateQuantity: UpdateQuantity(repository),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (bloc == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: LinesAppBar(
        count: widget.count,
        barcodeController: barcodeController,
        productService: productService,
      ),
      body: Column(
        children: [
          // Sabit barkod tarama bölümü
          BarcodeText(
            bloc: bloc!,
            count: widget.count,
            miqdarController: miqdarController,
            barcodeController: barcodeController,
            barcodeFocusNode: barcodeFocusNode,
          ),

          // Ürünler listesi
          ProductListContainer(
            bloc: bloc!,
            count: widget.count,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    barcodeController.dispose();
    miqdarController.dispose();
    barcodeFocusNode.dispose();
    bloc?.close();
    super.dispose();
  }
}
