import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wtho/source/colors.dart';
import 'package:wtho/widgets/email_pass_form.dart';
import 'package:wtho/widgets/facebook_login_btn.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/app/app_bloc.dart';
import '../bloc/app/app_event.dart';
import '../l10n/app_localizations.dart';
import 'custom_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        } else if (state is AuthSuccess) {
          context.read<AppBloc>().add(AppLoggedIn());
        } else if (state is AuthInitial || state is AuthLoggedOut) {
          context.read<AppBloc>().add(AppLoggedOut());
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: CustomColors.blue,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Spacer(),
                          Center(child: CustomLogo()),
                          Spacer(),
                          EmailLoginForm(),
                          // const SizedBox(height: 10),
                          // FacebookLoginBtn(),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black87,
                                minimumSize: const Size.fromHeight(48),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: Image.asset(
                                'assets/icon/google_logo.png',
                                height: 24,
                                width: 24,
                              ),
                              label: Text(
                                AppLocalizations.of(
                                  context,
                                )!.sign_in_with_google,
                              ),
                              onPressed: () {
                                context.read<AuthBloc>().add(
                                  GoogleLoginRequested(),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
