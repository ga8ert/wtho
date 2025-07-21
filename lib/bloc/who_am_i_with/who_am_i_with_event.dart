import 'package:equatable/equatable.dart';

abstract class WhoAmIWithEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadFriendsEvent extends WhoAmIWithEvent {}

class ToggleFriendEvent extends WhoAmIWithEvent {
  final String uid;
  ToggleFriendEvent(this.uid);
  @override
  List<Object?> get props => [uid];
}

class SaveCompanyEvent extends WhoAmIWithEvent {}

class UpdateSearchQueryEvent extends WhoAmIWithEvent {
  final String query;
  UpdateSearchQueryEvent(this.query);
  @override
  List<Object?> get props => [query];
}
