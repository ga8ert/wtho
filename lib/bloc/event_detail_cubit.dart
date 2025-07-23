import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';

class UserProfile {
  final String uid;
  final String nickname;
  final String? photoUrl;
  final String name;
  final String surname;
  UserProfile({
    required this.uid,
    required this.nickname,
    this.photoUrl,
    required this.name,
    required this.surname,
  });
}

class EventDetailState extends Equatable {
  final bool loading;
  final String? error;
  final List<Map<String, dynamic>> joinRequests;
  final List<String> userIds;
  final bool joinRequestSuccess;
  final bool acceptSuccess;
  final bool declineSuccess;
  final UserProfile? authorProfile;
  final List<UserProfile> participantProfiles;
  final List<List<UserProfile>> joinRequestProfiles; // profile groups
  final String? eventType;
  final double? lat;
  final double? lng;
  final String? eventTitle;
  final String? eventStartTime;
  final String? eventEndTime;
  final List<String> photoUrls;
  final String? description;
  final bool isChatPublic;

  const EventDetailState({
    this.loading = false,
    this.error,
    this.joinRequests = const [],
    this.userIds = const [],
    this.joinRequestSuccess = false,
    this.acceptSuccess = false,
    this.declineSuccess = false,
    this.authorProfile,
    this.participantProfiles = const [],
    this.joinRequestProfiles = const [],
    this.eventType,
    this.lat,
    this.lng,
    this.eventTitle,
    this.eventStartTime,
    this.eventEndTime,
    this.photoUrls = const [],
    this.description,
    this.isChatPublic = false,
  });

  EventDetailState copyWith({
    bool? loading,
    String? error,
    List<Map<String, dynamic>>? joinRequests,
    List<String>? userIds,
    bool? joinRequestSuccess,
    bool? acceptSuccess,
    bool? declineSuccess,
    UserProfile? authorProfile,
    List<UserProfile>? participantProfiles,
    List<List<UserProfile>>? joinRequestProfiles,
    String? eventType,
    double? lat,
    double? lng,
    String? eventTitle,
    String? eventStartTime,
    String? eventEndTime,
    List<String>? photoUrls,
    String? description,
    bool? isChatPublic,
  }) {
    return EventDetailState(
      loading: loading ?? this.loading,
      error: error,
      joinRequests: joinRequests ?? this.joinRequests,
      userIds: userIds ?? this.userIds,
      joinRequestSuccess: joinRequestSuccess ?? false,
      acceptSuccess: acceptSuccess ?? false,
      declineSuccess: declineSuccess ?? false,
      authorProfile: authorProfile ?? this.authorProfile,
      participantProfiles: participantProfiles ?? this.participantProfiles,
      joinRequestProfiles: joinRequestProfiles ?? this.joinRequestProfiles,
      eventType: eventType ?? this.eventType,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      eventTitle: eventTitle ?? this.eventTitle,
      eventStartTime: eventStartTime ?? this.eventStartTime,
      eventEndTime: eventEndTime ?? this.eventEndTime,
      photoUrls: photoUrls ?? this.photoUrls,
      description: description ?? this.description,
      isChatPublic: isChatPublic ?? this.isChatPublic,
    );
  }

  @override
  List<Object?> get props => [
    loading,
    error,
    joinRequests,
    userIds,
    joinRequestSuccess,
    acceptSuccess,
    declineSuccess,
    authorProfile,
    participantProfiles,
    joinRequestProfiles,
    eventType,
    lat,
    lng,
    eventTitle,
    eventStartTime,
    eventEndTime,
    photoUrls,
    description,
    isChatPublic,
  ];
}

class EventDetailCubit extends Cubit<EventDetailState> {
  final String eventTitle;
  final String authorId;
  EventDetailCubit({required this.eventTitle, required this.authorId})
    : super(const EventDetailState());

  Future<UserProfile?> _fetchUserProfile(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    if (!doc.exists) return null;
    final data = doc.data()!;
    return UserProfile(
      uid: uid,
      nickname: data['nickname'] ?? '',
      photoUrl: data['photoUrl'],
      name: data['name'] ?? '',
      surname: data['surname'] ?? '',
    );
  }

  Future<List<UserProfile>> _fetchUserProfiles(List<String> uids) async {
    final futures = uids.map(_fetchUserProfile);
    final profiles = await Future.wait(futures);
    return profiles.whereType<UserProfile>().toList();
  }

  Future<void> fetchEventDetails() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final doc = await FirebaseFirestore.instance
          .collection('events')
          .where('title', isEqualTo: eventTitle)
          .where('authorId', isEqualTo: authorId)
          .limit(1)
          .get();
      if (doc.docs.isNotEmpty) {
        final data = doc.docs.first.data();
        final authorProfile = await _fetchUserProfile(authorId);
        final userIds = List<String>.from(data['userIds'] ?? []);
        // joinRequests: array of objects {uids, timestamp} or array of UIDs (old format)
        final rawJoinRequests = data['joinRequests'] ?? [];
        List<Map<String, dynamic>> joinRequests = [];
        if (rawJoinRequests.isNotEmpty && rawJoinRequests[0] is Map) {
          joinRequests = List<Map<String, dynamic>>.from(rawJoinRequests);
        } else if (rawJoinRequests.isNotEmpty && rawJoinRequests[0] is String) {
          // old format: array of UIDs
          for (final uid in rawJoinRequests) {
            joinRequests.add({
              'uids': [uid],
              'timestamp': null,
            });
          }
        }
        final participantProfiles = await _fetchUserProfiles(userIds);
        // joinRequestProfiles: List<List<UserProfile>>
        List<List<UserProfile>> joinRequestProfiles = [];
        for (final req in joinRequests) {
          final uids = List<String>.from(req['uids'] ?? []);
          final profiles = await _fetchUserProfiles(uids);
          joinRequestProfiles.add(profiles);
        }
        final photoUrls = List<String>.from(data['photos'] ?? []);
        emit(
          state.copyWith(
            loading: false,
            joinRequests: joinRequests,
            userIds: userIds,
            authorProfile: authorProfile,
            participantProfiles: participantProfiles,
            joinRequestProfiles: joinRequestProfiles,
            eventType: data['type'],
            lat: (data['latitude'] as num?)?.toDouble(),
            lng: (data['longitude'] as num?)?.toDouble(),
            eventTitle: data['title'],
            eventStartTime: data['startDateTime'],
            eventEndTime: data['endDateTime'],
            photoUrls: photoUrls,
            description: data['description'],
            isChatPublic: data['isChatPublic'] == true,
          ),
        );
      } else {
        emit(state.copyWith(loading: false, error: 'Event not found'));
      }
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> fetchJoinRequests() async {
    await fetchEventDetails();
  }

