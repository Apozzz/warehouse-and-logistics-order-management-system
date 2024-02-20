import 'package:flutter/material.dart';

class QuantityInputDialog extends StatefulWidget {
  final int maxQuantity;

  const QuantityInputDialog({super.key, required this.maxQuantity});

  @override
  _QuantityInputDialogState createState() => _QuantityInputDialogState();
}

class _QuantityInputDialogState extends State<QuantityInputDialog> {
  final TextEditingController _controller = TextEditingController();
  String? errorMessage; // For displaying error messages

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Quantity'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Quantity",
              errorText: errorMessage, // Display the error message if any
            ),
            onChanged: (value) {
              // Reset error message on change
              if (errorMessage != null) setState(() => errorMessage = null);
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () =>
              Navigator.of(context).pop(1), // Default to 1 if canceled
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            final int quantity = int.tryParse(_controller.text) ?? 0;
            if (quantity > 0 && quantity <= widget.maxQuantity) {
              Navigator.of(context).pop(quantity); // Return quantity if valid
            } else {
              // Set error message and prevent dialog from closing
              setState(() => errorMessage =
                  'Quantity must be between 1 and ${widget.maxQuantity}.');
            }
          },
        ),
      ],
    );
  }
}
