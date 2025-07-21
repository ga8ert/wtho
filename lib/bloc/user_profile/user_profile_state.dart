import 'package:equatable/equatable.dart';

abstract class UserProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final Map<String, dynamic> user;
  final bool isFriend;
  UserProfileLoaded({required this.user, required this.isFriend});
  @override
  List<Object?> get props => [user, isFriend];
}

class UserProfileError extends UserProfileState {
  final String message;
  UserProfileError({required this.message});
  @override
  List<Object?> get props => [message];
}
