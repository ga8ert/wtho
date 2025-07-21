import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:flutter/cupertino.dart';
import '../bloc/event/event_form_cubit.dart';
import '../l10n/app_localizations.dart';
import 'map_picker_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'friend_picker_screen.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/friends/friends_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../bloc/home/home_bloc.dart';
import '../screens/home_screen.dart';
import '../bloc/home/home_state.dart';
import '../bloc/home/home_event.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/event_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventFormScreen extends StatelessWidget {
  const EventFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
      future: () async {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return null;
        return await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
      }(),
      builder: (context, snapshot) {
        List<String> withNow = [];
        if (snapshot.hasData && snapshot.data?.data()?['withNow'] != null) {
          withNow = (snapshot.data!.data()!['withNow'] as List).cast<String>();
        }
        final user = FirebaseAuth.instance.currentUser;
        final uid = user?.uid;
        List<String> userIds = [];
        if (uid != null) {
          userIds = [uid, ...withNow.where((id) => id != uid)];
        }
        return BlocProvider(
          create: (_) => EventFormCubit()..setUserIds(userIds),
          child: Builder(
            builder: (context) {
              final cubit = context.read<EventFormCubit>();
              // Simple string comparison to avoid connecting collection
              if (cubit.state.userIds.join(',') != userIds.join(',')) {
                cubit.setUserIds(userIds);
              }
              return const _EventFormBody();
            },
          ),
        );
      },
    );
  }
}

