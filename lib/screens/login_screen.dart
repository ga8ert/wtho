import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/app/app_bloc.dart';
import '../bloc/app/app_event.dart';
import '../l10n/app_localizations.dart';
import '../source/colors.dart';
import 'custom_logo.dart';
import '../widgets/email_pass_form.dart';
import '../widgets/sign_up_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;
  bool _obscure = true;
  bool _loading = false;

  void _login() {
    setState(() => _loading = true);
    context.read<AuthBloc>().add(
      EmailLoginRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  void _forgotPassword() {
    final controller = TextEditingController(text: _emailController.text);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(hintText: 'Enter your email'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final email = controller.text.trim();
              if (email.isNotEmpty) {
                context.read<AuthBloc>().add(
                  RecoverPasswordRequested(email: email),
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        setState(() => _loading = false);
        if (state is AuthFailure) {
          setState(() => _errorMessage = state.error);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        } else if (state is AuthSuccess) {
          context.read<AppBloc>().add(AppLoggedIn());
        } else if (state is EmailResetSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password reset email sent!')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: CustomColors.blue,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  const SizedBox(height: 24),
                  const CustomLogo(size: 300),

                  const SizedBox(height: 50),
                  // Card with form
                  Card(
                    elevation: 8,
                    color: CustomColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Email field
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: CustomColors.darkblue,
                              ),
                              hintText: l10n.email,
                              filled: true,
                              fillColor: const Color(0xFFEAF6FE),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Password field
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscure,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock,
                                color: CustomColors.darkblue,
                              ),
                              hintText: l10n.password,
                              filled: true,
                              fillColor: const Color(0xFFEAF6FE),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 16,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: CustomColors.darkblue,
                                ),
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: _forgotPassword,
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          if (_errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          const SizedBox(height: 12),
                          // Login button
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 100,
                              child: ElevatedButton(
                                onPressed: _loading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: CustomColors.blue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  elevation: 8,
                                  shadowColor: CustomColors.blue.withOpacity(
                                    0.3,
                                  ),
                                ),
                                child: _loading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'LOGIN',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.1,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Signup button
                          TextButton(
                            onPressed: _loading
                                ? null
                                : () => showEmailSignUpDialog(
                                    context,
                                    context.read<AuthBloc>(),
                                  ),
                            child: Text(
                              'SIGNUP',
                              style: TextStyle(
                                color: CustomColors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: const [
                              Expanded(child: Divider()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text('or login with'),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Social icons row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Google
                              _SocialIconButton(
                                icon: Image.asset(
                                  'assets/icon/google_logo.png',
                                  width: 40,
                                  height: 40,
                                ),
                                color: CustomColors.white,
                                onTap: _loading
                                    ? null
                                    : () => context.read<AuthBloc>().add(
                                        GoogleLoginRequested(),
                                      ),
                              ),
                              const SizedBox(width: 24),
                              // Facebook
                              _SocialIconButton(
                                icon: const Icon(
                                  Icons.facebook,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                color: Color(0xFF1877F3),
                                onTap: _loading
                                    ? null
                                    : () => context.read<AuthBloc>().add(
                                        FacebookLoginRequested(),
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Social icon button widget
class _SocialIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onTap;
  final Color color;
  const _SocialIconButton({
    required this.icon,
    this.onTap,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: icon),
      ),
    );
  }
}
