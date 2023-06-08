import 'package:inventory_system/imports.dart';

class ScannerProvider {
  final String lineColor;
  final String cancelButtonText;
  final bool showFlashlight;
  final ScanMode scanMode;

  const ScannerProvider({
    this.lineColor = '#FF0000',
    this.cancelButtonText = 'CANCEL',
    this.showFlashlight = false,
    this.scanMode = ScanMode.QR,
});

  Future<String> scanCode() async {
    return await FlutterBarcodeScanner.scanBarcode(
        lineColor, 
        cancelButtonText, 
        showFlashlight, 
        scanMode
    );
  }
}
