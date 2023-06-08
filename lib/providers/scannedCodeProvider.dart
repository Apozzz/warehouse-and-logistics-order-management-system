import 'package:inventory_system/imports.dart';

class ScannedCodeProvider {
  final Barcode barcode;
  final String barcodeData;
  final double? width;
  final double? height;

  const ScannedCodeProvider({
    required this.barcode,
    required this.barcodeData,
    this.width = 200,
    this.height = 80,
  });

  BarcodeWidget getScannedCode() {
    return BarcodeWidget(
        data: barcodeData,
        barcode: barcode,
        width: width,
        height: height,
        style: const TextStyle(fontSize: 17.5));
  }
}
