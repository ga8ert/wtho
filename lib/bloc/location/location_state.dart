import 'package:geolocator/geolocator.dart';

abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoadInProgress extends LocationState {}

class LocationLoaded extends LocationState {
  final Position position;
  final String? city;
  final String? country;
  LocationLoaded(this.position, {this.city, this.country});
}

class LocationError extends LocationState {
  final String message;
  LocationError(this.message);
}
