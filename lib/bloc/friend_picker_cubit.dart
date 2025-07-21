import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class FriendPickerState extends Equatable {
  final List<String> selected;
  final bool loading;
  final String? error;

  const FriendPickerState({
    this.selected = const [],
    this.loading = false,
    this.error,
  });

  FriendPickerState copyWith({
    List<String>? selected,
    bool? loading,
    String? error,
  }) {
    return FriendPickerState(
      selected: selected ?? this.selected,
      loading: loading ?? this.loading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [selected, loading, error];
}

class FriendPickerCubit extends Cubit<FriendPickerState> {
  FriendPickerCubit({List<String>? initial})
    : super(FriendPickerState(selected: initial ?? []));

  void toggle(String uid) {
    final sel = List<String>.from(state.selected);
    if (sel.contains(uid)) {
      sel.remove(uid);
    } else {
      sel.add(uid);
    }
    emit(state.copyWith(selected: sel));
  }

  void setInitial(List<String> initial) {
    emit(state.copyWith(selected: initial));
  }

  void clear() {
    emit(state.copyWith(selected: []));
  }
}
