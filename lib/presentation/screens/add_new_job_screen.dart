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
import 'package:udanpani/core/constants.dart';
import 'package:udanpani/infrastructure/utils.dart';
import 'package:udanpani/services/firestore_service.dart';
import 'package:udanpani/services/rest_services.dart';
import 'package:udanpani/widgets/text_input_field.dart';
import 'package:udanpani/widgets/textforminput.dart';
import 'package:uuid/uuid.dart';

class AddNewJobScreen extends StatefulWidget {
  const AddNewJobScreen({Key? key}) : super(key: key);

  @override
  State<AddNewJobScreen> createState() => _AddNewJobScreenState();
}

class _AddNewJobScreenState extends State<AddNewJobScreen> {
  Uint8List? _file;
  final _titleEditingController = TextEditingController();
  final _priceEditingController = TextEditingController();
  final _descriptionEditingController = TextEditingController();
  final _locEditingController = TextEditingController(text: "Searching");
  final List<TextEditingController> _controller =
      List.generate(5, (i) => TextEditingController());

  Coordinates? _coordinates;

  bool _isLoading = false;

  late GoogleMapController _mapController;
  final Set<Marker> _mapMarkers = {};

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  String? _address;
  Icon _locationIcon = const Icon(
    Icons.location_disabled,
    color: primaryColor,
  );

  String jobName = "Other";
  String? dropdownValue;
  String? jobtype;
  DateTime? _selectedDate;

  final _formKey = GlobalKey<FormState>();

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
    _priceEditingController.dispose();
    _descriptionEditingController.dispose();
    _locEditingController.dispose();
    _mapController.dispose();
    for (var controller in _controller) {
      controller.dispose();
    }
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

