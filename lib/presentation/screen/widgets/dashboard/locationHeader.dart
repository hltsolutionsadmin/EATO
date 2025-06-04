import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationHeader extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final VoidCallback onLocationChanged;

  const LocationHeader({
    this.latitude, 
    this.longitude, 
    required this.onLocationChanged,
    super.key
  });

  @override
  _LocationHeaderState createState() => _LocationHeaderState();
}

class _LocationHeaderState extends State<LocationHeader> {
  String _fetchedLocation = "Fetching location...";
  String _userEnteredText = "";

  @override
  void initState() {
    super.initState();
    if (widget.latitude != null && widget.longitude != null) {
      _getAddressFromCoordinates(widget.latitude!, widget.longitude!);
    } else {
      _fetchLocation();
    }
  }

  Future<void> _saveCoordinates(double lat, double lng) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('saved_latitude', lat);
    await prefs.setDouble('saved_longitude', lng);
    widget.onLocationChanged();
  }

  Future<void> _fetchLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _fetchedLocation = "Location services are disabled.";
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _fetchedLocation = "Location permissions are denied.";
        });
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _fetchedLocation = "Location permissions are permanently denied.";
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    await _saveCoordinates(position.latitude, position.longitude);
    await _getAddressFromCoordinates(position.latitude, position.longitude);
  }

  Future<void> _getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      print("latitude: $latitude");
      print("longitude: $longitude");
      setState(() {
        _fetchedLocation =
            "${place.locality}, ${place.administrativeArea}, ${place.postalCode}";
      });
    } catch (e) {
      setState(() {
        _fetchedLocation = "Error getting address.";
      });
    }
  }

  Future<void> _manualEnterLocation() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        String tempLocation = '';
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            'Enter Your Pincode or Address',
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            onChanged: (value) {
              tempLocation = value;
            },
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter Pincode or City Name',
              hintStyle: TextStyle(color: Colors.white54),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.greenAccent),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.greenAccent, width: 2),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
              ),
              onPressed: () {
                Navigator.pop(context, tempLocation);
              },
              child: Text(
                'Find',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );

    if (result != null && result.trim().isNotEmpty) {
      _userEnteredText = result.trim();
      await _getLocationFromAddress(result.trim());
    }
  }

  Future<void> _getLocationFromAddress(String inputAddress) async {
    try {
      List<Location> locations = await locationFromAddress(inputAddress);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        print("Entered Latitude: ${location.latitude}");
        print("Entered Longitude: ${location.longitude}");
        await _saveCoordinates(location.latitude, location.longitude);
        await _getAddressFromCoordinates(location.latitude, location.longitude);
      } else {
        setState(() {
          _fetchedLocation = "Location not found.";
        });
      }
    } catch (e) {
      setState(() {
        _fetchedLocation = "Error finding location.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _manualEnterLocation,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.greenAccent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on_outlined,
              color: Colors.greenAccent,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Location",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _userEnteredText.isNotEmpty
                      ? '$_userEnteredText\n$_fetchedLocation'
                      : _fetchedLocation,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
