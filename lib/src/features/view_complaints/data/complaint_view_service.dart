import 'package:supabase_flutter/supabase_flutter.dart';

class ComplaintViewService {
  final _supabase = Supabase.instance.client;

  /// Fetch all complaints for a given student_id
  Future<List<Map<String, dynamic>>> getComplaintsForStudent({
    required String studentId,
  }) async {
    final response = await _supabase
        .from('complaints')
        .select()
        .eq('student_id', studentId)
        .order('created_at', ascending: false);
    return (response as List<dynamic>).cast<Map<String, dynamic>>();
  }

  /// Fetch all admin replies for a given complaint_id
  Future<List<Map<String, dynamic>>> getAdminReplies({
    required String complaintId,
  }) async {
    final response = await _supabase
        .from('admin_replies')
        .select()
        .eq('complaint_id', complaintId)
        .order('created_at', ascending: true);
    return (response as List<dynamic>).cast<Map<String, dynamic>>();
  }
  
}