import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_products.dart';
import '../../../../core/usecases/usecase.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProducts;
  final GetProductByBarcode getProductByBarcode;

  ProductBloc({
    required this.getProducts,
    required this.getProductByBarcode,
  }) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<SearchProductByBarcode>(_onSearchProductByBarcode);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    final result = await getProducts(NoParams());
    result.fold(
      (failure) => emit(ProductError(message: 'Failed to load products')),
      (products) => emit(ProductsLoaded(products: products)),
    );
  }

  Future<void> _onSearchProductByBarcode(
    SearchProductByBarcode event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    final result = await getProductByBarcode(
      GetProductByBarcodeParams(barcode: event.barcode),
    );
    result.fold(
      (failure) => emit(ProductError(message: 'Product not found')),
      (product) => emit(ProductByBarcodeLoaded(product: product)),
    );
  }
}
