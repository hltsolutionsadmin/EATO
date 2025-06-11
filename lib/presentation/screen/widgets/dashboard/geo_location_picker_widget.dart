import 'package:eato/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationPickerPage extends StatefulWidget {
  final void Function(LatLng, Placemark)? onLocationSelected;

  const LocationPickerPage({Key? key, this.onLocationSelected})
      : super(key: key);

  @override
  _LocationPickerPageState createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  LatLng? _selectedLocation;
  String _address = 'Fetching address...';
  Placemark? _currentPlacemark;
  bool _isLoading = false;

  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    setState(() => _isLoading = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location services are disabled')),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Location permissions are permanently denied')),
        );
        return;
      }

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final currentLocation = LatLng(position.latitude, position.longitude);

      setState(() {
        _selectedLocation = currentLocation;
      });

      _mapController.move(currentLocation, 15.0);
      await _getAddressFromLatLng(currentLocation);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    setState(() {
      _address = 'Fetching address...';
      _isLoading = true;
    });

    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _currentPlacemark = place;
          _address = [
            place.street,
            place.locality,
            place.administrativeArea,
            place.country
          ].where((part) => part?.isNotEmpty ?? false).join(', ');
        });
      }
    } catch (e) {
      setState(() => _address = 'Failed to fetch address');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onMapTap(LatLng point) {
    setState(() {
      _selectedLocation = point;
      _address = 'Fetching address...';
    });
    _getAddressFromLatLng(point);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pick Location"),
        actions: [
          if (_selectedLocation != null && !_isLoading)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                if (_selectedLocation != null && _currentPlacemark != null) {
                  widget.onLocationSelected
                      ?.call(_selectedLocation!, _currentPlacemark!);
                  Navigator.pop(context);
                }
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _selectedLocation ?? LatLng(20.5937, 78.9629),
              zoom: 5.0,
              onTap: (tapPosition, point) => _onMapTap(point),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              if (_selectedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedLocation!,
                      width: 80,
                      height: 80,
                      child: Icon(
                        Icons.location_pin,
                        size: 40,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          if (_isLoading) Center(child: CircularProgressIndicator()),
          if (_selectedLocation != null && !_isLoading)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Card(
                elevation: 2,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_pin, color: Colors.red, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Selected Location',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColor.PrimaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow('Latitude:',
                                _selectedLocation!.latitude.toStringAsFixed(6)),
                            SizedBox(height: 6),
                            _buildDetailRow(
                                'Longitude:',
                                _selectedLocation!.longitude
                                    .toStringAsFixed(6)),
                            SizedBox(height: 8),
                            Divider(height: 1),
                            SizedBox(height: 8),
                            Text(
                              'Address:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              _address,
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.PrimaryColor,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            if (_selectedLocation != null &&
                                _currentPlacemark != null) {
                              widget.onLocationSelected?.call(
                                  _selectedLocation!, _currentPlacemark!);
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            'Use This Location',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

Widget _buildDetailRow(String label, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
          fontSize: 14,
        ),
      ),
      SizedBox(width: 8),
      Expanded(
        child: Text(
          value,
          style: TextStyle(fontSize: 14),
        ),
      ),
    ],
  );
}
