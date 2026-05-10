import 'package:flutter/material.dart';
import 'package:registry/src/common/app_theme.dart';
import 'package:registry/src/common/widgets/status_chip.dart';
import 'package:registry/src/features/view_complaints/data/complaint_view_service.dart';

class ComplaintDetailScreen extends StatefulWidget {
  final Map<String, dynamic> complaint;
  const ComplaintDetailScreen({super.key, required this.complaint});

  @override
  State<ComplaintDetailScreen> createState() => _ComplaintDetailScreenState();
}

class _ComplaintDetailScreenState extends State<ComplaintDetailScreen> {
  final ComplaintViewService _viewService = ComplaintViewService();
  late Future<List<Map<String, dynamic>>> _repliesFuture;

  @override
  void initState() {
    super.initState();
    _repliesFuture = _viewService.getAdminReplies(
      complaintId: widget.complaint['id'],
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.complaint;
    final evidenceUrl = c['evidence_url'] as String?;
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(title: const Text('Complaint Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Title Header (type + status) ───
            _buildHeader(c['complaint_type'] ?? '', c['status'] ?? 'Pending'),
            const SizedBox(height: 24),

            // ─── General Info Card ───
            _buildCard(
              title: 'Complaint Information',
              icon: Icons.info_outline,
              children: [
                _detailRow(
                  Icons.category_outlined,
                  'Type',
                  c['complaint_type'] ?? '',
                ),
                _divider(),
                _detailRow(
                  Icons.location_on_outlined,
                  'Location',
                  c['location'] ?? '',
                ),
                if ((c['accused_person'] ?? '').isNotEmpty) ...[
                  _divider(),
                  _detailRow(
                    Icons.person_outline,
                    'Accused',
                    c['accused_person'],
                  ),
                ],
                _divider(),
                _detailRow(
                  Icons.calendar_today_outlined,
                  'Submitted',
                  _formatDate(c['created_at']),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ─── Description Card ───
            _buildCard(
              title: 'Description',
              icon: Icons.description_outlined,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    c['description'] ?? '',
                    style: const TextStyle(
                      height: 1.6,
                      fontSize: 15,
                      color: AppTheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ─── Evidence Card (if exists) ───
            if (evidenceUrl != null && evidenceUrl.isNotEmpty) ...[
              _buildCard(
                title: 'Evidence',
                icon: Icons.camera_alt_outlined,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          backgroundColor: Colors.transparent,
                          child: InteractiveViewer(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(evidenceUrl),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          evidenceUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, error, stack) => Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.broken_image,
                                size: 48,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],

            // ─── Admin Replies ───
            _buildCard(
              title: 'Admin Replies',
              icon: Icons.reply_all_outlined,
              children: [
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _repliesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (snapshot.hasError || snapshot.data == null) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Could not load replies',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      );
                    }
                    final replies = snapshot.data!;
                    if (replies.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            'No replies yet',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: replies
                          .map((reply) => _replyTile(reply))
                          .toList(),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ─────────────── Helper Widgets ───────────────

  Widget _buildHeader(String type, String status) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary, AppTheme.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Complaint',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              StatusChip(status: status),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            type,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: AppTheme.primary),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppTheme.primary.withOpacity(0.8)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(height: 1, color: Colors.grey.shade200);
  }

  Widget _replyTile(Map<String, dynamic> reply) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppTheme.secondary,
                child: Text(
                  (reply['admin_name'] ?? 'A')[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  reply['admin_name'] ?? 'Administrator',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
              ),
              Text(
                _formatDate(reply['created_at']),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            reply['reply'] ?? '',
            style: const TextStyle(
              height: 1.5,
              fontSize: 15,
              color: AppTheme.onSurface,
            ),
          ),
        ],
      ),
    );
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
}
