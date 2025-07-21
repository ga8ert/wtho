import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<FacebookLoginRequested>(_onFacebookLoginRequested);
    on<EmailLoginRequested>(_onEmailLoginRequested);
    on<EmailSignUpRequested>(_onEmailSignUpRequested);
    on<EmailSignUpRequestedWithNickname>(_onEmailSignUpRequestedWithNickname);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<EmailVerificationCheckRequested>(_onEmailVerificationCheckRequested);
    on<EmailVerificationResendRequested>(_onEmailVerificationResendRequested);
    on<DeleteAccountRequested>(_onDeleteAccountRequested);
    on<GoogleLoginRequested>(_onGoogleLoginRequested);
    on<RecoverPasswordRequested>(_onRecoverPasswordRequested);
  }

  Future<void> _onFacebookLoginRequested(
    FacebookLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final credential = FacebookAuthProvider.credential(
          result.accessToken!.tokenString,
        );
        final userCredential = await FirebaseAuth.instance.signInWithCredential(
          credential,
        );
        emit(AuthSuccess(userCredential.user!));
      } else {
        emit(AuthFailure('Facebook login failed: ${result.message}'));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onEmailLoginRequested(
    EmailLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: event.email,
            password: event.password,
          );
      await userCredential.user?.reload();
      if (!(userCredential.user?.emailVerified ?? false)) {
        await FirebaseAuth.instance.signOut();
        emit(AuthFailure(toString()));
        return;
      }
      emit(AuthSuccess(userCredential.user!));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onEmailSignUpRequested(
    EmailSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: event.email,
            password: event.password,
          );
      emit(AuthSuccess(userCredential.user!));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onEmailSignUpRequestedWithNickname(
    EmailSignUpRequestedWithNickname event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      if (event.nickname.length < 4) {
        emit(SignUpNicknameInvalid());
        return;
      }
      // Check uniqueness
      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('nickname', isEqualTo: event.nickname)
          .get();
      if (query.docs.isNotEmpty) {
        emit(SignUpNicknameTaken());
        return;
      }
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: event.email,
            password: event.password,
          );
      final uid = userCredential.user?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'uid': uid,
          'name': event.name,
          'surname': event.surname,
          'age': event.age,
          'city': event.city,
          'email': event.email,
          'nickname': event.nickname,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      if (userCredential.user != null) {
        await userCredential.user!.sendEmailVerification();
      }
      emit(SignUpSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await FacebookAuth.instance.logOut();
      await FirebaseAuth.instance.signOut();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure('Logout failed: ${e.toString()}'));
    }
  }

  Future<void> _onEmailVerificationCheckRequested(
    EmailVerificationCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(EmailVerificationInProgress());
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.reload();
      final refreshedUser = FirebaseAuth.instance.currentUser;
      if (refreshedUser != null && refreshedUser.emailVerified) {
        emit(EmailVerified());
      } else {
        emit(EmailVerificationError('Email Verification Error: ${toString()}'));
      }
    } catch (e) {
      emit(EmailVerificationError('Email Verification Error: ${e.toString()}'));
    }
  }

  Future<void> _onEmailVerificationResendRequested(
    EmailVerificationResendRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(EmailVerificationInProgress());
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();
      emit(EmailVerificationSent());
    } catch (e) {
      emit(EmailVerificationError('Email Verification Error: ${toString()}'));
    }
  }

  Future<void> _onDeleteAccountRequested(
    DeleteAccountRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(DeleteAccountInProgress());
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .delete();
        await user.delete();
        emit(DeleteAccountSuccess());
      } else {
        emit(DeleteAccountError('User not found'));
      }
    } catch (e) {
      emit(DeleteAccountError('Error deleting account: $e'));
    }
  }

  Future<void> _onGoogleLoginRequested(
    GoogleLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Google Sign-In
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        emit(AuthFailure('Google sign-in cancelled'));
        return;
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final user = userCredential.user;
      if (user == null) {
        emit(AuthFailure('Google sign-in failed'));
        return;
      }
      // Update Firestore user profile if new
      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);
      final docSnapshot = await userDoc.get();
      if (!docSnapshot.exists) {
        await userDoc.set({
          'uid': user.uid,
          'name': user.displayName?.split(' ').first ?? '',
          'surname': user.displayName?.split(' ').skip(1).join(' ') ?? '',
          'email': user.email ?? '',
          'photoUrl': user.photoURL ?? '',
          'nickname': user.email?.split('@').first ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure('Google sign-in error: $e'));
    }
  }

  Future<void> _onRecoverPasswordRequested(
    RecoverPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: event.email);
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(EmailResetSent());
      }
    } catch (e) {
      emit(AuthFailure('Failed to send password reset email: $e'));
    }
  }
}
