import 'package:flutter/material.dart';
import 'package:registry/src/common/app_theme.dart';
import 'package:registry/src/common/widgets/app_text_field.dart';

class ProfileScreen extends StatelessWidget {
  final String studentName;
  final String studentId;
  final String email;

  const ProfileScreen({
    super.key,
    required this.studentName,
    required this.studentId,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            // Avatar
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: AppTheme.secondary,
                child: Text(
                  studentName.isNotEmpty
                      ? studentName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            AppTextField(
              controller: TextEditingController(text: studentId),
              label: 'Student ID',
              readOnly: true,
              prefixIcon: const Icon(Icons.badge_outlined, color: AppTheme.primary),
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: TextEditingController(text: studentName),
              label: 'Full Name',
              readOnly: true,
              prefixIcon: const Icon(Icons.person_outline, color: AppTheme.primary),
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: TextEditingController(text: email),
              label: 'Email',
              readOnly: true,
              prefixIcon: const Icon(Icons.email_outlined, color: AppTheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}