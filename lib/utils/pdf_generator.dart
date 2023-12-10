// utils/pdf_generator.dart
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:inventory_system/features/order/models/order_model.dart';
import 'package:open_file/open_file.dart';

typedef PdfGenerationCallback = void Function(String pdfPath);

class PdfGenerator {
  Future<pw.Font> loadCustomFont(String path) async {
    final fontData = await rootBundle.load(path);
    return pw.Font.ttf(fontData.buffer.asByteData());
  }

  Future<String> generateOrderPdf(
      Order order, PdfGenerationCallback onPdfGenerated) async {
    try {
      final pdf = pw.Document();
      // Load different font styles
      final customFontRegular =
          await loadCustomFont('assets/fonts/Roboto-Regular.ttf');
      final customFontBold =
          await loadCustomFont('assets/fonts/Roboto-Bold.ttf');
      final customFontItalic =
          await loadCustomFont('assets/fonts/Roboto-Italic.ttf');
      final customFontBoldItalic =
          await loadCustomFont('assets/fonts/Roboto-BoldItalic.ttf');

      // Create a theme with the custom fonts
      final theme = pw.ThemeData.withFont(
        base: customFontRegular,
        bold: customFontBold,
        italic: customFontItalic,
        boldItalic: customFontBoldItalic,
      );

      pdf.addPage(
        pw.MultiPage(
          theme: theme,
          build: (context) => [
            pw.Header(
                level: 0, child: pw.Text('Order Details', textScaleFactor: 2)),
            pw.Paragraph(
                text: 'Order ID: ${order.id}\nDate: ${order.createdAt}'),
            pw.Paragraph(
                text:
                    'Customer Name: ${order.customerName}\nAddress: ${order.customerAddress}'),
            pw.Header(level: 1, text: 'Ordered Items'),
            pw.Table.fromTextArray(
              context: context,
              data: <List<String>>[
                <String>['Product ID', 'Quantity', 'Price'],
                ...order.items.map((item) => [
                      item.productId,
                      item.quantity.toString(),
                      // Assuming you have a method to get the price of the product
                      item.price.toString(),
                    ])
              ],
            ),
            pw.Paragraph(text: 'Total: ${order.total.toString()}'),
          ],
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File("${output.path}/Order_${order.id}.pdf");
      await file.writeAsBytes(await pdf.save());
      onPdfGenerated(file.path);
      return file.path;
    } catch (e) {
      print("Error generating PDF: $e");
      throw e; // Or handle the error as needed
    }
  }

  Future<void> openPdf(String path) async {
    await OpenFile.open(path);
  }
}
