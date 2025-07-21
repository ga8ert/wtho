import 'package:equatable/equatable.dart';

abstract class WhoAmIWithState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WhoAmIWithLoading extends WhoAmIWithState {}

class WhoAmIWithLoaded extends WhoAmIWithState {
  final List<Map<String, dynamic>> friends;
  final Set<String> selectedFriends;
  final bool saved;
  final String searchQuery;
  WhoAmIWithLoaded({
    required this.friends,
    required this.selectedFriends,
    required this.saved,
    this.searchQuery = '',
  });

  WhoAmIWithLoaded copyWith({
    List<Map<String, dynamic>>? friends,
    Set<String>? selectedFriends,
    bool? saved,
    String? searchQuery,
  }) {
    return WhoAmIWithLoaded(
      friends: friends ?? this.friends,
      selectedFriends: selectedFriends ?? this.selectedFriends,
      saved: saved ?? this.saved,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [friends, selectedFriends, saved, searchQuery];
}

class WhoAmIWithError extends WhoAmIWithState {
  final String message;
  WhoAmIWithError(this.message);
  @override
  List<Object?> get props => [message];
}
