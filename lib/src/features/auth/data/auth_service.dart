// lib/features/auth/data/auth_service.dart
class AuthResult {
  final bool success;
  final String? error;
  AuthResult({required this.success, this.error});
}

class AuthService {
  static bool _isLoggedIn = false;
  static bool get isLoggedIn => _isLoggedIn;

  /// Call after successful login
  static void setLoggedIn(bool value) {
    _isLoggedIn = value;
  }

  /// Simulate logout (will be replaced by Supabase signOut)
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _isLoggedIn = false;
  }

  // ---------- Auth methods (unchanged from before) ----------
  Future<AuthResult> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'ak' && password == 'ak') {
      _isLoggedIn = true; // persist session
      return AuthResult(success: true);
    }
    return AuthResult(success: false, error: 'Invalid credentials');
  }

  Future<AuthResult> signUp({
    required String studentId,
    required String studentName,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email.contains('@')) {
      return AuthResult(success: true);
    }
    return AuthResult(success: false, error: 'Registration failed');
  }

  Future<AuthResult> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    return AuthResult(success: true);
  }
}