  _buildDescriptionFields(jobName) {
    switch (jobName) {
      case 'Cleaning':
        return Column(children: [
          // do dropdown

          DropdownButton<String>(
            value: dropdownValue,
            hint: const Text('select type'),
            underline: Container(),
            icon: const Icon(Icons.arrow_downward),
            iconSize: 18.0, // can be changed, default: 24.0
            iconEnabledColor: Colors.white,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items: cleanListDropdownMenuItems,
          ),
          const SizedBox(
            height: 10,
          ),

          TextFieldInput(
            hintText: "Approximate Area",
            textEditingController: _controller[0],
            textInputType: TextInputType.text,
          ),
          TextFieldInput(
            hintText: "Details (Optional)",
            textEditingController: _descriptionEditingController,
            textInputType: TextInputType.text,
          ),
          const SizedBox(
            height: 30,
          ),

          //add date

          /* if(_selectedDate==null)
         TextButton.icon(onPressed: () async{
         final _selectedDateTemp= await showDatePicker(context: context, 
          initialDate: DateTime.now(),
          firstDate: 
          DateTime.now().subtract(const Duration (days: 31)),
           lastDate: DateTime.now(),);
           if(_selectedDateTemp==null){
            return;
           }
           
           else{
            setState(() {
              _selectedDate=_selectedDateTemp;
            });
            
           }
         }, 
         icon: const Icon(Icons.calendar_today,
         color: Colors.white,
         ),
         
         label:const Text('Select date',
         style: TextStyle(color: Colors.white)),
         )
         
         else
         
          Text(_selectedDate.toString(),),
          */
        ]);

      case 'Vehicle Wash':
        return Column(children: [
          // do dropdown
          DropdownButton<String>(
            value: dropdownValue,
            hint: const Text('select Vehicle type'),
            underline: Container(),
            icon: const Icon(Icons.arrow_downward),
            iconSize: 18.0, // can be changed, default: 24.0
            iconEnabledColor: Colors.white,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items: vehicleListDropdownMenuItems,
          ),
          const SizedBox(
            height: 10,
          ),

          TextFieldInput(
            hintText: "Details (Optional)",
            textEditingController: _descriptionEditingController,
            textInputType: TextInputType.text,
          ),
        ]);

      case 'Driving':
        return Column(children: [
          // do dropdown

          DropdownButton<String>(
            value: dropdownValue,
            hint: const Text('select Vehicle type'),
            underline: Container(),
            icon: const Icon(Icons.arrow_downward),
            iconSize: 18.0, // can be changed, default: 24.0
            iconEnabledColor: Colors.white,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items: vehicleListDropdownMenuItems,
          ),
          const SizedBox(
            height: 10,
          ),

          TextFieldInput(
            hintText: "Distance in kms",
            textEditingController: _controller[0],
            textInputType: TextInputType.number,
          ),

          TextFieldInput(
            hintText: "Details (Optional)",
            textEditingController: _descriptionEditingController,
            textInputType: TextInputType.text,
          ),
        ]);

      case 'Basic Electronic and Electrical Services':
        return Column(children: [
          // do dropdown

          DropdownButton<String>(
            value: dropdownValue,
            hint: const Text('Select Work'),
            underline: Container(),
            icon: const Icon(Icons.arrow_downward),
            iconSize: 18.0, // can be changed, default: 24.0
            iconEnabledColor: Colors.white,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items: electronicListDropdownMenuItems,
          ),
          const SizedBox(
            height: 10,
          ),

          TextFieldInput(
            hintText: "Details (Optional)",
            textEditingController: _descriptionEditingController,
            textInputType: TextInputType.text,
          ),
        ]);

      case 'Manpower':
        return Column(children: [
          // do dropdown

          Row(
            children: [
              Radio(
                  value: "Shifting",
                  groupValue: jobtype,
                  onChanged: (value) {
                    setState(() {
                      jobtype = value.toString();
                    });
                  }),
              const Text("Shifting"),
              Radio(
                  value: "Others",
                  groupValue: jobtype,
                  onChanged: (value) {
                    setState(() {
                      jobtype = value.toString();
                    });
                  }),
              const Text("Others")
            ],
          ),

          TextFieldInput(
            hintText: "Details (Optional)",
            textEditingController: _descriptionEditingController,
            textInputType: TextInputType.text,
          ),
        ]);

      case 'Grass Trimming/Mowing':
        return Column(children: [
          // do dropdown
          TextFieldInput(
            hintText: "Details (Optional)",
            textEditingController: _descriptionEditingController,
            textInputType: TextInputType.text,
          ),
        ]);

      case 'Caretaking':
        return Column(children: [
          // do dropdown
          Row(
            children: [
              Radio(
                  value: "Children",
                  groupValue: jobtype,
                  onChanged: (value) {
                    setState(() {
                      jobtype = value.toString();
                    });
                  }),
              const Text("Children"),
              Radio(
                  value: "Old Age",
                  groupValue: jobtype,
                  onChanged: (value) {
                    setState(() {
                      jobtype = value.toString();
                    });
                  }),
              const Text("Old Age"),
              Radio(
                  value: "Sick",
                  groupValue: jobtype,
                  onChanged: (value) {
                    setState(() {
                      jobtype = value.toString();
                    });
                  }),
              const Text("Sick")
            ],
          ),

          TextFieldInput(
            hintText: "Age",
            textEditingController: _controller[0],
            textInputType: TextInputType.text,
          ),
          TextFieldInput(
            hintText: "Gender",
            textEditingController: _controller[1],
            textInputType: TextInputType.text,
          ),
          TextFieldInput(
            hintText: "Details (Optional)",
            textEditingController: _descriptionEditingController,
            textInputType: TextInputType.text,
          ),
        ]);

      default:
        return Column(children: [
          TextFieldInput(
            hintText: "Details",
            textEditingController: _descriptionEditingController,
            textInputType: TextInputType.text,
          ),
        ]);
    }
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

    if (!mounted) return;
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

  String _makeDescription() {
    String desc = "";

    if (jobName != "Other") {
      desc += jobName;
    }
    if (dropdownValue != null) {
      desc += "\n" + dropdownValue!;
    }
    if (jobtype != "Others" && jobtype != null) {
      desc += "\n" + jobtype!;
    }

    for (var controller in _controller) {
      if (controller != null && controller.text.isNotEmpty) {
        desc += "\n" + controller.text;
      }
    }

    if (_descriptionEditingController != null &&
        _descriptionEditingController.text.isNotEmpty) {
      desc += "\n" + _descriptionEditingController.text;
    }

    return desc;
  }

  void _postJob() async {
    if (!_formKey.currentState!.validate()) {
      showSnackBar("All marked fields are mandatory", context);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    if (_titleEditingController.text.isEmpty ||
        _priceEditingController.text.isEmpty) {
      showSnackBar("All marked fields are mandatory", context);

      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (_coordinates == null) {
      showSnackBar("Location could not be resolved", context);

      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (_file == null) {
      showSnackBar("No image selected", context);

      setState(() {
        _isLoading = false;
      });
      return;
    }

    String description = _makeDescription();

    String res = await FirestoreMethods().uploadNewJob(
      title: _titleEditingController.text,
      description: description,
      price: _priceEditingController.text,
      coordinates: _coordinates!,
      photo: _file!,
    );

    if (res != "success") {
      showSnackBar(res, context);
      return;
    }

    setState(() {
      _isLoading = false;
    });

    showSnackBar("Post Success", context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post A New Job"),
        actions: [
          !_isLoading
              ? IconButton(
                  onPressed: () {
                    if (!_isLoading) {
                      _postJob();
                    }
                  },
                  icon: const Icon(
                    Icons.done,
                    color: blueColor,
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    TextFormInput(
                      textEditingController: _titleEditingController,
                      hintText: "Enter a title",
                      textInputType: TextInputType.text,
                    ),
                    const SizedBox(height: 20),
                    TextFormInput(
                      textEditingController: _priceEditingController,
                      hintText: "Expected Wage",
                      textInputType: TextInputType.number,
                      isNumber: true,
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Add Optional Details",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: DropdownButtonFormField<String>(
                        hint: Text('Select Job To Add Details'),
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 18.0,
                        iconEnabledColor: Colors.white,
                        onChanged: (newValue) {
                          for (var controller in _controller) {
                            controller.text = "";
                          }
                          setState(() {
                            jobtype = null;
                            dropdownValue = null;
                            jobName = newValue as String;
                          });
                        },
                        items: jobListDropdownMenuItems,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    _buildDescriptionFields(jobName),
                    const SizedBox(
                      height: 30,
                    ),

                    // const SizedBox(height: 20),
                    // TextField(
                    //   controller: _descriptionEditingController,
                    //   decoration: InputDecoration(
                    //     hintText: "Enter a description",
                    //     border: OutlineInputBorder(
                    //         borderSide: Divider.createBorderSide(context)),
                    //     enabledBorder: OutlineInputBorder(
                    //         borderSide: Divider.createBorderSide(context)),
                    //     filled: true,
                    //     contentPadding: const EdgeInsets.all(8),
                    //   ),
                    //   maxLines: 5,
                    //   maxLength: 300,
                    //   maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    // ),
                    // const SizedBox(
                    //   height: 30,
                    // ),
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
