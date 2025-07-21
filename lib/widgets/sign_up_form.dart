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
        backgroundColor: CustomColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        contentPadding: const EdgeInsets.all(24),
        content: BlocProvider.value(
          value: authBloc,
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return SizedBox(
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.registration,
                        style: TextStyle(
                          color: CustomColors.blue,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildStyledInput(
                        AppLocalizations.of(context)!.name,
                        nameController,
                      ),
                      const SizedBox(height: 12),
                      _buildStyledInput(
                        AppLocalizations.of(context)!.surname,
                        surnameController,
                      ),
                      const SizedBox(height: 12),
                      _buildStyledInput(
                        AppLocalizations.of(context)!.age,
                        ageController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      _buildStyledInput(
                        AppLocalizations.of(context)!.city,
                        cityController,
                      ),
                      const SizedBox(height: 12),
                      _buildStyledInput(
                        AppLocalizations.of(context)!.nickname,
                        nicknameController,
                      ),
                      const SizedBox(height: 12),
                      _buildStyledInput(
                        AppLocalizations.of(context)!.email,
                        emailController,
                      ),
                      const SizedBox(height: 12),
                      _buildStyledInput(
                        AppLocalizations.of(context)!.password,
                        passwordController,
                        obscureText: true,
                      ),

                      const SizedBox(height: 20),
                      if (state is AuthLoading)
                        const CircularProgressIndicator(color: Colors.blue)
                      else
                        Column(
                          children: [
                            SizedBox(
                              width: 160,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final name = nameController.text.trim();
                                  final surname = surnameController.text.trim();
                                  final age =
                                      int.tryParse(ageController.text.trim()) ??
                                      0;
                                  final city = cityController.text.trim();
                                  final email = emailController.text.trim();
                                  final password = passwordController.text;
                                  final nickname = nicknameController.text
                                      .trim();
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
                                  backgroundColor: CustomColors.blue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  elevation: 6,
                                  shadowColor: CustomColors.blue.withOpacity(
                                    0.2,
                                  ),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.sign_up,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (state is SignUpNicknameInvalid)
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.nickname_too_short,
                                style: const TextStyle(color: Colors.red),
                              ),
                            if (state is SignUpNicknameTaken)
                              Text(
                                AppLocalizations.of(context)!.nickname_taken,
                                style: const TextStyle(color: Colors.red),
                              ),
                            if (state is AuthFailure)
                              Text(
                                state.error,
                                style: const TextStyle(color: Colors.red),
                              ),
                            if (state is SignUpSuccess)
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.registration_success_check_email,
                                style: const TextStyle(color: Colors.green),
                              ),
                          ],
                        ),
                    ],
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

Widget _buildStyledInput(
  String hint,
  TextEditingController controller, {
  bool obscureText = false,
  TextInputType keyboardType = TextInputType.text,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 0),
    child: TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(
        color: CustomColors.darkblue,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: CustomColors.darkblue.withOpacity(0.5),
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: const Color(0xFFEAF6FE),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 18,
        ),
      ),
    ),
  );
}
