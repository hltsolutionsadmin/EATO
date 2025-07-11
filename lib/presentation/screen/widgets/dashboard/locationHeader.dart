import 'package:eato/presentation/screen/widgets/dashboard/LocationPermissionDialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class LocationHeader extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final VoidCallback onLocationChanged;
  final bool isGuest;

  const LocationHeader({
    this.latitude,
    this.longitude,
    required this.onLocationChanged,
    this.isGuest = false,
    super.key,
  });

  @override
  State<LocationHeader> createState() => _LocationHeaderState();
}

class _LocationHeaderState extends State<LocationHeader>
    with WidgetsBindingObserver {
  String _city = "";
  String _area = "";
  bool _isLoading = true;
  bool _shouldRetryLocation = false;
  bool _hasTriedFetchingLocation = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initLocationOnce();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _shouldRetryLocation) {
      setState(() => _isLoading = true);
      _fetchLocation();
    }
  }

  void _initLocationOnce() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchLocation();
    });
  }

  Future<void> _saveCoordinates(double lat, double lng) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('saved_latitude', lat);
    await prefs.setDouble('saved_longitude', lng);
    widget.onLocationChanged();
  }

  Future<void> _fetchLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      bool enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        _setError("Location Off", "Turn on location");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        _shouldRetryLocation = true;
        _setError("Permission Denied", "Go to settings to enable");
        await LocationPermissionDialog.show(context);
        return;
      }

      if (permission == LocationPermission.denied) {
        _setError("Permission Denied", "Location not available");
        return;
      }

      _shouldRetryLocation = false;

      Position? pos;
      try {
        pos = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
      } catch (e) {
        pos = await Geolocator.getLastKnownPosition();
      }

      if (pos != null) {
        await _saveCoordinates(pos.latitude, pos.longitude);
        await _getAddress(pos.latitude, pos.longitude);
      } else {
        _setError("Error", "Couldn't detect");
      }
    } catch (e) {
      _setError("Error", "Couldn't detect");
    }
  }

  void _setError(String city, String area) {
    if (!mounted) return;
    setState(() {
      _city = city;
      _area = area;
      _isLoading = false;
      _hasTriedFetchingLocation = true;
    });
  }

  Future<void> _getAddress(double lat, double lng) async {
    try {
      List<Placemark> places = await placemarkFromCoordinates(lat, lng);
      Placemark place = places.first;

      if (!mounted) return;
      setState(() {
        _city = place.locality ?? "Unknown";
        _area =
            "${place.subLocality ?? ''}, ${place.administrativeArea ?? ''} ${place.postalCode ?? ''}";
        _isLoading = false;
        _hasTriedFetchingLocation = true;
      });
    } catch (e) {
      _setError("Unknown", "Unable to fetch address");
    }
  }

  void _openAppSettings() async {
    _shouldRetryLocation = true;
    await Geolocator.openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.location_pin, color: Colors.white, size: 24),
        const SizedBox(width: 10),
        Expanded(
          child: _isLoading && !_hasTriedFetchingLocation
              ? _buildShimmer()
              : GestureDetector(
                  onTap: () {
                    if (_city == "Permission Denied") {
                      _openAppSettings();
                    } else if (_city == "Location Off" || _city == "Error") {
                      setState(() => _isLoading = true);
                      _fetchLocation();
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _city,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _area,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.white24,
      highlightColor: Colors.white54,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            height: 16,
            color: Colors.white,
          ),
          const SizedBox(height: 5),
          Container(
            width: 180,
            height: 12,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
