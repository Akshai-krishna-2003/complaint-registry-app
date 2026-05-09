import 'package:flutter/material.dart';
import 'package:registry/src/common/app_theme.dart';
import 'package:registry/src/common/widgets/status_chip.dart';

class ComplaintCard extends StatelessWidget {
  final String complaintType;
  final String status;
  final String date;
  final String location;
  final VoidCallback onTap;

  const ComplaintCard({
    super.key,
    required this.complaintType,
    required this.status,
    required this.date,
    required this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(complaintType, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.onSurface)),
                  ),
                  StatusChip(status: status),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 14, color: Color(0xFF667085)),
                  const SizedBox(width: 6),
                  Text(date, style: const TextStyle(fontSize: 13, color: Color(0xFF667085))),
                  const SizedBox(width: 16),
                  const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF667085)),
                  const SizedBox(width: 6),
                  Expanded(child: Text(location, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, color: Color(0xFF667085)))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}