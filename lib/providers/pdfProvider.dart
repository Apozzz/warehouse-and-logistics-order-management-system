import 'dart:io';

import 'package:inventory_system/constants/text_images.dart';
import 'package:inventory_system/imports.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart' as intl;
import 'package:flutter/services.dart' show rootBundle;

class PdfProvider {
  final Order order;
  static const baseColor = PdfColors.teal;
  static const accentColor = PdfColors.blueGrey900;
  static const _darkColor = PdfColors.blueGrey800;
  static const _lightColor = PdfColors.white;
  String? _bgShape;
  PdfColor get _baseTextColor => baseColor.isLight ? _lightColor : _darkColor;
  PdfColor get _accentTextColor => baseColor.isLight ? _lightColor : _darkColor;
  var products;
  var connection;
  var totalPrice;
  var grandTotal;
  Map<String, String> idQuantity = {};
  Map<int, String>? productWarehouseCodes;
  DataBaseService dbService = DataBaseService();

  PdfProvider({
    required this.order,
  });

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    final doc = pw.Document();
    _bgShape = await rootBundle.loadString('assets/invoice.svg');
    connection = ProductProvider().getDatabaseConnection(dbService);
    products = await OrderProvider().getProductsByOrderSerializedProductIds(
        dbService, order.serializedProductIds);
    productWarehouseCodes =
        await ProductProvider().getProductsWarehouseCodesList(products);
    idQuantity = OrderProvider().getIdQuantity(order);
    totalPrice =
        OrderProvider().getOrderTotalPriceByProductIds(products, idQuantity);
    grandTotal = totalPrice + (totalPrice * 0.21);

    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildTheme(
          pageFormat,
          await PdfGoogleFonts.robotoRegular(),
          await PdfGoogleFonts.robotoBold(),
          await PdfGoogleFonts.robotoItalic(),
        ),
        header: _buildHeader,
        footer: _buildFooter,
        build: (context) => [
          _contentHeader(context),
          _contentTable(context),
          pw.SizedBox(height: 20),
          _contentFooter(context),
        ],
      ),
    );

    return doc.save();
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                children: [
                  pw.Container(
                    height: 50,
                    padding: const pw.EdgeInsets.only(left: 20),
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      'INVOICE',
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  pw.Container(
                    decoration: const pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
                      color: accentColor,
                    ),
                    padding: const pw.EdgeInsets.only(
                        left: 40, top: 10, bottom: 10, right: 20),
                    alignment: pw.Alignment.centerLeft,
                    height: 50,
                    child: pw.DefaultTextStyle(
                      style: pw.TextStyle(
                        color: baseColor.isLight ? _lightColor : _darkColor,
                        fontSize: 12,
                      ),
                      child: pw.GridView(
                        crossAxisCount: 2,
                        children: [
                          pw.Text('Invoice #'),
                          pw.Text(order.code),
                          pw.Text('Date:'),
                          pw.Text(_formatDate(DateTime.now())),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (context.pageNumber > 1) pw.SizedBox(height: 20)
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Container(
          height: 20,
          width: 100,
          child: pw.BarcodeWidget(
            barcode: pw.Barcode.pdf417(),
            data: 'Invoice# ${order.code}',
            drawText: false,
          ),
        ),
        pw.Text(
          'Page ${context.pageNumber}/${context.pagesCount}',
          style: const pw.TextStyle(
            fontSize: 12,
            color: PdfColors.white,
          ),
        ),
      ],
    );
  }

  pw.PageTheme _buildTheme(
      PdfPageFormat pageFormat, pw.Font base, pw.Font bold, pw.Font italic) {
    return pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ),
      buildBackground: (context) => pw.FullPage(
        ignoreMargins: true,
        child: pw.SvgImage(svg: _bgShape!),
      ),
    );
  }

  pw.Widget _contentHeader(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Container(
            margin: const pw.EdgeInsets.symmetric(horizontal: 20),
            height: 70,
            child: pw.FittedBox(
              child: pw.Text(
                'Total: ${_formatCurrency(grandTotal)}',
                style: pw.TextStyle(
                  color: baseColor,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Row(
            children: [
              pw.Expanded(
                child: pw.Container(
                  height: 70,
                  child: pw.RichText(
                      text: pw.TextSpan(
                          text: '${order.name}\n',
                          style: pw.TextStyle(
                            color: _darkColor,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                          children: const [
                        pw.TextSpan(
                          text: '\n',
                          style: pw.TextStyle(
                            fontSize: 5,
                          ),
                        ),
                      ])),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _contentFooter(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Thank you for your business',
                style: pw.TextStyle(
                  color: _darkColor,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.DefaultTextStyle(
            style: const pw.TextStyle(
              fontSize: 10,
              color: _darkColor,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Sub Total:'),
                    pw.Text(_formatCurrency(totalPrice)),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Tax:'),
                    pw.Text('${(0.21 * 100).toStringAsFixed(1)}%'),
                  ],
                ),
                pw.Divider(color: accentColor),
                pw.DefaultTextStyle(
                  style: pw.TextStyle(
                    color: baseColor,
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total:'),
                      pw.Text(_formatCurrency(grandTotal)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = [
      'ID#',
      'Product Title',
      'Barcode',
      'QRCode',
      'Price',
      'Quantity',
      'Total Product Price',
      'Warehouse Name'
    ];

    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: const pw.BoxDecoration(
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
        color: baseColor,
      ),
      headerHeight: 25,
      cellHeight: 40,
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerLeft,
        4: pw.Alignment.center,
        5: pw.Alignment.center,
        6: pw.Alignment.center,
        7: pw.Alignment.centerLeft,
      },
      headerStyle: pw.TextStyle(
        color: _baseTextColor,
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: _darkColor,
        fontSize: 10,
      ),
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: accentColor,
            width: .5,
          ),
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        products.length,
        (row) => List<String>.generate(
          tableHeaders.length,
          (col) => getIndex(products[row], col),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final format = intl.DateFormat.yMMMd('en_US');
    return format.format(date);
  }

  String _formatCurrency(double amount) {
    return const Text('\u{20AC}').data.toString() + amount.toStringAsFixed(2);
  }

  String getIndex(Product product, int index) {
    switch (index) {
      case 0:
        return product.id.toString();
      case 1:
        return product.name;
      case 2:
        return product.barcode;
      case 3:
        return product.qrcode;
      case 4:
        return _formatCurrency(product.price);
      case 5:
        return idQuantity[product.id.toString()]!;
      case 6:
        return _formatCurrency(
            product.price * double.parse(idQuantity[product.id.toString()]!));
      case 7:
        return productWarehouseCodes == null
            ? 'Not Assigned'
            : productWarehouseCodes!.isEmpty
                ? 'Not Assigned'
                : productWarehouseCodes![product.id]!;
      default:
        return '';
    }
  }

  Future<void> saveAsFile(
    BuildContext context,
    LayoutCallback build,
    PdfPageFormat pageFormat,
  ) async {
    final bytes = await build(pageFormat);
    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    if (directory == null) {
      return;
    }

    final appDocPath = directory.path;
    final filePath = '$appDocPath/order_${order.code}.pdf';
    File file = File('');

    if (Platform.isAndroid) {
      var status = await Permission.storage.status;

      if (status != PermissionStatus.granted) {
        status = await Permission.storage.request();
      }

      if (status.isGranted) {
        file = File(filePath);
      }
    } else {
      file = File(filePath);
    }

    if (File(filePath).existsSync()) {
      File(filePath).deleteSync();
    }

    if (file.path == '') {
      return;
    }

    print('Save as file ${filePath} ...');
    await file.writeAsBytes(bytes);
    print('Open as file ${filePath} ...');
    await OpenFile.open(filePath);

    var notifyProvider = NotifyProvider();
    await notifyProvider.init(notificationPdfImage);
    notifyProvider.requestIOSPermissions();
    await notifyProvider.scheduleNotifications(
      'PDF',
      'PDF file order_${order.code}.pdf was generated',
    );
    await NotificationProvider().saveNotification(
      'PDF File',
      'PDF file order_${order.code}.pdf was generated',
      pdfImage,
    );
  }
}
