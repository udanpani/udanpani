import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:udanpani/core/colors.dart';
import 'package:udanpani/infrastructure/utils.dart';
import 'package:udanpani/services/firestore_service.dart';
import 'package:udanpani/services/rest_services.dart';
import 'package:udanpani/widgets/text_input_field.dart';
import 'package:uuid/uuid.dart';

class AddNewJobScreen extends StatefulWidget {
  const AddNewJobScreen({Key? key}) : super(key: key);

  @override
  State<AddNewJobScreen> createState() => _AddNewJobScreenState();
}

class _AddNewJobScreenState extends State<AddNewJobScreen> {
  Uint8List? _file;
  final _titleEditingController = TextEditingController();
  final _descriptionEditingController = TextEditingController();
  final _locEditingController = TextEditingController(text: "Searching");
  Coordinates? _coordinates;

  late GoogleMapController _mapController;
  final Set<Marker> _mapMarkers = {};

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  String? _address;
  Icon _locationIcon = const Icon(
    Icons.location_disabled,
    color: primaryColor,
  );

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _titleEditingController.dispose();
    _descriptionEditingController.dispose();
    _locEditingController.dispose();
    _mapController.dispose();
  }

  void _pickImage() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);

                  Uint8List? file = await pickImage(ImageSource.camera);
                  setState(() {
                    if (file != null) {
                      _file = file;
                    }
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List? file = await pickImage(ImageSource.gallery);
                  setState(() {
                    if (file != null) {
                      _file = file;
                    }
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  Future<void> _getUserLocation() async {
    Location location = Location();

    // Check if location service is enable
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Check if permission is granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final locationData = await location.getLocation();
    final lat = locationData.latitude!.toDouble();
    final lon = locationData.longitude!.toDouble();
    _coordinates = Coordinates(lat, lon);

    _getAddress(lat, lon);

    _setMarker(
      LatLng(lat, lon),
    );

    _mapController
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lon), 18));
  }

  void _getAddress(double lat, double lon) async {
    String address = await RestServices().geoCodeFromCoordinates(
      lat,
      lon,
    );

    setState(() {
      _address = address;
      _locationIcon = const Icon(Icons.my_location, color: blueColor);

      _locEditingController.text = _address!;
    });
  }

  void _setMarker(LatLng coordinates) {
    _mapMarkers.clear();
    _coordinates = Coordinates(coordinates.latitude, coordinates.longitude);
    setState(() {
      _mapMarkers.add(
        Marker(
          markerId: MarkerId(const Uuid().v1()),
          position: coordinates,
        ),
      );

      _getAddress(coordinates.latitude, coordinates.longitude);
    });
  }

  void _postJob() async {
    if (_coordinates == null) {
      showSnackBar("Location could not be resolved", context);
      return;
    }

    if (_file == null) {
      showSnackBar("No file selected", context);
      return;
    }

    String res = await FirestoreMethods().uploadNewJob(
      title: _titleEditingController.text,
      description: _descriptionEditingController.text,
      coordinates: _coordinates!,
      photo: _file!,
    );
    if (res != "success") {
      showSnackBar(res, context);
      return;
    }
    showSnackBar("Post Success", context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post A New Job"),
        actions: [
          IconButton(
            onPressed: _postJob,
            icon: const Icon(
              Icons.done,
              color: blueColor,
            ),
          ),
        ],
        backgroundColor: mobileBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: _file != null
                  ? SizedBox(
                      height: 250,
                      child: Image(
                        image: MemoryImage(
                          _file!,
                        ),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      color: mobileSearchColor,
                      height: 250,
                      child: const Center(
                        child: Icon(Icons.add_a_photo_outlined),
                      ),
                    ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  TextFieldInput(
                    textEditingController: _titleEditingController,
                    hintText: "Enter a title",
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _descriptionEditingController,
                    decoration: InputDecoration(
                      hintText: "Enter a description",
                      border: OutlineInputBorder(
                          borderSide: Divider.createBorderSide(context)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: Divider.createBorderSide(context)),
                      filled: true,
                      contentPadding: const EdgeInsets.all(8),
                    ),
                    maxLines: 5,
                    maxLength: 300,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Stack(
                    children: [
                      TextFieldInput(
                        textEditingController: _locEditingController,
                        hintText: "Location",
                        textInputType: TextInputType.streetAddress,
                      ),
                      Positioned(
                        right: 5,
                        child: IconButton(
                          onPressed: _getUserLocation,
                          icon: _locationIcon,
                          splashRadius: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            SizedBox(
              height: 300,
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(24.142, -110.321),
                  zoom: 15,
                ),
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                  Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer(),
                  ),
                },
                onMapCreated: _onMapCreated,
                tiltGesturesEnabled: false,
                myLocationEnabled: true,
                mapType: MapType.hybrid,
                markers: _mapMarkers,
                onLongPress: _setMarker,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
