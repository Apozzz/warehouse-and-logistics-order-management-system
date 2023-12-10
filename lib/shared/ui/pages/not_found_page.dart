import 'package:flutter/material.dart';
import 'package:inventory_system/shared/ui/widgets/base_scaffold.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: const Text("Page Not Found"),
      ),
      body: const Center(
        child: Text(
          "404\nPage not found",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
