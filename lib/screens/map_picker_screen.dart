import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../l10n/app_localizations.dart';
import '../services/geolocation_service.dart';

class MapPickerScreen extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;
  const MapPickerScreen({super.key, this.initialLat, this.initialLng});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng? _selected;
  late GoogleMapController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    double lat = widget.initialLat ?? 0;
    double lng = widget.initialLng ?? 0;
    if (widget.initialLat == null || widget.initialLng == null) {
      final pos = await GeolocationService.getCurrentPosition(context: context);
      if (pos != null) {
        lat = pos.latitude;
        lng = pos.longitude;
      }
    }
    setState(() {
      _selected = LatLng(lat, lng);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _selected == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.select_point_on_map),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _selected!, zoom: 15),
        onMapCreated: (c) => _controller = c,
        markers: {
          Marker(markerId: const MarkerId('selected'), position: _selected!),
        },
        onTap: (LatLng pos) {
          setState(() {
            _selected = pos;
          });
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pop(_selected);
        },
        label: Text(AppLocalizations.of(context)!.select),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
