import 'package:firebase_auth/firebase_auth.dart';

abstract class AppState {}

class AppInitial extends AppState {}

class AppAuthenticated extends AppState {
  final User user;
  AppAuthenticated(this.user) {}
}

class AppUnauthenticated extends AppState {}

class AppProfile extends AppState {}
