import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:udanpani/domain/models/job_model/job.dart';
import 'package:udanpani/services/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _geo = Geoflutterfire();

  Future<String> uploadNewJob({
    required String title,
    required String description,
    required Coordinates coordinates,
    required Uint8List photo,
  }) async {
    String res = "Something went wrong";

    try {
      String posterUid = _auth.currentUser!.uid;

      GeoFirePoint myLocation = _geo.point(
        latitude: coordinates.latitude,
        longitude: coordinates.longitude,
      );

      String jobID = Uuid().v1();

      String photoURL =
          await StorageMethods().uploadJobImageToStorage('jobs', photo, jobID);

      Job job = Job(
        title: title,
        description: description,
        posterUid: posterUid,
        geoHash: myLocation.data,
        photoUrl: photoURL,
        applicants: [],
      );

      await _firestore.collection('posts').doc(jobID).set(job.toJson());

      res = "success";
    } catch (e) {
      res = e.toString();
      print(res);
    }

    return res;
  }

//   Stream getJobsNearMe(Coordinates currentLocation) {
//     final lat = currentLocation.latitude;
//     final lon = currentLocation.longitude;

//     GeoFirePoint center = _geo.point(
//       latitude: lat,
//       longitude: lon,
//     );

// // get the collection reference or query
//     var collectionReference = _firestore.collection('posts');
//     double radius = 50;
//     String field = 'position';

//     Stream<List<DocumentSnapshot>> stream = _geo
//         .collection(collectionRef: collectionReference)
//         .within(center: center, radius: radius, field: field);

//     return stream;
//   }
}
