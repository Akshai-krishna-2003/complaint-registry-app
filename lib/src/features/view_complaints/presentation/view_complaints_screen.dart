import 'package:flutter/material.dart';
import 'package:registry/src/common/app_theme.dart';
import 'package:registry/src/common/widgets/complaint_card.dart';
import 'package:registry/src/features/auth/data/auth_service.dart';
import 'package:registry/src/features/view_complaints/data/complaint_view_service.dart';
import 'package:registry/src/features/view_complaints/presentation/complaint_detail_screen.dart';

class ViewComplaintsScreen extends StatefulWidget {
  const ViewComplaintsScreen({super.key});

  @override
  State<ViewComplaintsScreen> createState() => _ViewComplaintsScreenState();
}

class _ViewComplaintsScreenState extends State<ViewComplaintsScreen> {
  final ComplaintViewService _viewService = ComplaintViewService();
  List<Map<String, dynamic>> _complaints = [];
  String _studentId = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final userData = await AuthService.getSavedUser();
    setState(() {
      _studentId = userData['student_id'] ?? '';
    });
    if (_studentId.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }
    try {
      final data = await _viewService.getComplaintsForStudent(
        studentId: _studentId,
      );
      if (mounted) {
        setState(() {
          _complaints = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return '';
    final dt = DateTime.tryParse(isoDate);
    if (dt == null) return isoDate;
    return '${dt.day} ${_monthAbbr(dt.month)} ${dt.year}';
  }

  String _monthAbbr(int m) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[m];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Complaints')),
      body: _isLoading
          ? _buildShimmer() // shimmer loading placeholder
          : RefreshIndicator(
              onRefresh: _loadData,
              color: AppTheme.primary,
              child: _complaints.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 4,
                      ),
                      itemCount: _complaints.length,
                      itemBuilder: (context, index) {
                        final c = _complaints[index];
                        return ComplaintCard(
                          complaintType: c['complaint_type'] ?? '',
                          status: c['status'] ?? 'Pending',
                          date: _formatDate(c['created_at']),
                          location: c['location'] ?? '',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ComplaintDetailScreen(complaint: c),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
    );
  }

  Widget _buildShimmer() {
    // Simple animated placeholder – you can replace with shimmer package later
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: 3,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No complaints yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your submitted complaints will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}
