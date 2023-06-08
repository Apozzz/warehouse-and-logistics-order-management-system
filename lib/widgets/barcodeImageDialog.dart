import 'package:inventory_system/imports.dart';

class BarcodeImageDialog {
  final BuildContext context;
  final Barcode barcode;
  final String barcodeData;
  final String buttonText;

  const BarcodeImageDialog({
    required this.context,
    required this.barcode,
    required this.barcodeData,
    required this.buttonText,
  });

  ButtonStyle _getStyle() {
    return barcodeData.isEmpty
        ? TextButton.styleFrom(
            foregroundColor: Colors.grey,
          )
        : TextButton.styleFrom();
  }

  Widget getBarcodeImageDialog() {
    var isQrCode = barcode.name == 'QR-Code';
    var width = MediaQuery.of(context).size.width - 25;
    var height = isQrCode
        ? MediaQuery.of(context).size.height - 450
        : MediaQuery.of(context).size.height * 0.20;

    ScannedCodeProvider barcodeCreationProvider = ScannedCodeProvider(
        barcode: barcode,
        barcodeData: barcodeData,
        width: width,
        height: height);

    width += 5000;
    height += 5000;

    return TextButton(
      style: _getStyle(),
      onPressed: () => barcodeData.isEmpty
          ? null
          : showDialog(
              context: context,
              builder: (BuildContext context) => Dialog(
                insetPadding: const EdgeInsets.all(0),
                child: Container(
                  height: height,
                  width: width,
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 20),
                        barcodeCreationProvider.getScannedCode(),
                        const SizedBox(height: 50),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Close'),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      child: Text(buttonText),
    );
  }
}
