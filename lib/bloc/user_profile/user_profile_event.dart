import 'package:equatable/equatable.dart';

abstract class UserProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUserProfile extends UserProfileEvent {
  final String userId;
  final String? currentUserId;
  LoadUserProfile(this.userId, {this.currentUserId});
  @override
  List<Object?> get props => [userId, currentUserId];
}

class AddFriend extends UserProfileEvent {
  final String friendUid;
  final String? currentUserId;
  AddFriend(this.friendUid, {this.currentUserId});
  @override
  List<Object?> get props => [friendUid, currentUserId];
}
