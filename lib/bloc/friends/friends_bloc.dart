import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'friends_event.dart';
part 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  FriendsBloc() : super(FriendsInitial()) {
    on<LoadFriends>(_onLoadFriends);
    on<SearchFriends>(_onSearchFriends);
    on<SendFriendRequest>(_onSendFriendRequest);
    on<AcceptFriendRequest>(_onAcceptFriendRequest);
    on<DeclineFriendRequest>(_onDeclineFriendRequest);
  }

  Future<void> _onLoadFriends(
    LoadFriends event,
    Emitter<FriendsState> emit,
  ) async {
    emit(FriendsLoading());
    try {
      final userId = event.userId;
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      final List<dynamic> friends = doc.data()?['friends'] ?? [];
      final List<dynamic> friendRequestsUids =
          doc.data()?['friendRequests'] ?? [];
      List<Map<String, dynamic>> friendsList = [];
      List<Map<String, dynamic>> friendRequestsList = [];
      if (friends.isNotEmpty) {
        final friendsDocs = await FirebaseFirestore.instance
            .collection('users')
            .where('uid', whereIn: friends)
            .get();
        friendsList = friendsDocs.docs.map((d) => d.data()).toList();
      }
      if (friendRequestsUids.isNotEmpty) {
        final requestsDocs = await FirebaseFirestore.instance
            .collection('users')
            .where('uid', whereIn: friendRequestsUids)
            .get();
        friendRequestsList = requestsDocs.docs.map((d) => d.data()).toList();
      }
      emit(FriendsLoaded(friendsList, friendRequestsList));
    } catch (e) {
      emit(FriendsError(e.toString()));
    }
  }

  Future<void> _onSearchFriends(
    SearchFriends event,
    Emitter<FriendsState> emit,
  ) async {
    emit(FriendsLoading());
    try {
      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('nickname', isEqualTo: event.query)
          .get();
      final results = query.docs.map((d) => d.data()).toList();
      emit(FriendsSearchResults(results));
    } catch (e) {
      emit(FriendsError(e.toString()));
    }
  }

  Future<void> _onSendFriendRequest(
    SendFriendRequest event,
    Emitter<FriendsState> emit,
  ) async {
    try {
      // event.fromUid, event.toUid
      final toUserRef = FirebaseFirestore.instance
          .collection('users')
          .doc(event.toUid);
      await toUserRef.update({
        'friendRequests': FieldValue.arrayUnion([event.fromUid]),
      });
      emit(FriendRequestSent());
    } catch (e) {
      emit(FriendsError('Failed to send request: $e'));
    }
  }

  Future<void> _onAcceptFriendRequest(
    AcceptFriendRequest event,
    Emitter<FriendsState> emit,
  ) async {
    try {
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(event.currentUid);
      final fromUserRef = FirebaseFirestore.instance
          .collection('users')
          .doc(event.fromUid);
      // Add each other to friends
      await userRef.update({
        'friends': FieldValue.arrayUnion([event.fromUid]),
        'friendRequests': FieldValue.arrayRemove([event.fromUid]),
      });
      await fromUserRef.update({
        'friends': FieldValue.arrayUnion([event.currentUid]),
      });
      emit(FriendRequestHandled());
      add(LoadFriends(event.currentUid));
    } catch (e) {
      emit(FriendsError('Failed to accept request: $e'));
    }
  }

  Future<void> _onDeclineFriendRequest(
    DeclineFriendRequest event,
    Emitter<FriendsState> emit,
  ) async {
    try {
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(event.currentUid);
      await userRef.update({
        'friendRequests': FieldValue.arrayRemove([event.fromUid]),
      });
      emit(FriendRequestHandled());
      add(LoadFriends(event.currentUid));
    } catch (e) {
      emit(FriendsError('Failed to decline request: $e'));
    }
  }
}
