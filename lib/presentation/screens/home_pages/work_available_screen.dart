import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:udanpani/core/colors.dart';
import 'package:udanpani/infrastructure/utils.dart';
import 'package:udanpani/presentation/screens/applied_jobs_screen.dart';
import 'package:udanpani/presentation/screens/job_details_screen.dart';
import 'package:udanpani/presentation/screens/op_job_actions_screen.dart';
import 'package:udanpani/services/firestore_service.dart';

class WorkAvailable extends StatefulWidget {
  const WorkAvailable({Key? key}) : super(key: key);

  @override
  State<WorkAvailable> createState() => _WorkAvailableState();
}

class _WorkAvailableState extends State<WorkAvailable> {
  Stream<List<DocumentSnapshot>>? stream;
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;

  Coordinates? _coordinates;

  @override
  void initState() {
    super.initState();
    _getJobs();
  }

  void _getJobs() async {
    if (!mounted) return;
    await _getUserLocation();
    if (_coordinates != null) {
      setState(() {
        stream = FirestoreMethods().getJobsNearMe(_coordinates!);
      });
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
  }

  void showDetails(
      /* takes in job */ int
          index /* showing that data is being transferred*/) {
    Navigator.pushNamed(
      context,
      '/job',
      arguments: index,
    );
  }

  void _navigateToDetails(jobID) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobDetailsScreen(
          id: jobID,
        ),
      ),
    );
  }

  void _navigateToAppliedJobs() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppliedJobsScreen(),
      ),
    );
  }

  void _navigateToJobActions() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => JobActions()));
  }

  Widget _availableWork() {
    if (stream != null) {
      return StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              final _auth = FirebaseAuth.instance;
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data![index];
                    final data = doc.data() as Map<String, dynamic>;
                    return ListTile(
                      onTap: () {
                        final jobID = doc.id;
                        if (data["posterUid"] == _auth.currentUser!.uid) {
                          _navigateToJobActions();
                          return;
                        }
                        _navigateToDetails(jobID);
                      },
                      leading: CircleAvatar(
                        backgroundColor: primaryColor,
                        backgroundImage: NetworkImage(data['photoUrl']),
                      ),
                      title: Text("${data['title']}"),
                      subtitle: Text("location"),
                      trailing: Text("000"),
                    );
                  });
            } else if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.error}"),
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    //   return _availableWork();
    // }

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, right: 5),
            color: mobileBackgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Jobs nearby",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                IconButton(
                  onPressed: () {
                    _navigateToAppliedJobs();
                  },
                  splashRadius: 1,
                  icon: const Icon(Icons.email),
                )
              ],
            ),
          ),
          Expanded(child: _availableWork()),
        ],
      ),
    );
  }
}
