import 'package:flutter/material.dart';

class OngoingSessionDialog extends StatelessWidget {
  final String deliveryId;
  final VoidCallback onContinue;

  const OngoingSessionDialog({
    Key? key,
    required this.deliveryId,
    required this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Ongoing Delivery"),
      content: Text(
          "You have an ongoing delivery: $deliveryId. Would you like to continue tracking it?"),
      actions: <Widget>[
        TextButton(
          child: const Text("Yes"),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            onContinue();
          },
        ),
        TextButton(
          child: const Text("No"),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
      ],
    );
  }
}
