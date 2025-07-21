import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wtho/bloc/app/app_bloc.dart';
import '../bloc/app/app_event.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/profile/profile_bloc.dart';
import '../bloc/profile/profile_event.dart';
import '../bloc/profile/profile_state.dart';
import '../l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../services/geolocation_service.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';

import '../routes/app_routes.dart';
import '../services/navigation_service.dart';
import '../bloc/location/location_bloc.dart';
import '../bloc/location/location_state.dart';
import '../bloc/settings/settings_bloc.dart';
import '../screens/settings_screen.dart';
import '../source/image_utils.dart';
import '../screens/support_us_screen.dart';

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
                    const SizedBox(height: 32),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: Text(AppLocalizations.of(context)!.settings),
                      onTap: () {
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
                    ListTile(
                      leading: const Icon(Icons.favorite),
                      title: Text(AppLocalizations.of(context)!.support_us),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SupportUsScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: Text(AppLocalizations.of(context)!.logout),
                      onTap: () {
                        context.read<AuthBloc>().add(AuthLogoutRequested());
                      },
                    ),
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
