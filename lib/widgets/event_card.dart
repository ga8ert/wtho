import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../l10n/app_localizations.dart';
import '../screens/event_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventCard extends StatelessWidget {
  static const Map<String, String> _typeNameKeys = {
    'event_type_social_bar': 'event_type_social_bar',
    'event_type_social_hangout': 'event_type_social_hangout',
    'event_type_social_neighbors': 'event_type_social_neighbors',
    'event_type_social_coffee': 'event_type_social_coffee',
    'event_type_social_newcomers': 'event_type_social_newcomers',
    'event_type_social_introverts': 'event_type_social_introverts',
    'event_type_social_movie_pizza': 'event_type_social_movie_pizza',
    'event_type_social_memes_tea': 'event_type_social_memes_tea',
    'event_type_social_talk': 'event_type_social_talk',
    'event_type_social_relax': 'event_type_social_relax',
    'event_type_sport_company': 'event_type_sport_company',
    'event_type_sport_play': 'event_type_sport_play',
    'event_type_sport_gym': 'event_type_sport_gym',
    'event_type_sport_morning': 'event_type_sport_morning',
    'event_type_sport_trip': 'event_type_sport_trip',
    'event_type_sport_beach': 'event_type_sport_beach',
    'event_type_sport_dog': 'event_type_sport_dog',
    'event_type_sport_cafe': 'event_type_sport_cafe',
    'event_type_games_board': 'event_type_games_board',
    'event_type_games_night': 'event_type_games_night',
    'event_type_games_standup': 'event_type_games_standup',
    'event_type_games_karaoke': 'event_type_games_karaoke',
    'event_type_games_cook': 'event_type_games_cook',
    'event_type_games_creative': 'event_type_games_creative',
    'event_type_games_language': 'event_type_games_language',
    'event_type_games_quest': 'event_type_games_quest',
    'event_type_chill_picnic': 'event_type_chill_picnic',
    'event_type_chill_yard': 'event_type_chill_yard',
    'event_type_chill_morning_coffee': 'event_type_chill_morning_coffee',
    'event_type_chill_blanket': 'event_type_chill_blanket',
  };
  static const Map<String, String> _typeEmojiKeys = {
    'event_type_social_bar': 'event_type_social_bar_emoji',
    'event_type_social_hangout': 'event_type_social_hangout_emoji',
    'event_type_social_neighbors': 'event_type_social_neighbors_emoji',
    'event_type_social_coffee': 'event_type_social_coffee_emoji',
    'event_type_social_newcomers': 'event_type_social_newcomers_emoji',
    'event_type_social_introverts': 'event_type_social_introverts_emoji',
    'event_type_social_movie_pizza': 'event_type_social_movie_pizza_emoji',
    'event_type_social_memes_tea': 'event_type_social_memes_tea_emoji',
    'event_type_social_talk': 'event_type_social_talk_emoji',
    'event_type_social_relax': 'event_type_social_relax_emoji',
    'event_type_sport_company': 'event_type_sport_company_emoji',
    'event_type_sport_play': 'event_type_sport_play_emoji',
    'event_type_sport_gym': 'event_type_sport_gym_emoji',
    'event_type_sport_morning': 'event_type_sport_morning_emoji',
    'event_type_sport_trip': 'event_type_sport_trip_emoji',
    'event_type_sport_beach': 'event_type_sport_beach_emoji',
    'event_type_sport_dog': 'event_type_sport_dog_emoji',
    'event_type_sport_cafe': 'event_type_sport_cafe_emoji',
    'event_type_games_board': 'event_type_games_board_emoji',
    'event_type_games_night': 'event_type_games_night_emoji',
    'event_type_games_standup': 'event_type_games_standup_emoji',
    'event_type_games_karaoke': 'event_type_games_karaoke_emoji',
    'event_type_games_cook': 'event_type_games_cook_emoji',
    'event_type_games_creative': 'event_type_games_creative_emoji',
    'event_type_games_language': 'event_type_games_language_emoji',
    'event_type_games_quest': 'event_type_games_quest_emoji',
    'event_type_chill_picnic': 'event_type_chill_picnic_emoji',
    'event_type_chill_yard': 'event_type_chill_yard_emoji',
    'event_type_chill_morning_coffee': 'event_type_chill_morning_coffee_emoji',
    'event_type_chill_blanket': 'event_type_chill_blanket_emoji',
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
      case 'event_type_social_bar':
        return event_type_social_bar;
      case 'event_type_social_bar_emoji':
        return event_type_social_bar_emoji;
      case 'event_type_social_hangout':
        return event_type_social_hangout;
      case 'event_type_social_hangout_emoji':
        return event_type_social_hangout_emoji;
      case 'event_type_social_neighbors':
        return event_type_social_neighbors;
      case 'event_type_social_neighbors_emoji':
        return event_type_social_neighbors_emoji;
      case 'event_type_social_coffee':
        return event_type_social_coffee;
      case 'event_type_social_coffee_emoji':
        return event_type_social_coffee_emoji;
      case 'event_type_social_newcomers':
        return event_type_social_newcomers;
      case 'event_type_social_newcomers_emoji':
        return event_type_social_newcomers_emoji;
      case 'event_type_social_introverts':
        return event_type_social_introverts;
      case 'event_type_social_introverts_emoji':
        return event_type_social_introverts_emoji;
      case 'event_type_social_movie_pizza':
        return event_type_social_movie_pizza;
      case 'event_type_social_movie_pizza_emoji':
        return event_type_social_movie_pizza_emoji;
      case 'event_type_social_memes_tea':
        return event_type_social_memes_tea;
      case 'event_type_social_memes_tea_emoji':
        return event_type_social_memes_tea_emoji;
      case 'event_type_social_talk':
        return event_type_social_talk;
      case 'event_type_social_talk_emoji':
        return event_type_social_talk_emoji;
      case 'event_type_social_relax':
        return event_type_social_relax;
      case 'event_type_social_relax_emoji':
        return event_type_social_relax_emoji;
      case 'event_type_sport_company':
        return event_type_sport_company;
      case 'event_type_sport_company_emoji':
        return event_type_sport_company_emoji;
      case 'event_type_sport_play':
        return event_type_sport_play;
      case 'event_type_sport_play_emoji':
        return event_type_sport_play_emoji;
      case 'event_type_sport_gym':
        return event_type_sport_gym;
      case 'event_type_sport_gym_emoji':
        return event_type_sport_gym_emoji;
      case 'event_type_sport_morning':
        return event_type_sport_morning;
      case 'event_type_sport_morning_emoji':
        return event_type_sport_morning_emoji;
      case 'event_type_sport_trip':
        return event_type_sport_trip;
      case 'event_type_sport_trip_emoji':
        return event_type_sport_trip_emoji;
      case 'event_type_sport_beach':
        return event_type_sport_beach;
      case 'event_type_sport_beach_emoji':
        return event_type_sport_beach_emoji;
      case 'event_type_sport_dog':
        return event_type_sport_dog;
      case 'event_type_sport_dog_emoji':
        return event_type_sport_dog_emoji;
      case 'event_type_sport_cafe':
        return event_type_sport_cafe;
      case 'event_type_sport_cafe_emoji':
        return event_type_sport_cafe_emoji;
      case 'event_type_games_board':
        return event_type_games_board;
      case 'event_type_games_board_emoji':
        return event_type_games_board_emoji;
      case 'event_type_games_night':
        return event_type_games_night;
      case 'event_type_games_night_emoji':
        return event_type_games_night_emoji;
      case 'event_type_games_standup':
        return event_type_games_standup;
      case 'event_type_games_standup_emoji':
        return event_type_games_standup_emoji;
      case 'event_type_games_karaoke':
        return event_type_games_karaoke;
      case 'event_type_games_karaoke_emoji':
        return event_type_games_karaoke_emoji;
      case 'event_type_games_cook':
        return event_type_games_cook;
      case 'event_type_games_cook_emoji':
        return event_type_games_cook_emoji;
      case 'event_type_games_creative':
        return event_type_games_creative;
      case 'event_type_games_creative_emoji':
        return event_type_games_creative_emoji;
      case 'event_type_games_language':
        return event_type_games_language;
      case 'event_type_games_language_emoji':
        return event_type_games_language_emoji;
      case 'event_type_games_quest':
        return event_type_games_quest;
      case 'event_type_games_quest_emoji':
        return event_type_games_quest_emoji;
      case 'event_type_chill_picnic':
        return event_type_chill_picnic;
      case 'event_type_chill_picnic_emoji':
        return event_type_chill_picnic_emoji;
      case 'event_type_chill_yard':
        return event_type_chill_yard;
      case 'event_type_chill_yard_emoji':
        return event_type_chill_yard_emoji;
      case 'event_type_chill_morning_coffee':
        return event_type_chill_morning_coffee;
      case 'event_type_chill_morning_coffee_emoji':
        return event_type_chill_morning_coffee_emoji;
      case 'event_type_chill_blanket':
        return event_type_chill_blanket;
      case 'event_type_chill_blanket_emoji':
        return event_type_chill_blanket_emoji;
      default:
        return '';
    }
  }
}
