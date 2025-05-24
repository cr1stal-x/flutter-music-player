import 'package:flutter/material.dart';
class NeuBox extends StatelessWidget {
  final Widget? child;

  const NeuBox({
    super.key,
    required this.child,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary,
              blurRadius: 15,
              offset: Offset(2, 2),
            ),
            BoxShadow(
              color: Theme.of(context).colorScheme.surface,
              blurRadius: 15,
              offset: Offset(-2, -2),
            )
          ]
      ),
      child: child,
    );
  }
}