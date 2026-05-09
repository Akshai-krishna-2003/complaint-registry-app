// ===================== TEST SCREEN =====================
import 'package:flutter/material.dart';
import 'package:registry/src/common/app_theme.dart';
import 'package:registry/src/common/widgets/app_buttons.dart';
import 'package:registry/src/common/widgets/app_snackbar.dart';
import 'package:registry/src/common/widgets/app_text_field.dart';
import 'package:registry/src/common/widgets/complaint_card.dart';
import 'package:registry/src/common/widgets/status_chip.dart';

class TestScreen extends StatelessWidget {
  TestScreen({super.key});

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  final List<Map<String, String>> complaints = [
    {
      'type': 'WiFi Issue',
      'status': 'Pending',
      'date': '10 May 2026',
      'location': 'Main Library',
    },
    {
      'type': 'Hostel Complaint',
      'status': 'Under Review',
      'date': '09 May 2026',
      'location': 'Block C, Room 302',
    },
    {
      'type': 'Exam Related Complaint',
      'status': 'Resolved',
      'date': '08 May 2026',
      'location': 'Exam Hall 2',
    },
    {
      'type': 'Cafeteria Complaint',
      'status': 'Rejected',
      'date': '07 May 2026',
      'location': 'Central Canteen',
    },
  ];

  void _showSnackbars(BuildContext context) {
    AppSnackbar.success(context, 'This is a success snackbar');
    Future.delayed(const Duration(seconds: 4), () {
      AppSnackbar.error(context, 'This is an error snackbar');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UI Components Test')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Text(
              'Text Fields',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: nameCtrl,
              label: 'Full Name',
              hint: 'Enter your name',
              prefixIcon: const Icon(
                Icons.person_outline,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: emailCtrl,
              label: 'Email',
              hint: 'you@example.com',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(
                Icons.email_outlined,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: passwordCtrl,
              label: 'Password',
              obscureText: true,
              suffixIcon: const Icon(
                Icons.visibility_off_outlined,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: TextEditingController(text: 'Read-only content'),
              label: 'Read-only Field',
              readOnly: true,
            ),

            const SizedBox(height: 32),
            Text('Buttons', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            AppPrimaryButton(
              label: 'Primary Action',
              icon: const Icon(Icons.check, size: 20),
              onPressed: () =>
                  AppSnackbar.success(context, 'Primary button pressed'),
            ),
            const SizedBox(height: 12),
            AppPrimaryButton(
              label: 'Loading State',
              isLoading: true,
              onPressed: () {},
            ),
            const SizedBox(height: 12),
            AppOutlinedButton(
              label: 'Outlined Action',
              onPressed: () =>
                  AppSnackbar.error(context, 'Outlined button pressed'),
            ),
            const SizedBox(height: 12),
            AppPrimaryButton(
              label: 'Show Snackbars',
              onPressed: () => _showSnackbars(context),
            ),

            const SizedBox(height: 32),
            Text(
              'Status Chips',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                StatusChip(status: 'Pending'),
                StatusChip(status: 'Under Review'),
                StatusChip(status: 'Resolved'),
                StatusChip(status: 'Rejected'),
              ],
            ),

            const SizedBox(height: 32),
            Text(
              'Complaint Cards',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ...complaints.map(
              (c) => ComplaintCard(
                complaintType: c['type']!,
                status: c['status']!,
                date: c['date']!,
                location: c['location']!,
                onTap: () => AppSnackbar.show(
                  context,
                  message: 'Tapped on ${c['type']}',
                ),
              ),
            ),

            const SizedBox(height: 32),
            AppPrimaryButton(
              label: 'Test Error Snackbar',
              icon: const Icon(Icons.warning_amber_rounded, size: 20),
              onPressed: () =>
                  AppSnackbar.error(context, 'Something went wrong.'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ===================== MAIN ENTRY =====================
void main() {
  runApp(
    MaterialApp(
      title: 'UniComplaints UI Test',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: TestScreen(),
    ),
  );
}