  Future<void> sendJoinRequest() async {
    emit(state.copyWith(loading: true, error: null, joinRequestSuccess: false));
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Not authenticated');
      // Get company (withNow) of current user
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final withNow =
          (userDoc.data()?['withNow'] as List?)?.cast<String>() ?? [];
      // For joinRequest: always user.uid + withNow (without duplicates)
      final withNowToRequest = [
        user.uid,
        ...withNow.where((id) => id != user.uid),
      ];
      final doc = await FirebaseFirestore.instance
          .collection('events')
          .where('title', isEqualTo: eventTitle)
          .where('authorId', isEqualTo: authorId)
          .limit(1)
          .get();
      if (doc.docs.isNotEmpty) {
        final ref = doc.docs.first.reference;
        // Add as object
        final joinRequestObj = {
          'uids': withNowToRequest,
          'timestamp': DateTime.now().toIso8601String(),
        };
        await ref.update({
          'joinRequests': FieldValue.arrayUnion([joinRequestObj]),
        });
        await fetchEventDetails();
        emit(state.copyWith(loading: false, joinRequestSuccess: true));
      } else {
        emit(state.copyWith(loading: false, error: 'Event not found'));
      }
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> acceptJoinRequest(List<String> uids) async {
    emit(state.copyWith(loading: true, error: null, acceptSuccess: false));
    try {
      final doc = await FirebaseFirestore.instance
          .collection('events')
          .where('title', isEqualTo: eventTitle)
          .where('authorId', isEqualTo: authorId)
          .limit(1)
          .get();
      if (doc.docs.isNotEmpty) {
        final ref = doc.docs.first.reference;
        await ref.update({
          'userIds': FieldValue.arrayUnion(uids),
          // joinRequests: remove request with these uids
        });
        // Remove request from joinRequests manually (Firestore doesn't support arrayRemove for objects)
        final eventData = doc.docs.first.data();
        List<dynamic> joinRequests = eventData['joinRequests'] ?? [];
        joinRequests.removeWhere(
          (req) =>
              req is Map &&
              List<String>.from(req['uids'] ?? []).toSet().containsAll(uids) &&
              uids.toSet().containsAll(List<String>.from(req['uids'] ?? [])),
        );
        await ref.update({'joinRequests': joinRequests});
        // --- CHAT ---
        final eventId = doc.docs.first.id;
        final chatDoc = await FirebaseFirestore.instance
            .collection('chats')
            .doc(eventId)
            .get();
        final eventAuthorId = eventData['authorId'] ?? '';
        final allUserIds = {
          ...List<String>.from(eventData['userIds'] ?? []),
          eventAuthorId,
        }.toList();
        final eventTitleStr = eventData['title'] ?? '';
        final eventEndTimeStr = eventData['endDateTime'];
        if (chatDoc.exists) {
          // Update userIds in chat
          await chatDoc.reference.update({'userIds': allUserIds});
        } else {
          // Create chat
          await FirebaseFirestore.instance
              .collection('chats')
              .doc(eventId)
              .set({
                'eventId': eventId,
                'eventTitle': eventTitleStr,
                'userIds': allUserIds,
                'authorId': eventAuthorId,
                'eventEndTime': eventEndTimeStr,
                'createdAt': DateTime.now().toIso8601String(),
              });
        }
        await fetchEventDetails();
        emit(state.copyWith(loading: false, acceptSuccess: true));
      } else {
        emit(state.copyWith(loading: false, error: 'Event not found'));
      }
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> declineJoinRequest(List<String> uids) async {
    emit(state.copyWith(loading: true, error: null, declineSuccess: false));
    try {
      final doc = await FirebaseFirestore.instance
          .collection('events')
          .where('title', isEqualTo: eventTitle)
          .where('authorId', isEqualTo: authorId)
          .limit(1)
          .get();
      if (doc.docs.isNotEmpty) {
        final ref = doc.docs.first.reference;
        // Remove request from joinRequests manually
        final eventData = doc.docs.first.data();
        List<dynamic> joinRequests = eventData['joinRequests'] ?? [];
        joinRequests.removeWhere(
          (req) =>
              req is Map &&
              List<String>.from(req['uids'] ?? []).toSet().containsAll(uids) &&
              uids.toSet().containsAll(List<String>.from(req['uids'] ?? [])),
        );
        await ref.update({'joinRequests': joinRequests});
        await fetchEventDetails();
        emit(state.copyWith(loading: false, declineSuccess: true));
      } else {
        emit(state.copyWith(loading: false, error: 'Event not found'));
      }
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
