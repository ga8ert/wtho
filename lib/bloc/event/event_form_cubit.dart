import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../source/image_utils.dart';

class EventFormState extends Equatable {
  final String title;
  final String place;
  final String type;
  final double? latitude;
  final double? longitude;
  final String description;
  final List<String> userIds;
  final DateTime? startDateTime;
  final DateTime? endDateTime;
  final bool submitting;
  final String? error;
  final bool success;
  final List<File> selectedPhotos;
  final List<String> photoUrls;
  final bool friendPickerOpened;

  const EventFormState({
    this.title = '',
    this.place = '',
    this.type = '',
    this.latitude,
    this.longitude,
    this.description = '',
    this.userIds = const [],
    this.startDateTime,
    this.endDateTime,
    this.submitting = false,
    this.error,
    this.success = false,
    this.selectedPhotos = const [],
    this.photoUrls = const [],
    this.friendPickerOpened = false,
  });

  EventFormState copyWith({
    String? title,
    String? place,
    String? type,
    double? latitude,
    double? longitude,
    String? description,
    List<String>? userIds,
    DateTime? startDateTime,
    DateTime? endDateTime,
    bool? submitting,
    String? error,
    bool? success,
    List<File>? selectedPhotos,
    List<String>? photoUrls,
    bool? friendPickerOpened,
  }) {
    return EventFormState(
      title: title ?? this.title,
      place: place ?? this.place,
      type: type ?? this.type,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      description: description ?? this.description,
      userIds: userIds ?? this.userIds,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      submitting: submitting ?? this.submitting,
      error: error,
      success: success ?? false,
      selectedPhotos: selectedPhotos ?? this.selectedPhotos,
      photoUrls: photoUrls ?? this.photoUrls,
      friendPickerOpened: friendPickerOpened ?? this.friendPickerOpened,
    );
  }

  @override
  List<Object?> get props => [
    title,
    place,
    type,
    latitude,
    longitude,
    description,
    userIds,
    startDateTime,
    endDateTime,
    submitting,
    error,
    success,
    selectedPhotos,
    photoUrls,
    friendPickerOpened,
  ];
}

class EventFormCubit extends Cubit<EventFormState> {
  EventFormCubit() : super(const EventFormState());

  final ImagePicker _picker = ImagePicker();

  void setTitle(String v) => emit(state.copyWith(title: v, error: null));
  void setPlace(String v) => emit(state.copyWith(place: v, error: null));
  void setType(String v) => emit(state.copyWith(type: v, error: null));
  void setLocation(double lat, double lng) =>
      emit(state.copyWith(latitude: lat, longitude: lng, error: null));
  void setLatLng(double lat, double lng) => setLocation(lat, lng);
  void setDescription(String v) =>
      emit(state.copyWith(description: v, error: null));
  void setUserIds(List<String> ids) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    if (ids.isNotEmpty && ids.any((id) => id != uid)) {
      emit(state.copyWith(userIds: ids, error: null, friendPickerOpened: true));
    }
    // Якщо ids порожній або містить лише організатора — нічого не робимо
  }

  void setStartDateTime(DateTime dt) =>
      emit(state.copyWith(startDateTime: dt, error: null));
  void setEndDateTime(DateTime dt) =>
      emit(state.copyWith(endDateTime: dt, error: null));

  Future<void> pickPhoto({required ImageSource source}) async {
    if (state.selectedPhotos.length >= 3) return;
    final picked = await _picker.pickImage(source: source, imageQuality: 80);
    if (picked != null) {
      final compressed = await compressImageFile(
        File(picked.path),
        maxWidth: 800,
        maxHeight: 800,
        quality: 70,
      );
      final updated = List<File>.from(state.selectedPhotos)..add(compressed);
      emit(state.copyWith(selectedPhotos: updated));
    }
  }

  void removePhotoAt(int index) {
    final updated = List<File>.from(state.selectedPhotos)..removeAt(index);
    emit(state.copyWith(selectedPhotos: updated));
  }

  void clearPhotos() {
    emit(state.copyWith(selectedPhotos: []));
  }

  Future<List<String>> uploadPhotos(String eventId) async {
    final urls = <String>[];
    for (int i = 0; i < state.selectedPhotos.length; i++) {
      final file = state.selectedPhotos[i];
      final ref = FirebaseStorage.instance.ref().child(
        'event_photos/$eventId/photo_$i.jpg',
      );
      final uploadTask = await ref.putFile(file);
      if (uploadTask.state == TaskState.success) {
        final url = await ref.getDownloadURL();
        urls.add(url);
      }
    }
    return urls;
  }

  Future<void> submit() async {
    emit(state.copyWith(submitting: true, error: null, success: false));
    try {
      final user = FirebaseAuth.instance.currentUser;
      final authorId = user?.uid ?? '';
      List<String> userIds = List<String>.from(state.userIds);
      // Якщо userIds == 1 (тільки організатор) і friendPickerOpened == false, підставити withNow
      if (userIds.length == 1 &&
          !state.friendPickerOpened &&
          authorId.isNotEmpty) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(authorId)
            .get();
        final withNow =
            (userDoc.data()?['withNow'] as List?)?.cast<String>() ?? [];
        userIds = [authorId, ...withNow.where((id) => id != authorId)];
      }
      if (userIds.isEmpty && authorId.isNotEmpty) {
        userIds = [authorId];
      }
      final docRef = await FirebaseFirestore.instance.collection('events').add({
        'authorId': authorId,
        'title': state.title,
        'place': state.place,
        'type': state.type,
        'latitude': state.latitude,
        'longitude': state.longitude,
        'description': state.description,
        'userIds': userIds,
        'startDateTime': state.startDateTime?.toIso8601String(),
        'endDateTime': state.endDateTime?.toIso8601String(),
        'createdAt': DateTime.now().toIso8601String(),
      });
      // --- Створити чат для івенту ---
      final allUserIds = {...userIds, authorId}.toList();
      await FirebaseFirestore.instance.collection('chats').doc(docRef.id).set({
        'eventId': docRef.id,
        'eventTitle': state.title,
        'userIds': allUserIds,
        'authorId': authorId,
        'eventEndTime': state.endDateTime?.toIso8601String(),
        'createdAt': DateTime.now().toIso8601String(),
      });
      List<String> photoUrls = [];
      if (state.selectedPhotos.isNotEmpty) {
        photoUrls = await uploadPhotos(docRef.id);
        await docRef.update({'photos': photoUrls});
      }
      emit(
        state.copyWith(submitting: false, success: true, photoUrls: photoUrls),
      );
    } catch (e) {
      emit(state.copyWith(submitting: false, error: e.toString()));
    }
  }
}
