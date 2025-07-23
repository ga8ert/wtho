abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {
  final String? about;
  final List<String>? photoUrls;
  ProfileLoading({this.about, this.photoUrls});
}

class ProfileLoaded extends ProfileState {
  final String name;
  final String surname;
  final String email;
  final String? photoUrl;
  final String nickname;
  final String? about;
  final List<String>? photoUrls;
  ProfileLoaded({
    required this.name,
    required this.surname,
    required this.email,
    this.photoUrl,
    required this.nickname,
    this.about,
    this.photoUrls,
  });
  @override
  List<Object?> get props => [
    name,
    surname,
    email,
    photoUrl,
    nickname,
    about,
    photoUrls,
  ];
}

class ProfileError extends ProfileState {
  final String message;
  final String? about;
  final List<String>? photoUrls;
  ProfileError(this.message, {this.about, this.photoUrls});
  @override
  List<Object?> get props => [message, about, photoUrls];
}

class ProfilePhotoUploadInProgress extends ProfileState {}

class ProfilePhotoUploadFailure extends ProfileState {
  final String message;
  ProfilePhotoUploadFailure(this.message);
}

class EditProfileState extends ProfileState {
  final String name;
  final String surname;
  final String email;
  final String nickname;
  final int age;
  final String about;
  final List<String> photoUrls;
  final bool loading;
  final String? error;
  final bool success;
  EditProfileState({
    this.name = '',
    this.surname = '',
    this.email = '',
    this.nickname = '',
    this.age = 0,
    this.about = '',
    this.photoUrls = const [],
    this.loading = false,
    this.error,
    this.success = false,
  });
  EditProfileState copyWith({
    String? name,
    String? surname,
    String? email,
    String? nickname,
    int? age,
    String? about,
    List<String>? photoUrls,
    bool? loading,
    String? error,
    bool? success,
  }) {
    return EditProfileState(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      age: age ?? this.age,
      about: about ?? this.about,
      photoUrls: photoUrls ?? this.photoUrls,
      loading: loading ?? this.loading,
      error: error,
      success: success ?? this.success,
    );
  }

  @override
  List<Object?> get props => [
    name,
    surname,
    email,
    nickname,
    age,
    about,
    photoUrls,
    loading,
    error,
    success,
  ];
}
