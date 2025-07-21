abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String name;
  final String surname;
  final String email;
  final String? photoUrl;
  final String nickname;
  ProfileLoaded({
    required this.name,
    required this.surname,
    required this.email,
    this.photoUrl,
    required this.nickname,
  });
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfilePhotoUploadInProgress extends ProfileState {}

class ProfilePhotoUploadFailure extends ProfileState {
  final String message;
  ProfilePhotoUploadFailure(this.message);
}
