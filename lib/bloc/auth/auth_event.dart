abstract class AuthEvent {}

class FacebookLoginRequested extends AuthEvent {}

class EmailLoginRequested extends AuthEvent {
  final String email;
  final String password;
  EmailLoginRequested({required this.email, required this.password});
}

class EmailSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  EmailSignUpRequested({required this.email, required this.password});
}

class EmailSignUpRequestedWithNickname extends AuthEvent {
  final String name;
  final String surname;
  final int age;
  final String city;
  final String email;
  final String password;
  final String nickname;
  EmailSignUpRequestedWithNickname({
    required this.name,
    required this.surname,
    required this.age,
    required this.city,
    required this.email,
    required this.password,
    required this.nickname,
  });
}

class AuthLogoutRequested extends AuthEvent {}

class EmailVerificationCheckRequested extends AuthEvent {}

class EmailVerificationResendRequested extends AuthEvent {}

class DeleteAccountRequested extends AuthEvent {}

class GoogleLoginRequested extends AuthEvent {}
