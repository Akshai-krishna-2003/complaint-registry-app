import 'package:flutter/material.dart';
import 'package:registry/src/common/app_theme.dart';

class AppSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
    IconData? icon,
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
          Expanded(
            child: Text(message, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      backgroundColor: backgroundColor ?? AppTheme.primary,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void success(BuildContext context, String message) {
    show(
      context,
      message: message,
      backgroundColor: AppTheme.statusResolved,
      icon: Icons.check_circle_outline,
    );
  }

  static void error(BuildContext context, String message) {
    show(
      context,
      message: message,
      backgroundColor: AppTheme.error,
      icon: Icons.error_outline,
    );
  }
}
