import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_profile_event.dart';
import 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc() : super(UserProfileLoading()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<AddFriend>(_onAddFriend);
  }

  Future<void> _onLoadUserProfile(
    LoadUserProfile event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfileLoading());
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(event.userId)
          .get();
      final user = userDoc.data();
      if (user == null) throw Exception('User not found');
      user['uid'] = event.userId;
      user['about'] = user.containsKey('about') ? user['about'] : '';
      user['photoUrls'] = user.containsKey('photoUrls')
          ? user['photoUrls']
          : [];
      final currentUid = event.currentUserId;
      bool isFriend = false;
      if (currentUid != null) {
        final currentUserDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUid)
            .get();
        final friends =
            (currentUserDoc.data()?['friends'] as List?)?.cast<String>() ?? [];
        isFriend = friends.contains(event.userId);
      }
      emit(UserProfileLoaded(user: user, isFriend: isFriend));
    } catch (e) {
      emit(UserProfileError(message: e.toString()));
    }
  }

  Future<void> _onAddFriend(
    AddFriend event,
    Emitter<UserProfileState> emit,
  ) async {
    try {
      final currentUid = event.currentUserId;
      if (currentUid == null) throw Exception('Not logged in');
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUid);
      await userRef.update({
        'friends': FieldValue.arrayUnion([event.friendUid]),
      });
      add(LoadUserProfile(event.friendUid, currentUserId: currentUid));
    } catch (e) {
      emit(UserProfileError(message: e.toString()));
    }
  }
}
