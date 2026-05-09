import 'package:flutter/material.dart';
import 'package:registry/src/common/app_colors.dart';

enum SnackBarType { success, failure, warning, info }

void showAppSnackBar(
  BuildContext context, {
  required String message,
  required SnackBarType type,
  Duration duration = const Duration(seconds: 3),
}) {
  // Map type to icon & color
  late final IconData icon;
  late final Color backgroundColor;
  late final Color textColor;

  switch (type) {
    case SnackBarType.success:
      icon = Icons.check_circle_outline;
      backgroundColor = AppColors.success;
      textColor = Colors.white;
      break;
    case SnackBarType.failure:
      icon = Icons.error_outline;
      backgroundColor = AppColors.failure;
      textColor = Colors.white;
      break;
    case SnackBarType.warning:
      icon = Icons.warning_amber_rounded;
      backgroundColor = AppColors.warning;
      textColor = Colors.black;
      break;
    case SnackBarType.info:
      icon = Icons.info_outline;
      backgroundColor = AppColors.info;
      textColor = Colors.white;
      break;
  }

  // Hide any existing snackbar first
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(icon, color: textColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    ),
  );
}