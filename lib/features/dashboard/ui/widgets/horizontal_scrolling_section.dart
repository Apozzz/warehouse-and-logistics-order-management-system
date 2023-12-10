import 'package:flutter/material.dart';

class HorizontalScrollingSection extends StatelessWidget {
  final int itemCount;
  final Widget Function(int) itemBuilder;
  final double
      itemWidthFactor; // Factor of the screen width, e.g., 0.85 for 85%
  final EdgeInsets padding;

  const HorizontalScrollingSection({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    this.itemWidthFactor = 0.85,
    this.padding = const EdgeInsets.all(16.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth =
            constraints.maxWidth * itemWidthFactor - padding.horizontal;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: IntrinsicHeight(
              child: Row(
                children: List.generate(
                  itemCount,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      left: (index == 0) ? padding.left : padding.left / 2,
                      right: (index == itemCount - 1)
                          ? padding.right
                          : padding.left / 2,
                    ),
                    child: SizedBox(
                      width: itemWidth,
                      child: itemBuilder(index),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
