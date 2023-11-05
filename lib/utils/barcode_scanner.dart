// shared/utils/barcode_scanner.dart
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BarcodeScanner {
  static Future<String?> scanBarcode(BuildContext context) async {
    try {
      final barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // line color
        'Cancel', // cancel button text
        true, // is flashlight available
        ScanMode.BARCODE, // scanning for barcode (not QR)
      );
      if (barcode == '-1') {
        // User cancelled the scanning process
        return null;
      }
      return barcode;
    } catch (e) {
      // Handle any errors that occur during scanning
      // Optionally, you can display an error message to the user using a dialog or a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Barcode scanning failed: $e')),
      );
      return null;
    }
  }
}
