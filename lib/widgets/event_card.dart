import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../l10n/app_localizations.dart';
import '../screens/event_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventCard extends StatelessWidget {
  static const Map<String, String> _typeNameKeys = {
    'event_type_aquapark': 'event_type_aquapark',
    'event_type_art_gallery': 'event_type_art_gallery',
    'event_type_bbq': 'event_type_bbq',
    'event_type_bowling': 'event_type_bowling',
    'event_type_library': 'event_type_library',
    'event_type_bike': 'event_type_bike',
    'event_type_boardgames': 'event_type_boardgames',
    'event_type_exhibition': 'event_type_exhibition',
    'event_type_gastro': 'event_type_gastro',
    'event_type_beach': 'event_type_beach',
    'event_type_yoga': 'event_type_yoga',
    'event_type_karaoke': 'event_type_karaoke',
    'event_type_karting': 'event_type_karting',
    'event_type_quest': 'event_type_quest',
    'event_type_coworking': 'event_type_coworking',
    'event_type_concert': 'event_type_concert',
    'event_type_lasertag': 'event_type_lasertag',
    'event_type_picnic': 'event_type_picnic',
    'event_type_masterclass': 'event_type_masterclass',
    'event_type_museum': 'event_type_museum',
    'event_type_movie': 'event_type_movie',
    'event_type_ferris': 'event_type_ferris',
    'event_type_pub': 'event_type_pub',
    'event_type_park': 'event_type_park',
    'event_type_hiking': 'event_type_hiking',
    'event_type_restaurant': 'event_type_restaurant',
    'event_type_skating': 'event_type_skating',
    'event_type_safari': 'event_type_safari',
    'event_type_gym': 'event_type_gym',
    'event_type_party': 'event_type_party',
    'event_type_private': 'event_type_private',
    'event_type_other': 'event_type_other',
  };
  static const Map<String, String> _typeEmojiKeys = {
    'event_type_aquapark': 'event_type_aquapark_emoji',
    'event_type_art_gallery': 'event_type_art_gallery_emoji',
    'event_type_bbq': 'event_type_bbq_emoji',
    'event_type_bowling': 'event_type_bowling_emoji',
    'event_type_library': 'event_type_library_emoji',
    'event_type_bike': 'event_type_bike_emoji',
    'event_type_boardgames': 'event_type_boardgames_emoji',
    'event_type_exhibition': 'event_type_exhibition_emoji',
    'event_type_gastro': 'event_type_gastro_emoji',
    'event_type_beach': 'event_type_beach_emoji',
    'event_type_yoga': 'event_type_yoga_emoji',
    'event_type_karaoke': 'event_type_karaoke_emoji',
    'event_type_karting': 'event_type_karting_emoji',
    'event_type_quest': 'event_type_quest_emoji',
    'event_type_coworking': 'event_type_coworking_emoji',
    'event_type_concert': 'event_type_concert_emoji',
    'event_type_lasertag': 'event_type_lasertag_emoji',
    'event_type_picnic': 'event_type_picnic_emoji',
    'event_type_masterclass': 'event_type_masterclass_emoji',
    'event_type_museum': 'event_type_museum_emoji',
    'event_type_movie': 'event_type_movie_emoji',
    'event_type_ferris': 'event_type_ferris_emoji',
    'event_type_pub': 'event_type_pub_emoji',
    'event_type_park': 'event_type_park_emoji',
    'event_type_hiking': 'event_type_hiking_emoji',
    'event_type_restaurant': 'event_type_restaurant_emoji',
    'event_type_skating': 'event_type_skating_emoji',
    'event_type_safari': 'event_type_safari_emoji',
    'event_type_gym': 'event_type_gym_emoji',
    'event_type_party': 'event_type_party_emoji',
    'event_type_private': 'event_type_private_emoji',
    'event_type_other': 'event_type_other_emoji',
  };
  final String title;
  final String place;
  final String authorId;
  final List<String> userIds;
  final double? distanceInMeters;
  final double? latitude;
  final double? longitude;
  final String description;
  final String? type;
  final String? id;

  const EventCard({
    super.key,
    required this.title,
    required this.place,
    required this.authorId,
    this.userIds = const [],
    this.distanceInMeters,
    this.latitude,
    this.longitude,
    this.description = '',
    this.type,
    this.id,
  });

  Future<Map<String, dynamic>?> _getUser(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    return doc.data();
  }

  Future<List<Map<String, dynamic>>> _getFriends(List<String> uids) async {
    if (uids.isEmpty) return [];
    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', whereIn: uids)
        .get();
    return query.docs.map((d) => d.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    final String? currentUid = FirebaseAuth.instance.currentUser?.uid;
    final List<String> friendsIds = userIds
        .where((id) => id != authorId)
        .toList();
    return FutureBuilder<Map<String, dynamic>?>(
      future: _getUser(authorId),
      builder: (context, authorSnap) {
        if (!authorSnap.hasData) {
          return _skeleton();
        }
        final author = authorSnap.data!;
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: _getFriends(friendsIds),
          builder: (context, friendsSnap) {
            final friends = friendsSnap.data ?? [];
            final bool isConfirmed =
                currentUid != null && userIds.contains(currentUid);
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EventDetailScreen(
                      event: {
                        'id': id,
                        'title': title,
                        'place': place,
                        'authorId': authorId,
                        'userIds': userIds,
                        'distance': distanceInMeters,
                        'description': description,
                        'latitude': latitude,
                        'longitude': longitude,
                        'author': author,
                        'friends': friends,
                      },
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: BoxBorder.all(
                    color: isConfirmed ? Colors.lightBlue[200]! : Colors.white,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(7, 10),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            if (distanceInMeters != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  top: 2.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.near_me,
                                      size: 16,
                                      color: Colors.blueGrey,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      '${(distanceInMeters! / 1000).toStringAsFixed(1)} ${AppLocalizations.of(context)!.km}',
                                      style: const TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        if (type != null && type!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 2.0,
                              bottom: 2.0,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  _typeNameKeys[type!] != null
                                      ? AppLocalizations.of(
                                          context,
                                        )!.getField(_typeNameKeys[type!]!)
                                      : '',
                                  style: const TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (_typeEmojiKeys[type!] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.getField(_typeEmojiKeys[type!]!),
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          place,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildAvatar(
                              author['photoUrl'] ?? '',
                              author['nickname'] ?? '',
                            ),
                            if (friends.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: _buildOverlappedAvatars(friends),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          author['nickname'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAvatar(String url, String nickname) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.grey.shade200,
      backgroundImage: url.isNotEmpty ? NetworkImage(url) : null,
      child: url.isEmpty
          ? Text(
              nickname.isNotEmpty ? nickname[0] : '?',
              style: const TextStyle(color: Colors.grey),
            )
          : null,
    );
  }

  Widget _buildAvatarSmall(String url, String nickname) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: Colors.grey.shade200,
      backgroundImage: url.isNotEmpty ? NetworkImage(url) : null,
      child: url.isEmpty
          ? Text(
              nickname.isNotEmpty ? nickname[0] : '?',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            )
          : null,
    );
  }

  Widget _buildOverlappedAvatars(List<Map<String, dynamic>> avatars) {
    int showCount = avatars.length > 4 ? 4 : avatars.length;
    double radius = 20;
    double overlap = 16;
    return Row(
      children: [
        SizedBox(
          width: radius * 2 + (showCount - 1) * overlap,
          height: radius * 2,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              for (int i = 0; i < showCount; i++)
                Positioned(
                  left: i * overlap,
                  child: CircleAvatar(
                    radius: radius,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: (avatars[i]['photoUrl'] ?? '').isNotEmpty
                        ? NetworkImage(avatars[i]['photoUrl'])
                        : null,
                    child: (avatars[i]['photoUrl'] ?? '').isEmpty
                        ? Text(
                            (avatars[i]['nickname'] ?? '').isNotEmpty
                                ? avatars[i]['nickname'][0]
                                : '?',
                            style: const TextStyle(color: Colors.grey),
                          )
                        : null,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '+${avatars.length}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _skeleton() => Container(
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 20, width: 120, color: Colors.grey[200]),
        const SizedBox(height: 8),
        Container(height: 16, width: 80, color: Colors.grey[100]),
        const SizedBox(height: 16),
        Row(
          children: List.generate(
            3,
            (i) => Padding(
              padding: const EdgeInsets.only(right: 4),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[200],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

extension AppLocalizationsGetField on AppLocalizations {
  String getField(String key) {
    switch (key) {
      case 'event_type_aquapark':
        return event_type_aquapark;
      case 'event_type_aquapark_emoji':
        return event_type_aquapark_emoji;
      case 'event_type_art_gallery':
        return event_type_art_gallery;
      case 'event_type_art_gallery_emoji':
        return event_type_art_gallery_emoji;
      case 'event_type_bbq':
        return event_type_bbq;
      case 'event_type_bbq_emoji':
        return event_type_bbq_emoji;
      case 'event_type_bowling':
        return event_type_bowling;
      case 'event_type_bowling_emoji':
        return event_type_bowling_emoji;
      case 'event_type_library':
        return event_type_library;
      case 'event_type_library_emoji':
        return event_type_library_emoji;
      case 'event_type_bike':
        return event_type_bike;
      case 'event_type_bike_emoji':
        return event_type_bike_emoji;
      case 'event_type_boardgames':
        return event_type_boardgames;
      case 'event_type_boardgames_emoji':
        return event_type_boardgames_emoji;
      case 'event_type_exhibition':
        return event_type_exhibition;
      case 'event_type_exhibition_emoji':
        return event_type_exhibition_emoji;
      case 'event_type_gastro':
        return event_type_gastro;
      case 'event_type_gastro_emoji':
        return event_type_gastro_emoji;
      case 'event_type_beach':
        return event_type_beach;
      case 'event_type_beach_emoji':
        return event_type_beach_emoji;
      case 'event_type_yoga':
        return event_type_yoga;
      case 'event_type_yoga_emoji':
        return event_type_yoga_emoji;
      case 'event_type_karaoke':
        return event_type_karaoke;
      case 'event_type_karaoke_emoji':
        return event_type_karaoke_emoji;
      case 'event_type_karting':
        return event_type_karting;
      case 'event_type_karting_emoji':
        return event_type_karting_emoji;
      case 'event_type_quest':
        return event_type_quest;
      case 'event_type_quest_emoji':
        return event_type_quest_emoji;
      case 'event_type_coworking':
        return event_type_coworking;
      case 'event_type_coworking_emoji':
        return event_type_coworking_emoji;
      case 'event_type_concert':
        return event_type_concert;
      case 'event_type_concert_emoji':
        return event_type_concert_emoji;
      case 'event_type_lasertag':
        return event_type_lasertag;
      case 'event_type_lasertag_emoji':
        return event_type_lasertag_emoji;
      case 'event_type_picnic':
        return event_type_picnic;
      case 'event_type_picnic_emoji':
        return event_type_picnic_emoji;
      case 'event_type_masterclass':
        return event_type_masterclass;
      case 'event_type_masterclass_emoji':
        return event_type_masterclass_emoji;
      case 'event_type_museum':
        return event_type_museum;
      case 'event_type_museum_emoji':
        return event_type_museum_emoji;
      case 'event_type_movie':
        return event_type_movie;
      case 'event_type_movie_emoji':
        return event_type_movie_emoji;
      case 'event_type_ferris':
        return event_type_ferris;
      case 'event_type_ferris_emoji':
        return event_type_ferris_emoji;
      case 'event_type_pub':
        return event_type_pub;
      case 'event_type_pub_emoji':
        return event_type_pub_emoji;
      case 'event_type_park':
        return event_type_park;
      case 'event_type_park_emoji':
        return event_type_park_emoji;
      case 'event_type_hiking':
        return event_type_hiking;
      case 'event_type_hiking_emoji':
        return event_type_hiking_emoji;
      case 'event_type_restaurant':
        return event_type_restaurant;
      case 'event_type_restaurant_emoji':
        return event_type_restaurant_emoji;
      case 'event_type_skating':
        return event_type_skating;
      case 'event_type_skating_emoji':
        return event_type_skating_emoji;
      case 'event_type_safari':
        return event_type_safari;
      case 'event_type_safari_emoji':
        return event_type_safari_emoji;
      case 'event_type_gym':
        return event_type_gym;
      case 'event_type_gym_emoji':
        return event_type_gym_emoji;
      case 'event_type_party':
        return event_type_party;
      case 'event_type_party_emoji':
        return event_type_party_emoji;
      case 'event_type_private':
        return event_type_private;
      case 'event_type_private_emoji':
        return event_type_private_emoji;
      case 'event_type_other':
        return event_type_other;
      case 'event_type_other_emoji':
        return event_type_other_emoji;
      default:
        return '';
    }
  }
}
