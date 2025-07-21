import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wtho/l10n/app_localizations.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';
import '../source/colors.dart';

class FacebookLoginBtn extends StatefulWidget {
  const FacebookLoginBtn({super.key});

  @override
  State<FacebookLoginBtn> createState() => _FacebookLoginBtnState();
}

class _FacebookLoginBtnState extends State<FacebookLoginBtn> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Align(
          child: state is AuthLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.blue,
                    foregroundColor: CustomColors.darkblue,
                    side: BorderSide(color: CustomColors.darkblue, width: 0.5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () {
                    context.read<AuthBloc>().add(FacebookLoginRequested());
                  },
                  child: Text(
                    AppLocalizations.of(context)!.sign_in_with_facebook,
                    style: TextStyle(
                      color: CustomColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        );
      },
    );
  }
}
