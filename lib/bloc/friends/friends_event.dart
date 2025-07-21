part of 'friends_bloc.dart';

abstract class FriendsEvent {}

class LoadFriends extends FriendsEvent {
  final String userId;
  LoadFriends(this.userId);
}

class SearchFriends extends FriendsEvent {
  final String query;
  SearchFriends(this.query);
}

class SendFriendRequest extends FriendsEvent {
  final String fromUid;
  final String toUid;
  SendFriendRequest({required this.fromUid, required this.toUid});
}

class AcceptFriendRequest extends FriendsEvent {
  final String currentUid;
  final String fromUid;
  AcceptFriendRequest({required this.currentUid, required this.fromUid});
}

class DeclineFriendRequest extends FriendsEvent {
  final String currentUid;
  final String fromUid;
  DeclineFriendRequest({required this.currentUid, required this.fromUid});
}
