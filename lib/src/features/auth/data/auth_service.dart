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
      final UserCredential userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!userCred.user!.emailVerified) {
        await _auth.signOut();
        return AuthResult(
          success: false,
          error: 'Please verify your email first. Check your inbox or spam.',
        );
      }

      final response = await _supabase
          .from('users')
          .select()
          .eq('email', email)
          .maybeSingle();

      if (response == null) {
        await _auth.signOut();
        return AuthResult(success: false, error: 'Student profile not found');
      }

      final data = response;

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
      // 1. Check if student_id already exists in Supabase
      final existingStudentId = await _supabase
          .from('users')
          .select('student_id')
          .eq('student_id', studentId)
          .maybeSingle();

      if (existingStudentId != null) {
        return AuthResult(
          success: false,
          error: 'This Student ID is already registered.',
        );
      }

      // 2. Check if email already exists in Supabase
      final existingEmail = await _supabase
          .from('users')
          .select('email')
          .eq('email', email)
          .maybeSingle();

      if (existingEmail != null) {
        return AuthResult(
          success: false,
          error: 'This email is already registered.',
        );
      }

      // 3. Create Firebase Auth user
      final UserCredential userCred = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCred.user == null) {
        return AuthResult(success: false, error: 'Registration failed');
      }

      // 4. Insert into Supabase
      await _supabase.from('users').insert({
        'student_id': studentId,
        'student_name': studentName,
        'email': email,
      });

      // 5. Send verification email
      await userCred.user!.sendEmailVerification();

      // 6. Sign out – they must verify before login
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
    await prefs.clear();
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
