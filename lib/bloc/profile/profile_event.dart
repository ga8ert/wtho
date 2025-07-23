abstract class ProfileEvent {}

class ProfileLoadRequested extends ProfileEvent {}

class ProfileClearRequested extends ProfileEvent {}

class ProfilePhotoUpdated extends ProfileEvent {
  final String photoUrl;
  ProfilePhotoUpdated(this.photoUrl);
}

class ProfilePhotoPickRequested extends ProfileEvent {}

class EditProfileLoadRequested extends ProfileEvent {}

class EditProfileFieldChanged extends ProfileEvent {
  final String field;
  final dynamic value;
  EditProfileFieldChanged(this.field, this.value);
}

class EditProfilePhotoAdded extends ProfileEvent {
  final String photoPath;
  EditProfilePhotoAdded(this.photoPath);
}

class EditProfilePhotoRemoved extends ProfileEvent {
  final int index;
  EditProfilePhotoRemoved(this.index);
}

class EditProfileSubmitted extends ProfileEvent {}
