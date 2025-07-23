import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/profile/profile_bloc.dart';
import '../bloc/profile/profile_event.dart';
import '../bloc/profile/profile_state.dart';
import '../l10n/app_localizations.dart';
import '../bloc/location/location_bloc.dart';
import '../bloc/location/location_state.dart';
import '../bloc/settings/settings_bloc.dart';
import '../screens/settings_screen.dart';
import '../screens/edit_profile_screen.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(ProfileLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            AppLocalizations.of(context)!.profile,
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w300),
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: AppLocalizations.of(context)!.edit_profile_title,
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              );
              if (result == true) {
                context.read<ProfileBloc>().add(ProfileLoadRequested());
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: context.read<SettingsBloc>(),
                    child: const SettingsScreen(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProfilePhotoUploadInProgress) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProfilePhotoUploadFailure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message, style: TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ProfileBloc>().add(
                            ProfileLoadRequested(),
                          );
                        },
                        child: Text(AppLocalizations.of(context)!.ok),
                      ),
                    ],
                  ),
                );
              } else if (state is ProfileLoaded) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          context.read<ProfileBloc>().add(
                            ProfilePhotoPickRequested(),
                          );
                        },
                        child:
                            state.photoUrl != null && state.photoUrl!.isNotEmpty
                            ? CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(state.photoUrl!),
                                backgroundColor: Colors.grey.shade300,
                              )
                            : CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey.shade300,
                                child: Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${state.name} ${state.surname}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (state.nickname.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        '@${state.nickname}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      state.email,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    BlocBuilder<LocationBloc, LocationState>(
                      builder: (context, locState) {
                        if (locState is LocationLoaded) {
                          if (locState.city != null &&
                              locState.country != null) {
                            return Column(
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  '${locState.city}, ${locState.country}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  'Lat: ${locState.position.latitude.toStringAsFixed(5)}, Lng: ${locState.position.longitude.toStringAsFixed(5)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            );
                          }
                        } else if (locState is LocationLoadInProgress) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              AppLocalizations.of(
                                context,
                              )!.determining_location,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        } else if (locState is LocationError) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              AppLocalizations.of(
                                context,
                              )!.location_unavailable,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                    if (state is ProfileLoaded &&
                        state.about != null &&
                        state.about!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        state.about!,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    if (state is ProfileLoaded &&
                        state.photoUrls != null &&
                        state.photoUrls!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.photoUrls!.length > 3
                            ? 3
                            : state.photoUrls!.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 6,
                              crossAxisSpacing: 6,
                              childAspectRatio: 1,
                            ),
                        itemBuilder: (context, i) {
                          final url = state.photoUrls![i];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      _FullScreenImageViewer(imageUrl: url),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: url.startsWith('http')
                                  ? Image.network(url, fit: BoxFit.cover)
                                  : Image.file(File(url), fit: BoxFit.cover),
                            ),
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 32),
                  ],
                );
              } else if (state is ProfileError) {
                return Center(child: Text(state.message));
              } else {
                return const Center(child: Text('...'));
              }
            },
          ),
        ),
      ),
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
