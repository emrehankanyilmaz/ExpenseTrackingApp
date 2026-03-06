import 'package:flutter/material.dart';

class TransactionRow extends StatelessWidget {
  final String label;
  final Widget child;

  const TransactionRow({
    super.key,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
