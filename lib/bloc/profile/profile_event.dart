abstract class ProfileEvent {}

class ProfileLoadRequested extends ProfileEvent {}

class ProfileClearRequested extends ProfileEvent {}

class ProfilePhotoUpdated extends ProfileEvent {
  final String photoUrl;
  ProfilePhotoUpdated(this.photoUrl);
}

class ProfilePhotoPickRequested extends ProfileEvent {}
