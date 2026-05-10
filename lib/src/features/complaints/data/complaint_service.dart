import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

class ComplaintService {
  final _supabase = Supabase.instance.client;

  /// Insert complaint and return the generated UUID.
  Future<String> createComplaint({
    required String studentId,
    required String studentName,
    required String email,
    required String complaintType,
    required String location,
    String? accusedPerson,
    required String description,
  }) async {
    final response = await _supabase
        .from('complaints')
        .insert({
          'user_id': studentId, // matches users.student_id (PK)
          'student_id': studentId,
          'student_name': studentName,
          'email': email,
          'complaint_type': complaintType,
          'location': location,
          'accused_person': accusedPerson,
          'description': description,
          // status defaults to 'Pending'
        })
        .select('id')
        .single();

    return response['id'] as String;
  }

  /// Upload evidence image and return the public URL.
  Future<String> uploadEvidence({
    required String complaintId,
    required String fileName,
    required Uint8List fileBytes,
  }) async {
    final path = 'complaints/$complaintId/$fileName';
    await _supabase.storage
        .from('complaints')
        .uploadBinary(
          path,
          fileBytes,
          fileOptions: const FileOptions(upsert: true),
        );
    // Get public URL
    return _supabase.storage.from('complaints').getPublicUrl(path);
  }

  /// Update complaint with evidence URL.
  Future<void> setEvidenceUrl({
    required String complaintId,
    required String evidenceUrl,
  }) async {
    await _supabase
        .from('complaints')
        .update({'evidence_url': evidenceUrl})
        .eq('id', complaintId);
  }
}
