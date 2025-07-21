import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_profile/user_profile_bloc.dart';
import '../bloc/user_profile/user_profile_event.dart';
import '../bloc/user_profile/user_profile_state.dart';
import '../l10n/app_localizations.dart';

class UserProfileScreen extends StatelessWidget {
  final String userId;
  final String? currentUserId;
  const UserProfileScreen({
    super.key,
    required this.userId,
    this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          UserProfileBloc()
            ..add(LoadUserProfile(userId, currentUserId: currentUserId)),
      child: _UserProfileBody(currentUserId: currentUserId),
    );
  }
}

class _UserProfileBody extends StatelessWidget {
  final String? currentUserId;
  const _UserProfileBody({this.currentUserId});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, state) {
        if (state is UserProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is UserProfileLoaded) {
          final user = state.user;
          return Scaffold(
            appBar: AppBar(title: Text(user['nickname'] ?? '')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 96,
                      backgroundImage: (user['photoUrl'] ?? '').isNotEmpty
                          ? NetworkImage(user['photoUrl'])
                          : null,
                      child: (user['photoUrl'] ?? '').isEmpty
                          ? Icon(Icons.person, size: 96)
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      (user['name'] ?? '') + ' ' + (user['surname'] ?? ''),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '@${user['nickname'] ?? ''}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${AppLocalizations.of(context)!.age}: ${user['age'] ?? '-'}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    if (!state.isFriend && user['uid'] != currentUserId)
                      ElevatedButton(
                        onPressed: () {
                          context.read<UserProfileBloc>().add(
                            AddFriend(
                              user['uid'],
                              currentUserId: currentUserId,
                            ),
                          );
                        },
                        child: Text(AppLocalizations.of(context)!.add_users),
                      ),
                    if (state.isFriend)
                      Text(
                        AppLocalizations.of(context)!.friends,
                        style: const TextStyle(color: Colors.green),
                      ),
                  ],
                ),
              ),
            ),
          );
        }
        if (state is UserProfileError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
