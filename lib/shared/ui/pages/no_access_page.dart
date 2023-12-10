import 'package:flutter/material.dart';
import 'package:inventory_system/shared/ui/widgets/base_scaffold.dart';

class NoAccessPage extends StatelessWidget {
  const NoAccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(title: const Text("No Access")),
      body: const Center(
          child: Text("You do not have permission to access this page.")),
    );
  }
}
