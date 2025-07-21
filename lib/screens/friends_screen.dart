import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/friends/friends_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../bloc/profile/profile_state.dart';
import '../l10n/app_localizations.dart';
import '../screens/user_profile_screen.dart';

class FriendsScreen extends StatefulWidget {
  final String userId;
  const FriendsScreen({super.key, required this.userId});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<FriendsBloc>().add(LoadFriends(widget.userId));
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      context.read<FriendsBloc>().add(SearchFriends(query));
    } else {
      context.read<FriendsBloc>().add(LoadFriends(widget.userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.search_by_nickname,
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) => _onSearchChanged(),
          ),
        ),
        // --- FRIEND REQUESTS ---
        BlocBuilder<FriendsBloc, FriendsState>(
          builder: (context, state) {
            if (state is FriendsLoaded && state.friendRequests.isNotEmpty) {
              return Column(
                children: [
                  const Divider(),
                  ...state.friendRequests.map(
                    (fromUser) => ListTile(
                      leading:
                          (fromUser['photoUrl'] != null &&
                              (fromUser['photoUrl'] as String).isNotEmpty)
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(
                                fromUser['photoUrl'],
                              ),
                            )
                          : const CircleAvatar(child: Icon(Icons.person_add)),
                      title: Text(fromUser['nickname'] ?? ''),
                      subtitle: Text(fromUser['name'] ?? ''),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              context.read<FriendsBloc>().add(
                                AcceptFriendRequest(
                                  currentUid: user!.uid,
                                  fromUid: fromUser['uid'],
                                ),
                              );
                            },
                            child: Text(AppLocalizations.of(context)!.add),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () {
                              context.read<FriendsBloc>().add(
                                DeclineFriendRequest(
                                  currentUid: user!.uid,
                                  fromUid: fromUser['uid'],
                                ),
                              );
                            },
                            child: Text(AppLocalizations.of(context)!.decline),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
        // --- END FRIEND REQUESTS ---
        Expanded(
          child: BlocBuilder<FriendsBloc, FriendsState>(
            builder: (context, state) {
              if (state is FriendsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is FriendsLoaded) {
                if (state.friends.isEmpty) {
                  return Center(
                    child: Text(AppLocalizations.of(context)!.no_friends_yet),
                  );
                }
                return ListView.builder(
                  itemCount: state.friends.length,
                  itemBuilder: (context, index) {
                    final friend = state.friends[index];
                    return ListTile(
                      leading:
                          (friend['photoUrl'] != null &&
                              (friend['photoUrl'] as String).isNotEmpty)
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(friend['photoUrl']),
                            )
                          : const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(friend['nickname'] ?? ''),
                      subtitle: Text(friend['name'] ?? ''),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => UserProfileScreen(
                              userId: friend['uid'],
                              currentUserId: user?.uid,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              } else if (state is FriendsSearchResults) {
                if (state.results.isEmpty) {
                  return Center(
                    child: Text(AppLocalizations.of(context)!.no_users_found),
                  );
                }
                return ListView.builder(
                  itemCount: state.results.length,
                  itemBuilder: (context, index) {
                    final userMap = state.results[index];
                    final isSelf = userMap['uid'] == user?.uid;
                    final isAlreadyFriend = false;
                    // Додано: перевірка outgoing friend request
                    final hasOutgoingRequest =
                        (userMap['friendRequests'] as List?)?.contains(
                          user?.uid,
                        ) ??
                        false;
                    return ListTile(
                      leading:
                          (userMap['photoUrl'] != null &&
                              (userMap['photoUrl'] as String).isNotEmpty)
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(
                                userMap['photoUrl'],
                              ),
                            )
                          : const CircleAvatar(
                              child: Icon(Icons.person_outline),
                            ),
                      title: Text(userMap['nickname'] ?? ''),
                      subtitle: Text(userMap['name'] ?? ''),
                      trailing: isSelf || isAlreadyFriend
                          ? null
                          : hasOutgoingRequest
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Text(
                                AppLocalizations.of(
                                  context,
                                )!.friend_request_sent,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                context.read<FriendsBloc>().add(
                                  SendFriendRequest(
                                    fromUid: user!.uid,
                                    toUid: userMap['uid'],
                                  ),
                                );
                              },
                              child: Text(AppLocalizations.of(context)!.add),
                            ),
                    );
                  },
                );
              } else if (state is FriendsError) {
                return Center(
                  child: Text(
                    AppLocalizations.of(
                      context,
                    )!.error_with_message(state.message),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }
}
