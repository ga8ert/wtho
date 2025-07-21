import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/friends/friends_bloc.dart';
import '../bloc/friend_picker_cubit.dart';
import '../l10n/app_localizations.dart';

class FriendPickerScreen extends StatelessWidget {
  final List<String> initiallySelected;
  final String userId;
  const FriendPickerScreen({
    super.key,
    required this.userId,
    this.initiallySelected = const [],
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FriendPickerCubit(initial: initiallySelected),
      child: _FriendPickerBody(userId: userId),
    );
  }
}

class _FriendPickerBody extends StatelessWidget {
  final String userId;
  const _FriendPickerBody({required this.userId});

  @override
  Widget build(BuildContext context) {
    context.read<FriendsBloc>().add(LoadFriends(userId));
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.select_friends)),
      body: BlocBuilder<FriendsBloc, FriendsState>(
        builder: (context, state) {
          if (state is FriendsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FriendsLoaded) {
            final friends = state.friends;
            if (friends.isEmpty) {
              return Center(
                child: Text(AppLocalizations.of(context)!.no_friends),
              );
            }
            return BlocBuilder<FriendPickerCubit, FriendPickerState>(
              builder: (context, pickerState) {
                return ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (context, i) {
                    final friend = friends[i];
                    final uid = friend['uid'] as String?;
                    final nickname =
                        friend['nickname'] ??
                        AppLocalizations.of(context)!.no_name;
                    final selected =
                        uid != null && pickerState.selected.contains(uid);
                    return ListTile(
                      leading:
                          (friend['photoUrl'] != null &&
                              (friend['photoUrl'] as String).isNotEmpty)
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(friend['photoUrl']),
                            )
                          : const CircleAvatar(child: Icon(Icons.person)),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(nickname),
                          if ((friend['name'] ?? '').isNotEmpty ||
                              (friend['surname'] ?? '').isNotEmpty)
                            Text(
                              '${friend['name'] ?? ''} ${friend['surname'] ?? ''}'
                                  .trim(),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                        ],
                      ),
                      trailing: Checkbox(
                        value: selected,
                        onChanged: uid == null
                            ? null
                            : (v) =>
                                  context.read<FriendPickerCubit>().toggle(uid),
                      ),
                    );
                  },
                );
              },
            );
          }
          if (state is FriendsError) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.error_with_message(state.message),
              ),
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: BlocBuilder<FriendPickerCubit, FriendPickerState>(
        builder: (context, pickerState) => FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).pop(pickerState.selected);
          },
          label: Text(AppLocalizations.of(context)!.done),
          icon: const Icon(Icons.check),
        ),
      ),
    );
  }
}
