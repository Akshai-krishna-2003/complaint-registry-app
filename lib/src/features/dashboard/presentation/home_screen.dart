import 'package:flutter/material.dart';
import 'package:registry/src/common/app_theme.dart';
import 'package:registry/src/features/auth/data/auth_service.dart';
import 'package:registry/src/features/complaints/presentation/register_complaint_screen.dart';
import 'package:registry/src/features/dashboard/presentation/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _studentName = '';
  String _studentId = '';
  String _email = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final data = await AuthService.getSavedUser();
    if (mounted) {
      setState(() {
        _studentName = data['student_name'] ?? 'Student';
        _studentId = data['student_id'] ?? '';
        _email = data['email'] ?? '';
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    await AuthService().logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/auth');
  }

  String get _firstName {
    return _studentName.split(' ').first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UniComplaints'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileScreen(
                  studentName: _studentName,
                  studentId: _studentId,
                  email: _email,
                ),
              ),
            ),
            child: CircleAvatar(
              backgroundColor: AppTheme.secondary,
              child: Text(
                _firstName.isNotEmpty ? _firstName[0].toUpperCase() : '✍',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    // Welcome header
                    Text(
                      'Welcome, $_firstName',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(color: AppTheme.primary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'How can we help you today?',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Three large buttons
                    Expanded(
                      child: Column(
                        children: [
                          _buildNavButton(
                            icon: Icons.add_circle_outline,
                            label: 'Register Complaint',
                            color: AppTheme.primary,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const RegisterComplaintScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildNavButton(
                            icon: Icons.list_alt_rounded,
                            label: 'View Your Complaints',
                            color: AppTheme.secondary,
                            onTap: () {
                              // Navigator.pushNamed(context, '/view-complaints');
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildNavButton(
                            icon: Icons.help_outline,
                            label: 'FAQs',
                            color: const Color(0xFF5F6B7A),
                            onTap: () {
                              // Navigator.pushNamed(context, '/faqs');
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shadowColor: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
