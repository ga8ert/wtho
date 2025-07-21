import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wtho/l10n/app_localizations.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';
import '../source/colors.dart';

void showEmailSignUpDialog(BuildContext context, AuthBloc authBloc) {
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final ageController = TextEditingController();
  final cityController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nicknameController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: CustomColors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        contentPadding: const EdgeInsets.all(24),
        content: BlocProvider.value(
          value: authBloc,
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.registration,
                      style: TextStyle(
                        color: CustomColors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildInput(
                      AppLocalizations.of(context)!.name,
                      nameController,
                    ),
                    const SizedBox(height: 12),
                    _buildInput(
                      AppLocalizations.of(context)!.surname,
                      surnameController,
                    ),
                    const SizedBox(height: 12),
                    _buildInput(
                      AppLocalizations.of(context)!.age,
                      ageController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    _buildInput(
                      AppLocalizations.of(context)!.city,
                      cityController,
                    ),
                    const SizedBox(height: 12),
                    _buildInput(
                      AppLocalizations.of(context)!.nickname,
                      nicknameController,
                    ),
                    const SizedBox(height: 12),
                    _buildInput(
                      AppLocalizations.of(context)!.email,
                      emailController,
                    ),
                    const SizedBox(height: 12),
                    _buildInput(
                      AppLocalizations.of(context)!.password,
                      passwordController,
                      obscureText: true,
                    ),

                    const SizedBox(height: 20),
                    if (state is AuthLoading)
                      const CircularProgressIndicator(color: Colors.white)
                    else
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final name = nameController.text.trim();
                              final surname = surnameController.text.trim();
                              final age =
                                  int.tryParse(ageController.text.trim()) ?? 0;
                              final city = cityController.text.trim();
                              final email = emailController.text.trim();
                              final password = passwordController.text;
                              final nickname = nicknameController.text.trim();
                              context.read<AuthBloc>().add(
                                EmailSignUpRequestedWithNickname(
                                  name: name,
                                  surname: surname,
                                  age: age,
                                  city: city,
                                  email: email,
                                  password: password,
                                  nickname: nickname,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CustomColors.white,
                              foregroundColor: CustomColors.blue,
                            ),
                            child: Text(AppLocalizations.of(context)!.sign_up),
                          ),
                          const SizedBox(height: 12),
                          if (state is SignUpNicknameInvalid)
                            Text(
                              AppLocalizations.of(context)!.nickname_too_short,
                              style: TextStyle(color: Colors.red),
                            ),
                          if (state is SignUpNicknameTaken)
                            Text(
                              AppLocalizations.of(context)!.nickname_taken,
                              style: TextStyle(color: Colors.red),
                            ),
                          if (state is AuthFailure)
                            Text(
                              state.error,
                              style: TextStyle(color: Colors.red),
                            ),
                          if (state is SignUpSuccess)
                            Text(
                              AppLocalizations.of(
                                context,
                              )!.registration_success_check_email,
                              style: TextStyle(color: Colors.green),
                            ),
                        ],
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    },
  );
}

Widget _buildInput(
  String hint,
  TextEditingController controller, {
  bool obscureText = false,
  TextInputType keyboardType = TextInputType.text,
}) {
  return TextField(
    controller: controller,
    obscureText: obscureText,
    keyboardType: keyboardType,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: CustomColors.darkblue,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
