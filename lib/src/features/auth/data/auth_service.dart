// lib/features/auth/data/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthResult {
  final bool success;
  final String? error;
  AuthResult({required this.success, this.error});
}

class AuthService {
  static const _keyStudentId = 'student_id';
  static const _keyStudentName = 'student_name';
  static const _keyEmail = 'email';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SupabaseClient _supabase = Supabase.instance.client;

  // ---------- Login ----------
  Future<AuthResult> login(String email, String password) async {
    try {
      // 1. Sign in with Firebase Auth
      final UserCredential userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Check email verification status
      if (!userCred.user!.emailVerified) {
        await _auth.signOut(); // immediately sign out unverified users
        return AuthResult(
          success: false,
          error: 'Please verify your email first. Check your inbox.',
        );
      }

      // 3. Retrieve student details from your Supabase `users` table
      final response = await _supabase
          .from('users')
          .select()
          .eq('email', email)
          .maybeSingle(); // safe: returns null if no row found

      if (response == null) {
        await _auth.signOut(); // no matching student profile – sign out
        return AuthResult(success: false, error: 'Student profile not found');
      }

      final data = response;

      // 4. Save the three fields to SharedPreferences
      await _saveUserData(
        studentId: data['student_id'] ?? '',
        studentName: data['student_name'] ?? '',
        email: data['email'] ?? email,
      );

      return AuthResult(success: true);
    } on FirebaseAuthException catch (e) {
      return AuthResult(success: false, error: e.message);
    } catch (e) {
      return AuthResult(success: false, error: 'Something went wrong');
    }
  }

  // ---------- Sign Up ----------
  Future<AuthResult> signUp({
    required String studentId,
    required String studentName,
    required String email,
    required String password,
  }) async {
    try {
      // 1. Create the Firebase Auth user
      final UserCredential userCred = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCred.user == null) {
        return AuthResult(success: false, error: 'Registration failed');
      }

      // 2. Check if this email already exists in the Supabase `users` table
      final existing = await _supabase
          .from('users')
          .select('email')
          .eq('email', email)
          .maybeSingle();

      // 3. If not present, insert a new row (student_id is the PK)
      if (existing == null) {
        await _supabase.from('users').insert({
          'student_id': studentId,
          'student_name': studentName,
          'email': email,
          // created_at will use the DB default
        });
      }
      // If a row already exists with this email, skip insertion – no duplication

      // 4. Send email verification
      await userCred.user!.sendEmailVerification();

      // 5. Sign them out immediately (they must verify before login)
      await _auth.signOut();

      return AuthResult(success: true);
    } on FirebaseAuthException catch (e) {
      return AuthResult(success: false, error: e.message);
    } on PostgrestException catch (e) {
      return AuthResult(success: false, error: 'Database error: ${e.message}');
    } catch (e) {
      return AuthResult(success: false, error: 'Registration failed');
    }
  }

  // ---------- Reset Password ----------
  Future<AuthResult> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return AuthResult(success: true);
    } on FirebaseAuthException catch (e) {
      return AuthResult(success: false, error: e.message);
    } catch (e) {
      return AuthResult(success: false, error: 'Could not send reset email');
    }
  }

  // ---------- Logout ----------
  Future<void> logout() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // wipe saved student data
  }

  // ---------- Check if logged in ----------
  static bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;

  // ---------- Save to SharedPreferences ----------
  Future<void> _saveUserData({
    required String studentId,
    required String studentName,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyStudentId, studentId);
    await prefs.setString(_keyStudentName, studentName);
    await prefs.setString(_keyEmail, email);
  }

  // ---------- Retrieve saved user data ----------
  static Future<Map<String, String?>> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'student_id': prefs.getString(_keyStudentId),
      'student_name': prefs.getString(_keyStudentName),
      'email': prefs.getString(_keyEmail),
    };
  }
}
