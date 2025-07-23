import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_profile/user_profile_bloc.dart';
import '../bloc/user_profile/user_profile_event.dart';
import '../bloc/user_profile/user_profile_state.dart';
import '../l10n/app_localizations.dart';
import 'dart:io';

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

class _UserProfileBody extends StatefulWidget {
  final String? currentUserId;
  const _UserProfileBody({this.currentUserId});
  @override
  State<_UserProfileBody> createState() => _UserProfileBodyState();
}

class _UserProfileBodyState extends State<_UserProfileBody> {
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
                    if ((user['about'] ?? '').toString().isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        user['about'],
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    if (user['photoUrls'] != null &&
                        (user['photoUrls'] as List).isNotEmpty) ...[
                      const SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: (user['photoUrls'] as List).length > 3
                            ? 3
                            : (user['photoUrls'] as List).length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 6,
                              crossAxisSpacing: 6,
                              childAspectRatio: 1,
                            ),
                        itemBuilder: (context, i) {
                          final url = (user['photoUrls'] as List)[i];
                          return GestureDetector(
                            onTap: () {
                              if (!mounted) return;
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      _FullScreenImageViewer(imageUrl: url),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: url.toString().startsWith('http')
                                  ? Image.network(url, fit: BoxFit.cover)
                                  : Image.file(File(url), fit: BoxFit.cover),
                            ),
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 24),
                    if (!state.isFriend && user['uid'] != widget.currentUserId)
                      ElevatedButton(
                        onPressed: () {
                          if (!mounted) return;
                          context.read<UserProfileBloc>().add(
                            AddFriend(
                              user['uid'],
                              currentUserId: widget.currentUserId,
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

class _FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;
  const _FullScreenImageViewer({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: imageUrl.startsWith('http')
            ? Image.network(imageUrl, fit: BoxFit.contain)
            : Image.file(File(imageUrl), fit: BoxFit.contain),
      ),
    );
  }
}
