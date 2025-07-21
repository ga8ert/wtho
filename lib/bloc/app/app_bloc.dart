import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wtho/bloc/app/app_event.dart';
import 'package:wtho/bloc/app/app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  StreamSubscription<User?>? _authSubscription;

  AppBloc() : super(AppInitial()) {
    // Listen to Firebase auth state changes
    _authSubscription = _firebaseAuth.authStateChanges().listen((user) {
      if (user != null && state is! AppAuthenticated) {
        add(AppLoggedIn());
      } else if (user == null && state is! AppUnauthenticated) {
        add(AppLoggedOut());
      }
    });

    on<AppStarted>((event, emit) {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        emit(AppAuthenticated(user));
      } else {
        emit(AppUnauthenticated());
      }
    });

    on<AppLoggedIn>((event, emit) {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        emit(AppAuthenticated(user));
      }
    });

    on<AppLoggedOut>((event, emit) {
      emit(AppUnauthenticated());
    });

    on<AppProfileOpened>((event, emit) {
      emit(AppProfile());
    });

    on<AppBackToHomeRequested>((event, emit) {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        emit(AppAuthenticated(user));
      } else {
        emit(AppUnauthenticated());
      }
    });
  }

  @override
  void onTransition(Transition<AppEvent, AppState> transition) {
    super.onTransition(transition);
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
