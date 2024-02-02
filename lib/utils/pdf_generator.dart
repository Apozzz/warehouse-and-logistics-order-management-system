// utils/pdf_generator.dart
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:inventory_system/enums/order_status.dart';
import 'package:inventory_system/features/delivery/models/delivery_model.dart';
import 'package:inventory_system/features/delivery/models/transportation_details.dart';
import 'package:inventory_system/features/user/models/user_model.dart';
import 'package:inventory_system/features/vehicle/models/vehicle_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:inventory_system/features/order/models/order_model.dart';
import 'package:open_file/open_file.dart';
import 'package:http/http.dart' as http;

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

  Future<String> generateTransportationPdf(
      Delivery delivery,
      List<Order> orders, // List of orders associated with the delivery
      Vehicle vehicle, // Vehicle used for the delivery
      User user, // User who performed the delivery
      PdfGenerationCallback onPdfGenerated) async {
    try {
      final pdf = pw.Document();

      // Load custom fonts
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

      TransportationDetails? transportationDetails =
          delivery.transportationDetails;
      pw.ImageProvider? mapImage;
      if (transportationDetails?.pathImageUrl != null) {
        mapImage = await downloadImage(transportationDetails!.pathImageUrl!);
      }

      pdf.addPage(
        pw.MultiPage(
          theme: theme,
          build: (context) => [
            pw.Header(
                level: 0,
                child: pw.Text('Transportation Details', textScaleFactor: 2)),
            pw.Paragraph(
                text:
                    'Delivery ID: ${delivery.id}\nDate: ${delivery.deliveryDate.toString()}'),
            pw.Paragraph(
                text:
                    'Vehicle ID: ${vehicle.id}\nDriver/User Name: ${user.name}'),

            // Vehicle information
            pw.Header(level: 1, text: 'Vehicle Information'),
            pw.Bullet(text: 'Type: ${vehicle.type}'),
            pw.Bullet(text: 'Max Weight: ${vehicle.maxWeight} kg'),
            pw.Bullet(text: 'Max Volume: ${vehicle.maxVolume} cubic meters'),
            pw.Bullet(
                text: 'Registration Number: ${vehicle.registrationNumber}'),

            // Orders information
            pw.Header(level: 1, text: 'Orders in Transit'),
            ...orders.map((order) => pw.Column(
                  children: [
                    pw.Text('Order ID: ${order.id}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Customer Name: ${order.customerName}'),
                    pw.Text('Address: ${order.customerAddress}'),
                    pw.Text('Status: ${order.status.name}'),
                    if (order.status == OrderStatus.Failed &&
                        order.declineReason != null)
                      pw.Text('Decline Reason: ${order.declineReason}'),
                    pw.Divider(),
                  ],
                )),

            // Transportation map
            if (mapImage != null)
              pw.Center(
                child: pw.Image(mapImage,
                    width: 400), // Adjust the width as needed
              ),

            // Distance and Time Taken
            if (transportationDetails?.distanceTraveled != null)
              pw.Paragraph(
                  text:
                      'Distance Traveled: ${transportationDetails!.distanceTraveled} km'),
            if (transportationDetails?.timeTaken != null)
              pw.Paragraph(
                  text:
                      'Time Taken: ${formatDuration(transportationDetails!.timeTaken!)}'),
          ],
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File("${output.path}/Transportation_${delivery.id}.pdf");
      await file.writeAsBytes(await pdf.save());
      onPdfGenerated(file.path);
      return file.path;
    } catch (e) {
      print("Error generating transportation PDF: $e");
      throw e; // Or handle the error as needed
    }
  }

  // Utility function to format Duration into a readable string
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    return '$hours hours, $minutes minutes';
  }

  // Utility function to download an image from a URL
  Future<pw.MemoryImage> downloadImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode != 200) {
      throw Exception('Failed to load image');
    }
    return pw.MemoryImage(response.bodyBytes);
  }

  Future<void> openPdf(String path) async {
    await OpenFile.open(path);
  }
}
