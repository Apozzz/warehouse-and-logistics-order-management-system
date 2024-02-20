import 'package:flutter/material.dart';

class SubmitDeclineReasonDialog extends StatefulWidget {
  final Function(String reason) onSubmit;
  final String note;

  const SubmitDeclineReasonDialog(
      {Key? key, required this.onSubmit, this.note = ""})
      : super(key: key);

  @override
  _SubmitDeclineReasonDialogState createState() =>
      _SubmitDeclineReasonDialogState();
}

class _SubmitDeclineReasonDialogState extends State<SubmitDeclineReasonDialog> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Provide Decline Reason"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.note,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.redAccent),
          ),
          TextField(
            controller: _reasonController,
            decoration: const InputDecoration(hintText: "Decline reason"),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final reason = _reasonController.text.trim();
            if (reason.isNotEmpty) {
              widget.onSubmit(reason);
              Navigator.pop(context);
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
