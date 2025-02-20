class ProductNotFoundError implements Exception {
  final String barcode;
  final String message;

  ProductNotFoundError(this.barcode)
      : message =
            "Bu barkoda ($barcode) ait ürün sistemde bulunamadı. Lütfen barkodu kontrol ediniz veya sistem yöneticinize başvurunuz.";

  @override
  String toString() => message;
}
