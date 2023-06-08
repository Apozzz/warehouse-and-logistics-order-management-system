import 'package:inventory_system/imports.dart';

class CircularProgressIndicatorWithText extends StatelessWidget {
  String text;

  CircularProgressIndicatorWithText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(
          height: 80,
          width: 80,
          child: CircularProgressIndicator(),
        ),
        const SizedBox(height: 50),
        text.isNotEmpty
            ? Text(
                text,
                style: Theme.of(context).textTheme.titleLarge,
              )
            : const SizedBox(width: 0, height: 0),
      ],
    );
  }
}
