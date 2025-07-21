import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;
  AuthSuccess(this.user);
}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}

class AuthLoggedOut extends AuthState {}

class EmailVerificationInProgress extends AuthState {}

class EmailVerificationSent extends AuthState {}

class EmailVerificationError extends AuthState {
  final String message;
  EmailVerificationError(this.message);
}

class EmailVerified extends AuthState {}

class SignUpNicknameTaken extends AuthState {}

class SignUpNicknameInvalid extends AuthState {}

class SignUpSuccess extends AuthState {}

class DeleteAccountInProgress extends AuthState {}

class DeleteAccountSuccess extends AuthState {}

class DeleteAccountError extends AuthState {
  final String message;
  DeleteAccountError(this.message);
}
