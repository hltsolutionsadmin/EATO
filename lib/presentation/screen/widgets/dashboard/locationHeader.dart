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

  const LocationHeader({
    this.latitude,
    this.longitude,
    required this.onLocationChanged,
    super.key,
  });

  @override
  State<LocationHeader> createState() => _LocationHeaderState();
}

class _LocationHeaderState extends State<LocationHeader> {
  String _city = "";
  String _area = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initLocationOnce();
  }

  void _initLocationOnce() async {
    if (widget.latitude != null && widget.longitude != null) {
      await _getAddress(widget.latitude!, widget.longitude!);
    } else {
      await _fetchLocation();
    }
  }

  Future<void> _saveCoordinates(double lat, double lng) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('saved_latitude', lat);
    await prefs.setDouble('saved_longitude', lng);
    widget.onLocationChanged();
  }

  Future<void> _fetchLocation() async {
    try {
      bool enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        setState(() {
          _city = "Location Off";
          _isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.always &&
            permission != LocationPermission.whileInUse) {
          setState(() {
            _city = "Permission Denied";
            _isLoading = false;
          });
          return;
        }
      }

      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await _saveCoordinates(pos.latitude, pos.longitude);
      await _getAddress(pos.latitude, pos.longitude);
    } catch (e) {
      setState(() {
        _city = "Error";
        _area = "Couldn't detect";
        _isLoading = false;
      });
    }
  }

  Future<void> _getAddress(double lat, double lng) async {
    try {
      List<Placemark> places = await placemarkFromCoordinates(lat, lng);
      Placemark place = places.first;

      setState(() {
        _city = place.locality ?? "Unknown";
        _area =
            "${place.subLocality ?? ''}, ${place.administrativeArea ?? ''} ${place.postalCode ?? ''}";
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _city = "Unknown";
        _area = "Unable to fetch address";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16)
          .copyWith(top: 18, bottom: 10),
      child: Row(
        children: [
          const Icon(Icons.location_pin, color: Colors.white, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: _isLoading
                ? _buildShimmer()
                : Column(
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
        ],
      ),
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
