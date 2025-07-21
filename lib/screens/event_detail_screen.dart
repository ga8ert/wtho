import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wtho/l10n/app_localizations.dart';
import '../bloc/event_detail_cubit.dart';
import '../widgets/event_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/chat_room_screen.dart';
import '../screens/user_profile_screen.dart';

class EventDetailScreen extends StatelessWidget {
  final Map<String, dynamic> event;
  final double? userLat;
  final double? userLng;

  const EventDetailScreen({
    super.key,
    required this.event,
    this.userLat,
    this.userLng,
  });

  @override
  Widget build(BuildContext context) {
    final String title = event['title'] ?? '';
    final String authorId = event['authorId'] ?? '';
    return BlocProvider(
      create: (_) =>
          EventDetailCubit(eventTitle: title, authorId: authorId)
            ..fetchEventDetails(),
      child: _EventDetailBody(),
    );
  }
}

class _EventDetailBody extends StatelessWidget {
  const _EventDetailBody();

  @override
  Widget build(BuildContext context) {
    final String? currentUid = FirebaseAuth.instance.currentUser?.uid;
    return BlocConsumer<EventDetailCubit, EventDetailState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
          );
        }
        if (state.joinRequestSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.join_request_sent),
            ),
          );
        }
        if (state.acceptSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.join_request_sent),
            ),
          );
        }
        if (state.declineSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.join_requests),
            ),
          );
        }
      },
      builder: (context, state) {
        final isAuthor =
            currentUid != null && state.authorProfile?.uid == currentUid;
        final isFriend =
            currentUid != null &&
            state.participantProfiles.any((p) => p.uid == currentUid);
        final List<String> friendsIds = state.userIds
            .where((id) => id != state.authorProfile?.uid)
            .toList();
        final friends = state.participantProfiles
            .where((p) => p.uid != state.authorProfile?.uid)
            .toList();
        final hasSentRequest = state.joinRequests.any(
          (req) => (req['uids'] as List?)?.contains(currentUid) ?? false,
        );
        return Scaffold(
          appBar: AppBar(title: Text(state.authorProfile?.nickname ?? '')),
          body: state.loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.eventTitle != null &&
                          state.eventTitle!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            state.eventTitle!,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      if (state.eventType != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ..._getEventTypeEmojis(
                                  state.eventType!,
                                  context,
                                ).map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: Text(
                                      e,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.getField(state.eventType!),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            if (eventStartEnd(state) != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 6.0,
                                  left: 2.0,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.schedule,
                                      size: 16,
                                      color: Colors.deepPurple,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      eventStartEnd(state)!,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      if (state.description != null &&
                          state.description!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            state.description!,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      if (state.lat != null && state.lng != null)
                        SizedBox(
                          height: 200,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(state.lat!, state.lng!),
                              zoom: 14,
                            ),
                            markers: {
                              Marker(
                                markerId: const MarkerId('event'),
                                position: LatLng(state.lat!, state.lng!),
                              ),
                            },
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: false,
                          ),
                        ),
                      const SizedBox(height: 8),
                      if (state.authorProfile != null)
                        GestureDetector(
                          onTap: () {
                            final currentUserId =
                                FirebaseAuth.instance.currentUser?.uid;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => UserProfileScreen(
                                  userId: state.authorProfile!.uid,
                                  currentUserId: currentUserId,
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            leading: state.authorProfile!.photoUrl != null
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      state.authorProfile!.photoUrl!,
                                    ),
                                  )
                                : const Icon(Icons.person),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    state.authorProfile!.name +
                                        ' ' +
                                        state.authorProfile!.surname,
                                  ),
                                ),
                                Text(
                                  AppLocalizations.of(context)!.originator,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(state.authorProfile!.nickname),
                          ),
                        ),
                      const SizedBox(height: 16),
                      if (!isAuthor && !isFriend && !hasSentRequest)
                        ElevatedButton(
                          onPressed: state.loading
                              ? null
                              : () => context
                                    .read<EventDetailCubit>()
                                    .sendJoinRequest(),
                          child: Text(
                            AppLocalizations.of(
                              context,
                            )!.invite_to_join_the_event,
                          ),
                        ),
                      if (!isAuthor && !isFriend && hasSentRequest)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            AppLocalizations.of(context)!.join_request_sent,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w300,

                              fontSize: 14,
                            ),
                          ),
                        ),
                      if (isAuthor && state.joinRequestProfiles.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.join_requests,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ...List.generate(state.joinRequestProfiles.length, (
                              groupIdx,
                            ) {
                              final group = state.joinRequestProfiles[groupIdx];
                              if (group.isEmpty) return SizedBox.shrink();
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                child: ListTile(
                                  leading: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: group
                                        .take(3)
                                        .map(
                                          (profile) => Padding(
                                            padding: const EdgeInsets.only(
                                              right: 2,
                                            ),
                                            child: profile.photoUrl != null
                                                ? CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                          profile.photoUrl!,
                                                        ),
                                                    radius: 16,
                                                  )
                                                : const CircleAvatar(
                                                    child: Icon(Icons.person),
                                                    radius: 16,
                                                  ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                  title: Text(
                                    group.map((p) => p.nickname).join(', '),
                                  ),
                                  subtitle: Text(
                                    group
                                        .map((p) => p.name + ' ' + p.surname)
                                        .join(', '),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        ),
                                        onPressed: state.loading
                                            ? null
                                            : () {
                                                final uids = group
                                                    .map((p) => p.uid)
                                                    .toList();
                                                context
                                                    .read<EventDetailCubit>()
                                                    .acceptJoinRequest(uids);
                                              },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ),
                                        onPressed: state.loading
                                            ? null
                                            : () {
                                                final uids = group
                                                    .map((p) => p.uid)
                                                    .toList();
                                                context
                                                    .read<EventDetailCubit>()
                                                    .declineJoinRequest(uids);
                                              },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      if (state.participantProfiles.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Text(
                              AppLocalizations.of(context)!.participants,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: friends
                                    .map(
                                      (profile) => GestureDetector(
                                        onTap: () {
                                          final currentUserId = FirebaseAuth
                                              .instance
                                              .currentUser
                                              ?.uid;
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => UserProfileScreen(
                                                userId: profile.uid,
                                                currentUserId: currentUserId,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            right: 8,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            color: Colors.white,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              profile.photoUrl != null
                                                  ? CircleAvatar(
                                                      radius: 18,
                                                      backgroundImage:
                                                          NetworkImage(
                                                            profile.photoUrl!,
                                                          ),
                                                    )
                                                  : const CircleAvatar(
                                                      radius: 18,
                                                      child: Icon(
                                                        Icons.person,
                                                        size: 18,
                                                      ),
                                                    ),
                                              const SizedBox(width: 8),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    profile.name +
                                                        ' ' +
                                                        profile.surname,
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    profile.nickname,
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      if (state.photoUrls.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 16.0,
                            bottom: 8.0,
                          ),
                          child: SizedBox(
                            height: 180,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.photoUrls.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, i) => ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Card(
                                  elevation: 2,
                                  margin: EdgeInsets.zero,
                                  child: Image.network(
                                    state.photoUrls[i],
                                    width: 240,
                                    height: 180,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (
                                          context,
                                          child,
                                          progress,
                                        ) => progress == null
                                        ? child
                                        : Container(
                                            width: 240,
                                            height: 180,
                                            color: Colors.grey[200],
                                            child: const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                    errorBuilder: (context, error, stack) =>
                                        Container(
                                          width: 240,
                                          height: 180,
                                          color: Colors.grey[300],
                                          child: const Icon(
                                            Icons.broken_image,
                                            size: 40,
                                            color: Colors.grey,
                                          ),
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      if (isFriend || isAuthor)
                        Center(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.chat),
                            label: Text(
                              AppLocalizations.of(context)!.go_to_chat,
                            ),
                            onPressed: () {
                              // The most reliable way is to use the event document id
                              final eventId =
                                  context
                                      .findAncestorWidgetOfExactType<
                                        EventDetailScreen
                                      >()
                                      ?.event['id'] ??
                                  '';
                              final eventTitle = state.eventTitle ?? '';
                              final eventEndTime = state.eventEndTime != null
                                  ? DateTime.tryParse(state.eventEndTime!)
                                  : null;
                              if (eventId.isNotEmpty) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ChatRoomScreen(
                                      chatId: eventId,
                                      eventTitle: eventTitle,
                                      eventEndTime: eventEndTime,
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.no_chat_id_for_event,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

List<String> _getEventTypeEmojis(String typeKey, BuildContext context) {
  final emojiString = AppLocalizations.of(
    context,
  )!.getField(typeKey + '_emoji');
  // Split by code points, preserving multi-char emojis
  return emojiString.runes.map((r) => String.fromCharCode(r)).toList();
}

// Formats event start and end time for display
String? eventStartEnd(EventDetailState state) {
  // Expects eventStartTime and eventEndTime in ISO8601 string format
  // Returns null if both are missing
  final doc = state;
  final start = (doc as dynamic).eventStartTime as String?;
  final end = (doc as dynamic).eventEndTime as String?;
  if (start == null && end == null) return null;
  String format(String? iso) {
    if (iso == null) return '';
    final dt = DateTime.tryParse(iso);
    if (dt == null) return '';
    return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  final startStr = format(start);
  final endStr = format(end);
  if (startStr.isNotEmpty && endStr.isNotEmpty) {
    return '$startStr — $endStr';
  } else if (startStr.isNotEmpty) {
    return startStr;
  } else if (endStr.isNotEmpty) {
    return endStr;
  }
  return null;
}
