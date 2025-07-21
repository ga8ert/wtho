import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'home_event.dart';
import 'home_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  RangeValues _ageRange = const RangeValues(0, 100);
  double _radius = 100;
  Set<String> _selectedTypes = {};

  HomeBloc() : super(HomeInitial()) {
    on<LoadEventsWithLocation>(_onLoadEventsWithLocation);
    on<UpdateEventFilters>(_onUpdateEventFilters);
  }

  Future<void> _onLoadEventsWithLocation(
    LoadEventsWithLocation event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      // 1. Get geolocation
      final pos = await Geolocator.getCurrentPosition();
      final user = FirebaseAuth.instance.currentUser;
      final uid = user?.uid ?? '';
      // 2. Listen to events from Firestore (once, not stream)
      final snap = await FirebaseFirestore.instance
          .collection('events')
          .orderBy('createdAt', descending: true)
          .get();
      final docs = snap.docs;
      final now = DateTime.now();
      // 3. Filter events that haven't ended yet
      final events = docs
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          })
          .where((event) {
            final end = event['endDateTime'];
            if (end == null) return true;
            final endDt = DateTime.tryParse(end);
            return endDt == null || endDt.isAfter(now);
          })
          .toList();
      // 4. Add distance to each event
      for (final event in events) {
        final lat = event['latitude'];
        final lng = event['longitude'];
        if (lat != null && lng != null) {
          event['distance'] = Geolocator.distanceBetween(
            pos.latitude,
            pos.longitude,
            lat,
            lng,
          );
        } else {
          event['distance'] = double.infinity;
        }
      }
      // 5. Add author (user) to event['author'] for age filtering
      for (final event in events) {
        final authorId = event['authorId'];
        if (authorId != null) {
          final doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(authorId)
              .get();
          if (doc.exists) {
            event['author'] = doc.data();
          }
        }
      }
      // 6. Filter by radius, type, age (author)
      List<Map<String, dynamic>> filteredEvents;
      final isDefaultFilters =
          _ageRange == const RangeValues(0, 100) &&
          _radius == 100 &&
          _selectedTypes.isEmpty;
      if (isDefaultFilters) {
        filteredEvents = List<Map<String, dynamic>>.from(events);
      } else {
        filteredEvents = events.where((event) {
          // radius
          final distance = (event['distance'] ?? double.infinity) / 1000.0;
          if (distance > _radius) {
            return false;
          }
          // type
          if (_selectedTypes.isNotEmpty &&
              !_selectedTypes.contains(event['type'])) {
            return false;
          }
          // age (author)
          final authorAge = event['author'] != null
              ? event['author']['age']
              : null;
          if (authorAge != null &&
              (authorAge < _ageRange.start || authorAge > _ageRange.end)) {
            return false;
          }
          return true;
        }).toList();
      }
      // 7. Split into "mine" and "others"
      final myEvents = filteredEvents
          .where((e) => e['authorId'] == uid)
          .toList();
      final otherEvents = filteredEvents
          .where((e) => e['authorId'] != uid)
          .toList();
      // 8. Sort each group by distance
      myEvents.sort(
        (a, b) => (a['distance'] as double).compareTo(b['distance'] as double),
      );
      otherEvents.sort(
        (a, b) => (a['distance'] as double).compareTo(b['distance'] as double),
      );
      // 9. Combine
      final sortedEvents = [...myEvents, ...otherEvents];
      emit(
        HomeLoadedEvents(
          events: sortedEvents,
          userLat: pos.latitude,
          userLng: pos.longitude,
          ageRange: _ageRange,
          radius: _radius,
          selectedTypes: _selectedTypes,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onUpdateEventFilters(
    UpdateEventFilters event,
    Emitter<HomeState> emit,
  ) async {
    _ageRange = event.ageRange;
    _radius = event.radius;
    _selectedTypes = event.selectedTypes;
    add(LoadEventsWithLocation());
  }
}
