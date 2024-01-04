import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';

void showBarcodeDialog(BuildContext context, String data) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Scan this barcode'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            BarcodeWidget(
              barcode: Barcode.code128(), // Choose the type of barcode you need
              data: data,
              width: 200,
              height: 80,
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
              child: const Text('Close'),
            ),
          ],
        ),
      );
    },
  );
}
