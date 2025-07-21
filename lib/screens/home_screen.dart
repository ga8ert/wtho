import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wtho/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wtho/source/colors.dart';
import '../widgets/meeting_card.dart';
import '../bloc/home/home_bloc.dart';
import '../bloc/home/home_event.dart';
import '../bloc/home/home_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/auth/auth_event.dart';
import 'event_form_screen.dart';
import '../widgets/event_card.dart';
import 'profile_screen.dart';
import '../bloc/friends/friends_bloc.dart';
import 'friends_screen.dart';
import '../bloc/profile/profile_bloc.dart';
import '../bloc/profile/profile_state.dart';
import 'filter_screen.dart';
import '../widgets/filter_button.dart';
import 'who_am_i_with_screen.dart';
import 'chat_screen.dart';
import '../bloc/chat/chat_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<MeetingCardData> cards = [];
  bool _emailDialogShown = false;
  int _selectedTab = 0; // Always start with events

  // --- Meeting types ---
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

  @override
  void initState() {
    super.initState();
    _selectedTab = 0; // Always start with events
    context.read<HomeBloc>().add(LoadEventsWithLocation());
    context.read<AuthBloc>().add(EmailVerificationCheckRequested());
  }

  void _openProfile() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const ProfileScreen()));
    if (mounted) {
      setState(() {
        _selectedTab = 0;
      });
    }
  }

  Future<void> _addCard() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final withNow = (doc.data()?['withNow'] as List?)?.cast<String>() ?? [];
    }
    final result = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const EventFormScreen()));
    if (result == true && mounted) {
      context.read<HomeBloc>().add(LoadEventsWithLocation());
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is EmailVerificationError) {
          if (!_emailDialogShown) {
            _emailDialogShown = true;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context)!.confirm_email),
                  content: Text(
                    AppLocalizations.of(context)!.please_confirm_email,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                          EmailVerificationCheckRequested(),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.i_confirmed),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                          EmailVerificationResendRequested(),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.send_a_letter),
                    ),
                  ],
                );
              },
            );
          }
        } else if (state is EmailVerified) {
          if (_emailDialogShown) {
            // Close all dialogs until none left
            while (Navigator.of(context, rootNavigator: true).canPop()) {
              Navigator.of(context, rootNavigator: true).pop();
            }
            _emailDialogShown = false;
          }
        } else if (state is EmailVerificationSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.letter_has_been_sent),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is AuthInitial || state is AuthLoggedOut) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _selectedTab == 0
                      ? AppLocalizations.of(context)!.events
                      : _selectedTab == 1
                      ? AppLocalizations.of(context)!.friends
                      : AppLocalizations.of(context)!.go_to_chat,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
              actions: [
                Builder(
                  builder: (context) {
                    final currentUser = FirebaseAuth.instance.currentUser;
                    if (currentUser == null) {
                      return IconButton(
                        icon: Icon(CupertinoIcons.person_add),
                        tooltip: AppLocalizations.of(context)!.who_am_i_with,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => WhoAmIWithScreen(),
                            ),
                          );
                        },
                      );
                    }
                    return StreamBuilder<
                      DocumentSnapshot<Map<String, dynamic>>
                    >(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(currentUser.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        final data = snapshot.data?.data();
                        final withNow =
                            (data?['withNow'] as List?)?.cast<String>() ?? [];
                        final hasCompany = withNow.length >= 1;
                        return IconButton(
                          icon: Icon(
                            hasCompany
                                ? CupertinoIcons.group_solid
                                : CupertinoIcons.person_add,
                            color: CustomColors.blue,
                          ),
                          tooltip: AppLocalizations.of(context)!.who_am_i_with,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => WhoAmIWithScreen(),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),

                if (state is HomeLoadedEvents)
                  FilterButton(
                    ageRange: state.ageRange,
                    radius: state.radius,
                    selectedTypes: state.selectedTypes,
                    typeNameKeys: _typeNameKeys,
                    iconSize: 20,
                    onResult: (result) {
                      context.read<HomeBloc>().add(
                        UpdateEventFilters(
                          ageRange: result.ageRange,
                          radius: result.radius,
                          selectedTypes: result.selectedTypes,
                        ),
                      );
                    },
                  ),
                GestureDetector(
                  onTap: _openProfile,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, profileState) {
                        String? photoUrl;
                        if (profileState is ProfileLoaded) {
                          photoUrl = profileState.photoUrl;
                        }
                        return CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white,
                          backgroundImage:
                              (photoUrl != null && photoUrl.isNotEmpty)
                              ? NetworkImage(photoUrl)
                              : null,
                          child: (photoUrl == null || photoUrl.isEmpty)
                              ? Icon(Icons.person, color: Colors.blue, size: 35)
                              : null,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            body: Builder(
              builder: (context) {
                if (_selectedTab == 2) {
                  return BlocProvider(
                    create: (_) => ChatBloc(),
                    child: ChatScreen(),
                  );
                }
                if (_selectedTab == 1) {
                  return BlocProvider(
                    create: (_) => FriendsBloc(),
                    child: FriendsScreen(
                      userId: FirebaseAuth.instance.currentUser?.uid ?? '',
                    ),
                  );
                }
                if (state is HomeLoading) {
                  return FutureBuilder(
                    future: Future.delayed(const Duration(seconds: 1)),
                    builder: (context, snap) {
                      if (snap.connectionState != ConnectionState.done) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return Center(
                          child: Text(AppLocalizations.of(context)!.no_data),
                        );
                      }
                    },
                  );
                } else if (state is HomeLoadedEvents) {
                  final events = state.events;
                  final ageRange = state.ageRange;
                  final radius = state.radius;
                  final selectedTypes = state.selectedTypes;
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<HomeBloc>().add(LoadEventsWithLocation());
                    },
                    child: events.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              const SizedBox(height: 32),
                              Center(
                                child: Text(
                                  AppLocalizations.of(context)!.no_events,
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: events.length,
                            itemBuilder: (context, index) {
                              final event = events[index];
                              if ((event['authorId'] ?? '').isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: EventCard(
                                  id:
                                      event['id'] ??
                                      event['docId'], // додано явну передачу id
                                  title: event['title'] ?? '',
                                  place: event['place'] ?? '',
                                  authorId: event['authorId'] ?? '',
                                  userIds:
                                      (event['userIds'] as List?)
                                          ?.cast<String>() ??
                                      [],
                                  distanceInMeters:
                                      event['distance'] as double?,
                                  latitude: event['latitude'],
                                  longitude: event['longitude'],
                                  description: event['description'] ?? '',
                                  type: event['type'] ?? '',
                                ),
                              );
                            },
                          ),
                  );
                } else if (state is HomeError) {
                  return Center(child: Text(state.message));
                } else {
                  return Center(
                    child: Text(AppLocalizations.of(context)!.ellipsis),
                  );
                }
              },
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(left: 50, right: 50, bottom: 25),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: SizedBox(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.search_sharp,
                            color: Colors.white,
                            size: 35,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            setState(() {
                              _selectedTab = 0;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            CupertinoIcons.add_circled,
                            color: Colors.white,
                            size: 40,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            _addCard();
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            CupertinoIcons.group,
                            color: Colors.white,
                            size: 45,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            setState(() {
                              _selectedTab = 1;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            CupertinoIcons.conversation_bubble,
                            color: Colors.white,
                            size: 35,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            setState(() {
                              _selectedTab = 2;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Filters widget ---
  Widget _buildFilters(
    BuildContext context,
    RangeValues ageRange,
    double radius,
    Set<String> selectedTypes,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.filters,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            Text(AppLocalizations.of(context)!.age),
            RangeSlider(
              values: ageRange,
              min: 0,
              max: 100,
              divisions: 100,
              labels: RangeLabels(
                ageRange.start.round().toString(),
                ageRange.end.round().toString(),
              ),
              onChanged: (values) {
                context.read<HomeBloc>().add(
                  UpdateEventFilters(
                    ageRange: values,
                    radius: radius,
                    selectedTypes: selectedTypes,
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.radius),
            Slider(
              value: radius,
              min: 0,
              max: 100,
              divisions: 100,
              label: radius.round().toString(),
              onChanged: (value) {
                context.read<HomeBloc>().add(
                  UpdateEventFilters(
                    ageRange: ageRange,
                    radius: value,
                    selectedTypes: selectedTypes,
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.meeting_type),
            Wrap(
              spacing: 8,
              children: _typeNameKeys.entries.map((entry) {
                final type = entry.key;
                final label = AppLocalizations.of(
                  context,
                )!.getField(entry.value);
                final selected = selectedTypes.contains(type);
                return FilterChip(
                  label: Text(label),
                  selected: selected,
                  onSelected: (v) {
                    final newTypes = Set<String>.from(selectedTypes);
                    if (v) {
                      newTypes.add(type);
                    } else {
                      newTypes.remove(type);
                    }
                    context.read<HomeBloc>().add(
                      UpdateEventFilters(
                        ageRange: ageRange,
                        radius: radius,
                        selectedTypes: newTypes,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            if (selectedTypes.isNotEmpty ||
                ageRange.start > 0 ||
                ageRange.end < 100 ||
                radius < 100)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    context.read<HomeBloc>().add(
                      UpdateEventFilters(
                        ageRange: const RangeValues(0, 100),
                        radius: 100,
                        selectedTypes: {},
                      ),
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.reset_filters),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
