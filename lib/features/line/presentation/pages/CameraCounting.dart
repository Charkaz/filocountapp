import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import '../../../counter/data/models/count_model.dart';
import '../../../product/domain/usecases/ProductService.dart';
import '../../../product/data/models/product_model.dart';
import '../../data/services/line_service.dart';
import '../../data/models/line_model.dart';

class CameraCounting extends StatefulWidget {
  final CountModel count;

  const CameraCounting({
    required this.count,
    super.key,
  });

  @override
  State<CameraCounting> createState() => _CameraCountingState();
}

class _CameraCountingState extends State<CameraCounting>
    with SingleTickerProviderStateMixin {
  MobileScannerController? controller;
  bool _isFlashOn = false;
  late AnimationController _scanAnimationController;
  late Animation<double> _scanAnimation;
  bool _isProcessing = false;
  late ProductService _productService;
  bool _barcodeDetected = false;
  String? _lastDetectedBarcode;
  bool _isSingleMode = false;
  bool _showingInfo = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();

    _scanAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scanAnimation = Tween<double>(
      begin: 0.0,
      end: 160.0,
    ).animate(_scanAnimationController);

    _productService = ProductService();
    _productService.initializeRepository();
    LineService.initializeRepository();
  }

  void _initializeCamera() {
    controller = MobileScannerController(
      facing: CameraFacing.back,
      torchEnabled: false,
      formats: [BarcodeFormat.qrCode, BarcodeFormat.ean8, BarcodeFormat.ean13],
      detectionSpeed: DetectionSpeed.noDuplicates,
      detectionTimeoutMs: 500,
    );
  }

  void _resetCamera() {
    setState(() {
      _barcodeDetected = false;
      _lastDetectedBarcode = null;
      _isProcessing = false;
    });
    controller?.stop();
    controller?.start();
  }

  void _showProductNotFoundDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  color: Colors.red[400],
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ürün Bulunamadı',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Bu barkoda ait ürün sistemde kayıtlı değil.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _resetCamera();
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  backgroundColor: Colors.red.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Tamam',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _processBarcode() async {
    if (_lastDetectedBarcode == null) return;
    setState(() => _isProcessing = true);

    try {
      HapticFeedback.lightImpact();
      final product = await _productService.getByBarcode(_lastDetectedBarcode!);

      if (product == null) {
        if (mounted) {
          _showProductNotFoundDialog();
          return;
        }
        return;
      }

      final existingLine = await LineService.listLinesByProduct(
        product: product,
        count: widget.count,
      );

      if (_isSingleMode) {
        if (existingLine != null) {
          existingLine.updateQuantity(existingLine.quantity + 1);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    '${product.name} miktarı güncellendi: ${existingLine.quantity}'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          final line = LineModel.create(
            countId: widget.count.id,
            product: product,
            quantity: 1,
          );
          await LineService.addLine(line);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${product.name} eklendi'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.blue,
              ),
            );
          }
        }
        _resetCamera();
      } else {
        if (mounted) {
          final quantityController = TextEditingController(
            text: existingLine?.quantity.toString() ?? "",
          );

          showDialog(
            context: context,
            builder: (context) => Dialog(
              backgroundColor: const Color(0xFF2A2A2A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E1E1E),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Barkod: ${product.barcode}',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (existingLine != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mevcut Miktar',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  '${existingLine.quantity}',
                                  style: TextStyle(
                                    color: Colors.blue.withOpacity(0.8),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    TextField(
                      controller: quantityController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      autofocus: true,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Miktar',
                        labelStyle: TextStyle(color: Colors.grey[400]),
                        hintText: 'Miktar girin',
                        hintStyle: TextStyle(color: Colors.grey[600]),
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
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _resetCamera();
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
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
                            onPressed: () async {
                              try {
                                final quantity = double.parse(
                                  quantityController.text.replaceAll(',', '.'),
                                );

                                if (existingLine != null) {
                                  existingLine.updateQuantity(quantity);
                                } else {
                                  final line = LineModel.create(
                                    countId: widget.count.id,
                                    product: product,
                                    quantity: quantity,
                                  );
                                  await LineService.addLine(line);
                                }

                                if (mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(existingLine != null
                                          ? '${product.name} miktarı güncellendi: $quantity'
                                          : '${product.name} eklendi: $quantity'),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  _resetCamera();
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Geçerli bir miktar giriniz'),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
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
                  ],
                ),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
        _resetCamera();
      }
    }
  }

  void _switchToQRMode() {
    setState(() {
      _barcodeDetected = false;
      _lastDetectedBarcode = null;
      _isProcessing = false;
    });

    controller?.dispose();
    controller = MobileScannerController(
      facing: CameraFacing.back,
      formats: [BarcodeFormat.qrCode],
      detectionSpeed: DetectionSpeed.noDuplicates,
      detectionTimeoutMs: 1000,
    );
  }

  void _switchToBarcodeMode() {
    setState(() {
      _barcodeDetected = false;
      _lastDetectedBarcode = null;
      _isProcessing = false;
    });

    controller?.dispose();
    controller = MobileScannerController(
      facing: CameraFacing.back,
      formats: [BarcodeFormat.ean8, BarcodeFormat.ean13],
      detectionSpeed: DetectionSpeed.noDuplicates,
      detectionTimeoutMs: 1000,
    );
  }

  void _showCountInfo() async {
    if (_lastDetectedBarcode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Önce bir ürün taratın'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _showingInfo = true);

    try {
      final product = await _productService.getByBarcode(_lastDetectedBarcode!);
      if (product == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ürün bulunamadı'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final existingLine = await LineService.listLinesByProduct(
        product: product,
        count: widget.count,
      );

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          child: TweenAnimationBuilder(
            duration: const Duration(milliseconds: 800),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, double value, child) {
              return Transform.translate(
                offset: Offset(0, 50 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.blue.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Ürün İkonu
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.inventory_2_outlined,
                            color: Colors.blue,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Ürün Adı
                        Text(
                          product.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),

                        // Ürün Kodu
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Kod: ${product.code}',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Barkod Bilgisi
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E1E),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey[850]!,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.qr_code,
                                color: Colors.white70,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                product.barcode,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Mevcut Miktar (eğer varsa)
                        if (existingLine != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.green.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.shopping_basket_outlined,
                                  color: Colors.green,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Mevcut Miktar: ${existingLine.quantity}',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Açıklama
                        if (product.description.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E1E),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey[850]!,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Açıklama',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product.description,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Kapat Butonu
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            backgroundColor: Colors.blue.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Kapat',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ).then((_) => setState(() => _showingInfo = false));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    _scanAnimationController.dispose();
    super.dispose();
  }

  Widget _buildSideButton(IconData icon, String label, VoidCallback onTap,
      {bool isActive = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? Colors.white : Colors.white.withOpacity(0.15),
                border: Border.all(
                  color: Colors.white.withOpacity(isActive ? 1 : 0.3),
                  width: isActive ? 2 : 1,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                icon,
                color: isActive ? Colors.black : Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isFlashOn ? Icons.flash_on : Icons.flash_off,
                color: _isFlashOn ? Colors.yellow : Colors.white,
              ),
            ),
            onPressed: () async {
              try {
                await controller?.toggleTorch();
                setState(() => _isFlashOn = !_isFlashOn);
              } catch (_) {}
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: _barcodeDetected
          ? Container(
              margin: const EdgeInsets.only(bottom: 100),
              child: FloatingActionButton(
                onPressed: _processBarcode,
                backgroundColor: Colors.green,
                child: const Icon(
                  Icons.add,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            )
          : null,
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;

              if (barcodes.isEmpty) {
                if (_barcodeDetected) {
                  setState(() {
                    _barcodeDetected = false;
                    _lastDetectedBarcode = null;
                    _isProcessing = false;
                  });
                }
                return;
              }

              final String? newBarcode = barcodes.first.rawValue;
              if (newBarcode != null && !_isProcessing && !_barcodeDetected) {
                setState(() {
                  _barcodeDetected = true;
                  _lastDetectedBarcode = newBarcode;
                });
                // Barkod algılandığında vibrasyon
                Vibration.vibrate(duration: 100);
                // Ürün bulunduğunda ikinci bir vibrasyon
                _productService.getByBarcode(newBarcode).then((product) {
                  if (product != null) {
                    Vibration.vibrate(pattern: [0, 100, 100, 100]);
                  }
                });
              }
            },
          ),
          Center(
            child: Container(
              width: 280,
              height: 140,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _barcodeDetected ? Colors.green : Colors.white70,
                  width: 2.5,
                ),
                boxShadow: _barcodeDetected
                    ? [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                      ]
                    : null,
              ),
              child: Stack(
                children: [
                  // Köşe işaretleri
                  ...List.generate(4, (index) {
                    final isTop = index < 2;
                    final isLeft = index.isEven;
                    return Positioned(
                      top: isTop ? -1 : null,
                      bottom: !isTop ? -1 : null,
                      left: isLeft ? -1 : null,
                      right: !isLeft ? -1 : null,
                      child: Container(
                        width: 32,
                        height: 32,
                        child: CustomPaint(
                          painter: CornerPainter(
                            color: _barcodeDetected
                                ? Colors.green
                                : Colors.white70,
                            isTop: isTop,
                            isLeft: isLeft,
                            thickness: 3,
                          ),
                        ),
                      ),
                    );
                  }),
                  // Tarama çizgisi
                  AnimatedBuilder(
                    animation: _scanAnimation,
                    builder: (context, child) {
                      return Positioned(
                        top: _scanAnimation.value,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 2,
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                _barcodeDetected ? Colors.green : Colors.blue,
                                Colors.transparent,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: (_barcodeDetected
                                        ? Colors.green
                                        : Colors.blue)
                                    .withOpacity(0.5),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Sliding Menu Panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                  stops: const [0.4, 0.8, 1.0],
                ),
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Sliding Menu
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      height: 90,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            _buildSideButton(
                              Icons.camera_alt,
                              'Kamera\nDeğiştir',
                              () async {
                                try {
                                  await controller?.switchCamera();
                                } catch (_) {}
                              },
                            ),
                            _buildSideButton(
                              Icons.exposure_plus_1,
                              'Tek Tek\nArtır',
                              () {
                                setState(() {
                                  _isSingleMode = !_isSingleMode;
                                });
                              },
                              isActive: _isSingleMode,
                            ),
                            _buildSideButton(
                              Icons.analytics_outlined,
                              'Sayım\nBilgisi',
                              _showCountInfo,
                              isActive: _showingInfo,
                            ),
                            _buildSideButton(
                              Icons.qr_code_scanner,
                              'QR Kod\nTarama',
                              _switchToQRMode,
                            ),
                            _buildSideButton(
                              Icons.barcode_reader,
                              'Barkod\nTarama',
                              _switchToBarcodeMode,
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Barcode Detected Message
                  if (_barcodeDetected)
                    Positioned(
                      bottom: 120,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.green.withOpacity(0.5),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.2),
                              blurRadius: 8,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              color: Colors.green,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Barkod Algılandı',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CornerPainter extends CustomPainter {
  final Color color;
  final bool isTop;
  final bool isLeft;
  final double thickness;

  CornerPainter({
    required this.color,
    required this.isTop,
    required this.isLeft,
    this.thickness = 2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (isTop && isLeft) {
      path.moveTo(size.width, 0);
      path.lineTo(0, 0);
      path.lineTo(0, size.height);
    } else if (isTop && !isLeft) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else if (!isTop && isLeft) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CornerPainter oldDelegate) =>
      color != oldDelegate.color ||
      isTop != oldDelegate.isTop ||
      isLeft != oldDelegate.isLeft ||
      thickness != oldDelegate.thickness;
}
