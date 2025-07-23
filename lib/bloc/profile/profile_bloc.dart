import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../source/image_utils.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import 'dart:io';
import '../../l10n/app_localizations.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileLoadRequested>(_onLoadRequested);
    on<ProfileClearRequested>(_onClearRequested);
    on<ProfilePhotoUpdated>(_onPhotoUpdated);
    on<ProfilePhotoPickRequested>(_onPhotoPickRequested);
  }

  Future<void> _onLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(ProfileError('No user logged in'));
        return;
      }
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (!doc.exists) {
        emit(ProfileError('User profile not found'));
        return;
      }
      emit(
        ProfileLoaded(
          name: doc['name'] ?? '',
          surname: doc['surname'] ?? '',
          email: doc['email'] ?? '',
          photoUrl: doc.data()?['photoUrl'],
          nickname: doc['nickname'] ?? '',
          about: doc.data() != null && doc.data()!.containsKey('about')
              ? doc['about']
              : '',
          photoUrls: doc.data() != null && doc.data()!.containsKey('photoUrls')
              ? List<String>.from(doc['photoUrls'])
              : [],
        ),
      );
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  void _onClearRequested(
    ProfileClearRequested event,
    Emitter<ProfileState> emit,
  ) {
    emit(ProfileInitial());
  }

  Future<void> _onPhotoUpdated(
    ProfilePhotoUpdated event,
    Emitter<ProfileState> emit,
  ) async {
    // After updating photo, reload profile from Firestore
    add(ProfileLoadRequested());
  }

  Future<void> _onPhotoPickRequested(
    ProfilePhotoPickRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final picker = ImagePicker();
    try {
      emit(ProfilePhotoUploadInProgress());
      final source = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (source == null) {
        emit(ProfileError('Photo not selected.'));
        return;
      }
      final file = File(source.path);
      final bytes = await file.length();
      if (bytes > 8 * 1024 * 1024) {
        emit(ProfilePhotoUploadFailure('File is too large. Max 8 MB.'));
        return;
      }
      final compressedFile = await compressImageFile(
        file,
        quality: 60,
        maxWidth: 800,
        maxHeight: 800,
      );
      if (compressedFile.path.isEmpty || !(await compressedFile.exists())) {
        emit(
          ProfilePhotoUploadFailure('File does not exist or path is empty.'),
        );
        return;
      }
      final compressedXFile = XFile(compressedFile.path);
      final url = await uploadProfilePhoto(compressedXFile);
      if (url != null) {
        add(ProfilePhotoUpdated(url));
      } else {
        emit(ProfilePhotoUploadFailure('Failed to upload photo.'));
      }
    } catch (e) {
      emit(ProfilePhotoUploadFailure('Error: $e'));
    }
  }

  // Helper for uploading photo
  Future<String?> uploadProfilePhoto(XFile file) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return null;
      }
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_photos')
          .child(' ${user.uid}.jpg');
      final uploadTask = ref.putFile(File(file.path));
      final snapshot = await uploadTask;
      if (snapshot.state == TaskState.success) {
        final url = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'photoUrl': url});
        return url;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

class EditProfileBloc extends Bloc<ProfileEvent, EditProfileState> {
  EditProfileBloc() : super(EditProfileState()) {
    on<EditProfileLoadRequested>(_onLoadRequested);
    on<EditProfileFieldChanged>(_onFieldChanged);
    on<EditProfilePhotoAdded>(_onPhotoAdded);
    on<EditProfilePhotoRemoved>(_onPhotoRemoved);
    on<EditProfileSubmitted>(_onSubmitted);
  }

  Future<void> _onLoadRequested(
    EditProfileLoadRequested event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('No user');
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (!doc.exists) throw Exception('Profile not found');
      final data = doc.data()!;
      emit(
        state.copyWith(
          name: data['name'] ?? '',
          surname: data['surname'] ?? '',
          email: data['email'] ?? '',
          nickname: data['nickname'] ?? '',
          age: data['age'] ?? 0,
          about: data != null && data.containsKey('about') ? data['about'] : '',
          photoUrls: data != null && data.containsKey('photoUrls')
              ? List<String>.from(data['photoUrls'])
              : [],
          loading: false,
          error: null,
          success: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void _onFieldChanged(
    EditProfileFieldChanged event,
    Emitter<EditProfileState> emit,
  ) {
    switch (event.field) {
      case 'name':
        emit(state.copyWith(name: event.value));
        break;
      case 'surname':
        emit(state.copyWith(surname: event.value));
        break;
      case 'email':
        emit(state.copyWith(email: event.value));
        break;
      case 'nickname':
        emit(state.copyWith(nickname: event.value));
        break;
      case 'age':
        emit(state.copyWith(age: event.value));
        break;
      case 'about':
        emit(state.copyWith(about: event.value));
        break;
    }
  }

  void _onPhotoAdded(
    EditProfilePhotoAdded event,
    Emitter<EditProfileState> emit,
  ) {
    if (state.photoUrls.length >= 3) return;
    final updated = List<String>.from(state.photoUrls)..add(event.photoPath);
    emit(state.copyWith(photoUrls: updated));
  }

  void _onPhotoRemoved(
    EditProfilePhotoRemoved event,
    Emitter<EditProfileState> emit,
  ) {
    final updated = List<String>.from(state.photoUrls)..removeAt(event.index);
    emit(state.copyWith(photoUrls: updated));
  }

  Future<void> _onSubmitted(
    EditProfileSubmitted event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null, success: false));
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('No user');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
            'name': state.name,
            'surname': state.surname,
            'email': state.email,
            'nickname': state.nickname,
            'age': state.age,
            'about': state.about,
            'photoUrls': state.photoUrls,
          });
      emit(state.copyWith(loading: false, success: true));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
