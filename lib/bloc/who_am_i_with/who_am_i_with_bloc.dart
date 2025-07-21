import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'who_am_i_with_event.dart';
import 'who_am_i_with_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WhoAmIWithBloc extends Bloc<WhoAmIWithEvent, WhoAmIWithState> {
  WhoAmIWithBloc() : super(WhoAmIWithLoading()) {
    on<LoadFriendsEvent>(_onLoadFriends);
    on<ToggleFriendEvent>(_onToggleFriend);
    on<SaveCompanyEvent>(_onSaveCompany);
    on<UpdateSearchQueryEvent>(_onUpdateSearchQuery);
  }

  Future<void> _onLoadFriends(
    LoadFriendsEvent event,
    Emitter<WhoAmIWithState> emit,
  ) async {
    emit(WhoAmIWithLoading());
    try {
      final currentUid = FirebaseAuth.instance.currentUser?.uid;
      if (currentUid == null) throw Exception('Not authenticated');
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUid)
          .get();
      final friendsUids = List<String>.from(userDoc.data()?['friends'] ?? []);
      if (friendsUids.isEmpty) {
        emit(WhoAmIWithLoaded(friends: [], selectedFriends: {}, saved: false));
        return;
      }
      final friendsQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', whereIn: friendsUids)
          .get();
      final friends = friendsQuery.docs.map((d) => d.data()).toList();
      final withNow = List<String>.from(userDoc.data()?['withNow'] ?? []);
      final selected = Set<String>.from(withNow)..remove(currentUid);
      emit(
        WhoAmIWithLoaded(
          friends: friends,
          selectedFriends: selected,
          saved: false,
        ),
      );
    } catch (e) {
      emit(WhoAmIWithError('Failed to load friends:  [${e.toString()}]'));
    }
  }

  void _onToggleFriend(ToggleFriendEvent event, Emitter<WhoAmIWithState> emit) {
    if (state is WhoAmIWithLoaded) {
      final loaded = state as WhoAmIWithLoaded;
      final selected = Set<String>.from(loaded.selectedFriends);
      if (selected.contains(event.uid)) {
        selected.remove(event.uid);
      } else {
        selected.add(event.uid);
      }
      emit(loaded.copyWith(selectedFriends: selected));
    }
  }

  Future<void> _onSaveCompany(
    SaveCompanyEvent event,
    Emitter<WhoAmIWithState> emit,
  ) async {
    if (state is WhoAmIWithLoaded) {
      final loaded = state as WhoAmIWithLoaded;
      emit(WhoAmIWithLoading());
      try {
        final currentUid = FirebaseAuth.instance.currentUser?.uid;
        if (currentUid == null) throw Exception('Not authenticated');
        // Зчитати попередню компанію
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUid)
            .get();
        final oldWithNow =
            (userDoc.data()?['withNow'] as List?)?.cast<String>() ?? [];
        // Гарантувати, що організатор не потрапляє у withNow
        final newWithNow = loaded.selectedFriends
            .where((id) => id != currentUid)
            .toList();
        // Видалити моє id у тих, кого видалили
        final removed = oldWithNow
            .where((uid) => !newWithNow.contains(uid))
            .toList();
        for (final uid in removed) {
          final doc = FirebaseFirestore.instance.collection('users').doc(uid);
          await doc.update({
            'withNow': FieldValue.arrayRemove([currentUid]),
          });
        }
        // Додати моє id у тих, кого додали (і залишили)
        for (final uid in newWithNow) {
          final doc = FirebaseFirestore.instance.collection('users').doc(uid);
          await doc.update({
            'withNow': FieldValue.arrayUnion([currentUid]),
          });
        }
        // Якщо видалив усіх — у всіх з oldWithNow видалити моє id
        if (newWithNow.isEmpty) {
          for (final uid in oldWithNow) {
            final doc = FirebaseFirestore.instance.collection('users').doc(uid);
            await doc.update({
              'withNow': FieldValue.arrayRemove([currentUid]),
            });
          }
        }
        // Оновити своє withNow
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUid)
            .update({'withNow': newWithNow});
        emit(loaded.copyWith(saved: true));
      } catch (e) {
        emit(WhoAmIWithError('Failed to save: ${e.toString()}'));
      }
    }
  }

  void _onUpdateSearchQuery(
    UpdateSearchQueryEvent event,
    Emitter<WhoAmIWithState> emit,
  ) {
    if (state is WhoAmIWithLoaded) {
      final loaded = state as WhoAmIWithLoaded;
      emit(loaded.copyWith(searchQuery: event.query));
    }
  }
}
