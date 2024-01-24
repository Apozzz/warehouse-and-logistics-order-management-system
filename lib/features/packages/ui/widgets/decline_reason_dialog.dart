import 'package:flutter/material.dart';

class DeclineReasonDialog extends StatelessWidget {
  final String declineReason;

  const DeclineReasonDialog({Key? key, required this.declineReason})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Decline Reason"),
      content: Text(declineReason),
      actions: <Widget>[
        TextButton(
          child: const Text("Close"),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
