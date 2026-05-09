// lib/features/auth/presentation/auth_screen.dart
import 'package:flutter/material.dart';
import 'package:registry/src/common/app_theme.dart';
import 'package:registry/src/common/widgets/app_buttons.dart';
import 'package:registry/src/common/widgets/app_snackbar.dart';
import 'package:registry/src/common/widgets/app_text_field.dart';
import 'package:registry/src/features/auth/data/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  // Login controllers
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  // Sign‑up controllers
  final _studentIdCtrl = TextEditingController();
  final _studentNameCtrl = TextEditingController();
  final _signupEmailCtrl = TextEditingController();
  final _signupPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscureLoginPassword = true;
  bool _obscureSignupPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _studentIdCtrl.dispose();
    _studentNameCtrl.dispose();
    _signupEmailCtrl.dispose();
    _signupPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final AuthResult result;
    if (_isLogin) {
      result = await _authService.login(
        _emailCtrl.text.trim(),
        _passwordCtrl.text.trim(),
      );
    } else {
      result = await _authService.signUp(
        studentId: _studentIdCtrl.text.trim(),
        studentName: _studentNameCtrl.text.trim(),
        email: _signupEmailCtrl.text.trim(),
        password: _signupPasswordCtrl.text.trim(),
      );
    }

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result.success) {
      AppSnackbar.success(
        context,
        _isLogin ? 'Welcome back!' : 'Account created!',
      );
      if (_isLogin) {
        // Navigate to home (replace with your route)
        // Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Automatically switch to login after successful signup
        setState(() => _isLogin = true);
        _clearSignUpFields();
      }
    } else {
      AppSnackbar.error(context, result.error ?? 'Something went wrong');
    }
  }

  void _clearSignUpFields() {
    _studentIdCtrl.clear();
    _studentNameCtrl.clear();
    _signupEmailCtrl.clear();
    _signupPasswordCtrl.clear();
    _confirmPasswordCtrl.clear();
  }

  void _forgotPassword() {
    final emailCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>(); // local validation for the dialog
    bool isSending = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return Container(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 32,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag handle
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Illustration / Icon
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_reset_rounded,
                        size: 36,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title & subtitle
                    const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your registered email address\nand we’ll send you a reset link.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Email field
                    AppTextField(
                      controller: emailCtrl,
                      label: 'Email address',
                      hint: 'student@university.edu',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: AppTheme.primary,
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Email required';
                        }
                        if (!v.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Send button
                    AppPrimaryButton(
                      label: isSending ? 'Sending...' : 'Send Reset Link',
                      isLoading: isSending,
                      icon: const Icon(Icons.send_rounded, size: 20),
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) return;

                        setDialogState(() => isSending = true);
                        final result = await _authService.resetPassword(
                          emailCtrl.text.trim(),
                        );
                        setDialogState(() => isSending = false);

                        if (!mounted) return;
                        Navigator.pop(ctx);

                        if (result.success) {
                          AppSnackbar.success(
                            context,
                            'Reset link sent! Check your inbox.',
                          );
                        } else {
                          AppSnackbar.error(
                            context,
                            result.error ?? 'Could not send email',
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    // Cancel link
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(
                        'Back to Login',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ---------- Top Banner ----------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 48, bottom: 32),
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    // Logo placeholder – replace with your asset
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        size: 48,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'UniComplaints',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isLogin
                          ? 'Sign in to your account'
                          : 'Create a new student account',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),

              // ---------- Toggle & Form Card ----------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    // Toggle
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _isLogin = true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: _isLogin
                                      ? AppTheme.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  'Login',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: _isLogin
                                        ? Colors.white
                                        : AppTheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _isLogin = false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: !_isLogin
                                      ? AppTheme.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  'Sign Up',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: !_isLogin
                                        ? Colors.white
                                        : AppTheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Form Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: _isLogin
                              ? _buildLoginFields()
                              : _buildSignUpFields(),
                        ),
                      ),
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

  // ----- Login fields -----
  List<Widget> _buildLoginFields() {
    return [
      AppTextField(
        controller: _emailCtrl,
        label: 'Email',
        hint: 'student@university.edu',
        keyboardType: TextInputType.emailAddress,
        prefixIcon: const Icon(Icons.email_outlined, color: AppTheme.primary),
        validator: (v) => v!.isEmpty ? 'Email required' : null,
      ),
      const SizedBox(height: 20),
      AppTextField(
        controller: _passwordCtrl,
        label: 'Password',
        obscureText: _obscureLoginPassword,
        prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.primary),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureLoginPassword ? Icons.visibility_off : Icons.visibility,
            color: AppTheme.primary,
          ),
          onPressed: () =>
              setState(() => _obscureLoginPassword = !_obscureLoginPassword),
        ),
        validator: (v) => v!.isEmpty ? 'Password required' : null,
      ),
      const SizedBox(height: 24),
      AppPrimaryButton(
        label: 'Login',
        isLoading: _isLoading,
        icon: const Icon(Icons.login, size: 20),
        onPressed: _handleSubmit,
      ),
      const SizedBox(height: 16),
      TextButton(
        onPressed: _forgotPassword,
        child: const Text(
          'Forgot Password?',
          style: TextStyle(color: AppTheme.primary),
        ),
      ),
    ];
  }

  // ----- Sign‑up fields -----
  List<Widget> _buildSignUpFields() {
    return [
      AppTextField(
        controller: _studentIdCtrl,
        label: 'Student ID',
        hint: 'UNI2024XXXX',
        prefixIcon: const Icon(Icons.badge_outlined, color: AppTheme.primary),
        validator: (v) => v!.isEmpty ? 'Student ID required' : null,
      ),
      const SizedBox(height: 20),
      AppTextField(
        controller: _studentNameCtrl,
        label: 'Full Name',
        prefixIcon: const Icon(Icons.person_outline, color: AppTheme.primary),
        validator: (v) => v!.isEmpty ? 'Name required' : null,
      ),
      const SizedBox(height: 20),
      AppTextField(
        controller: _signupEmailCtrl,
        label: 'Email',
        hint: 'student@university.edu',
        keyboardType: TextInputType.emailAddress,
        prefixIcon: const Icon(Icons.email_outlined, color: AppTheme.primary),
        validator: (v) {
          if (v == null || v.isEmpty) return 'Email required';
          if (!v.contains('@')) return 'Invalid email';
          return null;
        },
      ),
      const SizedBox(height: 20),
      AppTextField(
        controller: _signupPasswordCtrl,
        label: 'Password',
        obscureText: _obscureSignupPassword,
        prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.primary),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureSignupPassword ? Icons.visibility_off : Icons.visibility,
            color: AppTheme.primary,
          ),
          onPressed: () =>
              setState(() => _obscureSignupPassword = !_obscureSignupPassword),
        ),
        validator: (v) => v!.length < 6 ? 'Min 6 characters' : null,
      ),
      const SizedBox(height: 20),
      AppTextField(
        controller: _confirmPasswordCtrl,
        label: 'Confirm Password',
        obscureText: _obscureConfirmPassword,
        prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.primary),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
            color: AppTheme.primary,
          ),
          onPressed: () => setState(
            () => _obscureConfirmPassword = !_obscureConfirmPassword,
          ),
        ),
        validator: (v) {
          if (v != _signupPasswordCtrl.text) return 'Passwords do not match';
          return null;
        },
      ),
      const SizedBox(height: 24),
      AppPrimaryButton(
        label: 'Create Account',
        isLoading: _isLoading,
        icon: const Icon(Icons.person_add, size: 20),
        onPressed: _handleSubmit,
      ),
      const SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have an account?',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          TextButton(
            onPressed: () => setState(() => _isLogin = true),
            child: const Text(
              'Login',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    ];
  }
}
