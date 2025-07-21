import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import '../../services/geolocation_service.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    on<LocationRequested>(_onLocationRequested);
  }

  Future<void> _onLocationRequested(
    LocationRequested event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoadInProgress());
    try {
      final pos = await GeolocationService.getCurrentPosition();
      if (pos != null) {
        String? city;
        String? country;
        try {
          final placemarks = await placemarkFromCoordinates(
            pos.latitude,
            pos.longitude,
          );
          if (placemarks.isNotEmpty) {
            final pm = placemarks.first;
            city =
                pm.locality ??
                pm.administrativeArea ??
                pm.subAdministrativeArea;
            country = pm.country;
          }
        } catch (e) {
          // If reverse geocoding failed, leave null
        }
        emit(LocationLoaded(pos, city: city, country: country));
      } else {
        emit(LocationError('Location not available'));
      }
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }
}
