import 'package:flutter/material.dart';
import 'package:gider_takip/features/transactions/presentation/widgets/base_text.dart';

class DateButtonWidget extends StatelessWidget {
  const DateButtonWidget({
    super.key,
    required this.label,
    required this.onTap,
  });
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BaseText.bodyMedium(context, data: label, color: Colors.black87),
            const Icon(Icons.calendar_today_outlined,
                size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
