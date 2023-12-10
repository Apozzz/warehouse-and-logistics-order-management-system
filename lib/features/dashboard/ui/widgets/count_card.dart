import 'package:flutter/material.dart';

class CountCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const CountCard({
    Key? key,
    required this.title,
    required this.count,
    this.color = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              '$count',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
