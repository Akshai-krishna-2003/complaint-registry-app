// lib/features/auth/data/auth_service.dart
class AuthResult {
  final bool success;
  final String? error;       // user‑facing error message
  AuthResult({required this.success, this.error});
}

class AuthService {
  /// Login with email and password
  Future<AuthResult> login(String email, String password) async {
    // TODO: replace with Supabase call
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'test@uni.edu' && password == 'password') {
      return AuthResult(success: true);
    }
    return AuthResult(success: false, error: 'Invalid credentials');
  }

  /// Sign up a new student
  Future<AuthResult> signUp({
    required String studentId,
    required String studentName,
    required String email,
    required String password,
  }) async {
    // TODO: replace with Supabase call
    await Future.delayed(const Duration(seconds: 1));
    if (email.contains('@')) {
      return AuthResult(success: true);
    }
    return AuthResult(success: false, error: 'Registration failed');
  }

  /// Send password reset email
  Future<AuthResult> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    return AuthResult(success: true);
  }
}