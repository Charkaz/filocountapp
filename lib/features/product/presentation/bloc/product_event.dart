part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEvent {}

class SearchProductByBarcode extends ProductEvent {
  final String barcode;

  const SearchProductByBarcode({required this.barcode});

  @override
  List<Object> get props => [barcode];
}
