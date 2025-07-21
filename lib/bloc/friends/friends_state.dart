part of 'friends_bloc.dart';

abstract class FriendsState {}

class FriendsInitial extends FriendsState {}

class FriendsLoading extends FriendsState {}

class FriendsLoaded extends FriendsState {
  final List<Map<String, dynamic>> friends;
  final List<Map<String, dynamic>> friendRequests;
  FriendsLoaded(this.friends, this.friendRequests);
}

class FriendsSearchResults extends FriendsState {
  final List<Map<String, dynamic>> results;
  FriendsSearchResults(this.results);
}

class FriendsError extends FriendsState {
  final String message;
  FriendsError(this.message);
}

class FriendRequestSent extends FriendsState {}

class FriendRequestHandled extends FriendsState {}