class _EventFormBody extends StatelessWidget {
  const _EventFormBody();

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventFormCubit, EventFormState>(
      listenWhen: (previous, current) =>
          previous.success != current.success ||
          previous.error != current.error,
      listener: (context, state) {
        if (state.success) {
          Navigator.of(context).pop(true); // return true to indicate success
        }
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
          );
        }
      },
      child: BlocBuilder<EventFormCubit, EventFormState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFEAF6FF),
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                AppLocalizations.of(context)!.create_event,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              centerTitle: true,
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Title
                      _RoundedInputField(
                        icon: Icons.title,
                        hintText: AppLocalizations.of(context)!.title,
                        onChanged: context.read<EventFormCubit>().setTitle,
                        errorText: state.titleError,
                      ),
                      const SizedBox(height: 16),
                      // Place
                      _RoundedInputField(
                        icon: Icons.place,
                        hintText: AppLocalizations.of(context)!.place,
                        onChanged: context.read<EventFormCubit>().setPlace,
                        errorText: state.placeError,
                      ),
                      const SizedBox(height: 16),
                      // Meeting type
                      _RoundedDropdownField(
                        icon: Icons.event,
                        value: state.type.isNotEmpty ? state.type : null,
                        items: [
                          DropdownMenuItem(
                            value: 'event_type_aquapark',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_aquapark_emoji}  ${AppLocalizations.of(context)!.event_type_aquapark}',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'event_type_art_gallery',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_art_gallery_emoji}  ${AppLocalizations.of(context)!.event_type_art_gallery}',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'event_type_bbq',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_bbq_emoji}  ${AppLocalizations.of(context)!.event_type_bbq}',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'event_type_bowling',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_bowling_emoji}  ${AppLocalizations.of(context)!.event_type_bowling}',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'event_type_library',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_library_emoji}  ${AppLocalizations.of(context)!.event_type_library}',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'event_type_bike',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_bike_emoji}  ${AppLocalizations.of(context)!.event_type_bike}',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'event_type_boardgames',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_boardgames_emoji}  ${AppLocalizations.of(context)!.event_type_boardgames}',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'event_type_exhibition',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_exhibition_emoji}  ${AppLocalizations.of(context)!.event_type_exhibition}',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'event_type_gastro',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_gastro_emoji}  ${AppLocalizations.of(context)!.event_type_gastro}',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'event_type_beach',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_beach_emoji}  ${AppLocalizations.of(context)!.event_type_beach}',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'event_type_yoga',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_yoga_emoji}  ${AppLocalizations.of(context)!.event_type_yoga}',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'event_type_karaoke',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_karaoke_emoji}  ${AppLocalizations.of(context)!.event_type_karaoke}',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'event_type_karting',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_karting_emoji}  ${AppLocalizations.of(context)!.event_type_karting}',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'event_type_quest',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_quest_emoji}  ${AppLocalizations.of(context)!.event_type_quest}',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'event_type_coworking',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_coworking_emoji}  ${AppLocalizations.of(context)!.event_type_coworking}',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'event_type_concert',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_concert_emoji}  ${AppLocalizations.of(context)!.event_type_concert}',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'event_type_lasertag',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_lasertag_emoji}  ${AppLocalizations.of(context)!.event_type_lasertag}',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'event_type_picnic',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_picnic_emoji}  ${AppLocalizations.of(context)!.event_type_picnic}',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'event_type_masterclass',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_masterclass_emoji}  ${AppLocalizations.of(context)!.event_type_masterclass}',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'event_type_museum',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_museum_emoji}  ${AppLocalizations.of(context)!.event_type_museum}',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'event_type_movie',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_movie_emoji}  ${AppLocalizations.of(context)!.event_type_movie}',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'event_type_ferris',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_ferris_emoji}  ${AppLocalizations.of(context)!.event_type_ferris}',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'event_type_pub',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_pub_emoji}  ${AppLocalizations.of(context)!.event_type_pub}',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'event_type_park',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_park_emoji}  ${AppLocalizations.of(context)!.event_type_park}',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'event_type_hiking',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_hiking_emoji}  ${AppLocalizations.of(context)!.event_type_hiking}',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'event_type_restaurant',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_restaurant_emoji}  ${AppLocalizations.of(context)!.event_type_restaurant}',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'event_type_skating',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_skating_emoji}  ${AppLocalizations.of(context)!.event_type_skating}',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'event_type_safari',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_safari_emoji}  ${AppLocalizations.of(context)!.event_type_safari}',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'event_type_gym',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_gym_emoji}  ${AppLocalizations.of(context)!.event_type_gym}',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'event_type_party',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_party_emoji}  ${AppLocalizations.of(context)!.event_type_party}',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'event_type_private',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_private_emoji}  ${AppLocalizations.of(context)!.event_type_private}',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'event_type_other',
                            child: Text(
                              '${AppLocalizations.of(context)!.event_type_other_emoji}  ${AppLocalizations.of(context)!.event_type_other}',
                            ),
                          ),
                        ],
                        onChanged: (v) {
                          if (v != null)
                            context.read<EventFormCubit>().setType(v);
                        },
                        hintText: AppLocalizations.of(context)!.meeting_type,
                      ),
                      const SizedBox(height: 16),
                      // Map point
                      _RoundedMapPicker(state: state),
                      const SizedBox(height: 16),
                      // Start time
                      _RoundedDateTimePicker(
                        label: AppLocalizations.of(context)!.select_start_time,
                        value: state.startDateTime,
                        onPick: (picked) {
                          if (picked != null) {
                            context.read<EventFormCubit>().setStartDateTime(
                              picked,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      // End time
                      _RoundedDateTimePicker(
                        label: AppLocalizations.of(context)!.select_end_time,
                        value: state.endDateTime,
                        onPick: (picked) {
                          if (picked != null) {
                            context.read<EventFormCubit>().setEndDateTime(
                              picked,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      // Add photo
                      _RoundedPhotoPicker(state: state),
                      const SizedBox(height: 16),
                      // Description
                      _RoundedInputField(
                        icon: Icons.description,
                        hintText: AppLocalizations.of(context)!.description,
                        onChanged: context
                            .read<EventFormCubit>()
                            .setDescription,
                        minLines: 2,
                        maxLines: 4,
                        errorText: state.descriptionError,
                      ),
                      const SizedBox(height: 16),
                      // Add users
                      _RoundedAddUsers(state: state),
                      const SizedBox(height: 24),
                      // Create event button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2196F3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            elevation: 0,
                          ),
                          onPressed: state.submitting
                              ? null
                              : () => context.read<EventFormCubit>().submit(),
                          child: state.submitting
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  AppLocalizations.of(context)!.create_event,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                        ),
                      ),
                      if (state.success)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            AppLocalizations.of(context)!.event_created,
                            style: const TextStyle(color: Colors.green),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RoundedInputField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final int? minLines;
  final int? maxLines;
  final String? errorText;

  const _RoundedInputField({
    required this.icon,
    required this.hintText,
    this.onChanged,
    this.minLines,
    this.maxLines,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          minLines: minLines,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey),
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          onChanged: onChanged,
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 4.0),
            child: Text(
              errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

class _RoundedDropdownField extends StatelessWidget {
  final IconData icon;
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?>? onChanged;
  final String hintText;

  const _RoundedDropdownField({
    required this.icon,
    this.value,
    required this.items,
    this.onChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}

class _RoundedMapPicker extends StatelessWidget {
  final EventFormState state;
  const _RoundedMapPicker({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.map, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              state.latitude != null && state.longitude != null
                  ? AppLocalizations.of(context)!.map_point_selected(
                      state.latitude!.toStringAsFixed(5),
                      state.longitude!.toStringAsFixed(5),
                    )
                  : AppLocalizations.of(context)!.map_point_not_selected,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          TextButton(
            onPressed: () async {
              final LatLng? picked = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MapPickerScreen(
                    initialLat: state.latitude,
                    initialLng: state.longitude,
                  ),
                ),
              );
              if (picked != null) {
                context.read<EventFormCubit>().setLatLng(
                  picked.latitude,
                  picked.longitude,
                );
              }
            },
            child: Text(AppLocalizations.of(context)!.select_on_map),
          ),
        ],
      ),
    );
  }
}

class _RoundedDateTimePicker extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?>? onPick;

  const _RoundedDateTimePicker({required this.label, this.value, this.onPick});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.access_time, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value != null ? value.toString() : label,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          TextButton(
            onPressed: () async {
              final picked = await showCupertinoModalPopup<DateTime>(
                context: context,
                builder: (context) {
                  DateTime temp = value ?? DateTime.now();
                  return Container(
                    height: 300,
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 250,
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.dateAndTime,
                              initialDateTime: temp,
                              onDateTimeChanged: (dt) => temp = dt,
                            ),
                          ),
                          CupertinoButton(
                            child: Text(AppLocalizations.of(context)!.done),
                            onPressed: () {
                              Navigator.of(context).pop(temp);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
              if (picked != null) {
                onPick?.call(picked);
              }
            },
            child: Text(AppLocalizations.of(context)!.select),
          ),
        ],
      ),
    );
  }
}

class _RoundedPhotoPicker extends StatelessWidget {
  final EventFormState state;
  const _RoundedPhotoPicker({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[100],
            foregroundColor: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          ),
          icon: const Icon(Icons.add_a_photo, color: Colors.blue),
          label: Text(AppLocalizations.of(context)!.add_photo),
          onPressed: () async {
            final cubit = context.read<EventFormCubit>();
            showModalBottomSheet(
              context: context,
              builder: (bottomSheetContext) => SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.photo_camera),
                      title: const Text('Take photo'),
                      onTap: () {
                        Navigator.of(bottomSheetContext).pop();
                        cubit.pickPhoto(source: ImageSource.camera);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Choose from gallery'),
                      onTap: () {
                        Navigator.of(bottomSheetContext).pop();
                        cubit.pickPhoto(source: ImageSource.gallery);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        if (state.selectedPhotos.isNotEmpty)
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: state.selectedPhotos.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) => Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      state.selectedPhotos[i],
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: () =>
                          context.read<EventFormCubit>().removePhotoAt(i),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _RoundedAddUsers extends StatelessWidget {
  final EventFormState state;
  const _RoundedAddUsers({required this.state});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    final selectedFriendsCount = state.userIds.where((id) => id != uid).length;
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.group, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              selectedFriendsCount > 0
                  ? AppLocalizations.of(
                      context,
                    )!.users_added(selectedFriendsCount)
                  : AppLocalizations.of(context)!.no_users_selected,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          TextButton(
            onPressed: () async {
              if (uid == null) {
                context.read<EventFormCubit>().setUserIds([]);
                return;
              }
              final List<String>? picked = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: context.read<FriendsBloc>(),
                    child: FriendPickerScreen(
                      userId: uid,
                      initiallySelected: state.userIds,
                    ),
                  ),
                ),
              );
              if (picked != null &&
                  picked.isNotEmpty &&
                  picked.any((id) => id != uid)) {
                context.read<EventFormCubit>().setUserIds(picked);
              }
            },
            child: Text(AppLocalizations.of(context)!.add_users),
          ),
        ],
      ),
    );
  }
}
