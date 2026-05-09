import 'package:flutter/material.dart';
import 'package:registry/src/common/app_theme.dart';

class StatusChip extends StatelessWidget {
  final String status;
  const StatusChip({super.key, required this.status});

  Color _color() {
    switch (status.toLowerCase()) {
      case 'pending': return AppTheme.statusPending;
      case 'under review': return AppTheme.statusUnderReview;
      case 'resolved': return AppTheme.statusResolved;
      case 'rejected': return AppTheme.statusRejected;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _color().withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: _color())),
          const SizedBox(width: 6),
          Text(status, style: TextStyle(color: _color(), fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}