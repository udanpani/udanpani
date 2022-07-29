import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:udanpani/domain/models/job_model/job.dart';
import 'package:udanpani/domain/models/user_model/user.dart' as udanpani;
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
    String? uid,
  }) async {
    String res = "Something went wrong";

    try {
      String posterUid = _auth.currentUser!.uid;

      GeoFirePoint myLocation = _geo.point(
        latitude: coordinates.latitude,
        longitude: coordinates.longitude,
      );

      String jobID = uid ?? Uuid().v1();

      String photoURL =
          await StorageMethods().uploadJobImageToStorage('jobs', photo, jobID);

      Job job = Job(
        jobId: jobID,
        title: title,
        description: description,
        posterUid: posterUid,
        geoHash: myLocation.data,
        photoUrl: photoURL,
        applicants: [],
        status: "pending",
      );

      await _firestore.collection('posts').doc(jobID).set(job.toJson());

      res = "success";
    } catch (e) {
      res = e.toString();
      print(res);
    }

    return res;
  }

  Future<List<Job>> getMyJobs() async {
    List<Job> _jobs = [];
    print("Getting jobs");

    var snap = await _firestore
        .collection("posts")
        .where("posterUid", isEqualTo: _auth.currentUser!.uid)
        .get();
    for (var job in snap.docs) {
      print("Casting Jobs");
      _jobs.add(
        Job.fromJson(
          job.data(),
        ),
      );
    }

    return _jobs;
  }

  Future<Job> getJob(String docID) async {
    print("Getting jobs");

    var data = await _firestore.collection("posts").doc(docID).get();

    Job job = Job.fromJson(data.data()!);

    return job;
  }

  Future<List<Job>> getAppliedJobs() async {
    List<Job> jobs = [];

    var appliedJobs = await _firestore
        .collection('applications')
        .doc(_auth.currentUser!.uid)
        .get();

    var jobIds = List<String>.from(
        (appliedJobs.data() as Map<String, dynamic>)["jobs_applied"]);

    for (var job in jobIds) {
      jobs.add(await getJob(job));
    }
    return jobs;
  }

  Stream<List<DocumentSnapshot>> getJobsNearMe(Coordinates currentLocation) {
    final lat = currentLocation.latitude;
    final lon = currentLocation.longitude;

    GeoFirePoint center = _geo.point(
      latitude: lat,
      longitude: lon,
    );

    // get the collection reference or query

    var collectionReference = _firestore.collection('posts');

    double radius = 50;
    String field = 'geoHash';

    Stream<List<DocumentSnapshot>> stream = _geo
        .collection(collectionRef: collectionReference)
        .within(center: center, radius: radius, field: field);

    return stream;
  }

  Future<String> acceptJob(String jobID) async {
    String res = "Something went wrong";

    try {
      DocumentReference docRef =
          await _firestore.collection("posts").doc(jobID);

      var data = await docRef.get();

      Job job = Job.fromJson(data.data() as Map<String, dynamic>);

      List<String> currentList = [];

/*
    We have two places to store the applications. This is a redundancy.
    The user's id is appended to the application list in job entry in "posts" collection
    The jobId is added to the user's entry in "applications"
    here, currentList is the list of userIds in applicants field of job.
    and currentApplicationList is the list of jobIds in the user's entry.
*/

      if (job.applicants != null) {
        currentList.addAll(job.applicants!);
      }

      currentList.add(_auth.currentUser!.uid);
      currentList = currentList.toSet().toList();

      DocumentReference appDoc = await _firestore
          .collection('applications')
          .doc(_auth.currentUser!.uid);

      var applications = await appDoc.get();
      List<String> currentApplicationList = [];

      //todo refactor to use list from
      if ((applications.data() as Map<String, dynamic>)["jobs_applied"] !=
          null) {
        List<dynamic> list =
            (applications.data() as Map<String, dynamic>)["jobs_applied"];
        list.forEach((element) {
          currentApplicationList.add(element);
        });
      }

      currentApplicationList.add(jobID);
      currentApplicationList = currentApplicationList.toSet().toList();
      // update lists
      await docRef.update(
        {"applicants": currentList},
      );
      await appDoc.update({"jobs_applied": currentApplicationList});

      res = "success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> withdrawJob(String jobID) async {
    String res = "Something went wrong";

    try {
      DocumentReference docRef =
          await _firestore.collection("posts").doc(jobID);

      var data = await docRef.get();

      Job job = Job.fromJson(data.data() as Map<String, dynamic>);

      List<String> currentList = [];

/*
    We have two places to store the applications. This is a redundancy.
    The user's id is appended to the application list in job entry in "posts" collection
    The jobId is added to the user's entry in "applications"
    here, currentList is the list of userIds in applicants field of job.
    and currentApplicationList is the list of jobIds in the user's entry.
*/

      if (job.applicants != null) {
        currentList.addAll(job.applicants!);
      }

      currentList.remove(_auth.currentUser!.uid);
      currentList = currentList.toSet().toList();

      DocumentReference appDoc = await _firestore
          .collection('applications')
          .doc(_auth.currentUser!.uid);

      var applications = await appDoc.get();
      List<String> currentApplicationList = [];

      // todo use list from
      if ((applications.data() as Map<String, dynamic>)["jobs_applied"] !=
          null) {
        List<dynamic> list =
            (applications.data() as Map<String, dynamic>)["jobs_applied"];
        list.forEach((element) {
          currentApplicationList.add(element);
        });
      }

      currentApplicationList.remove(jobID);
      currentApplicationList = currentApplicationList.toSet().toList();
      // update lists
      await docRef.update(
        {"applicants": currentList},
      );
      await appDoc.update({"jobs_applied": currentApplicationList});

      res = "success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<udanpani.User> getUser(String uid) async {
    udanpani.User user;

    try {
      final doc = await _firestore.collection('users').doc(uid).get();

      user = udanpani.User.fromJson(doc.data()!);
    } catch (e) {
      user =
          udanpani.User(username: e.toString(), name: "ERROR", email: "ERROR");
    }

    return user;
  }

  Future<String> acceptApplicant(
      {required String jobID, required String applicantID}) async {
    String res = "Some error occured";

    try {
      final doc = await _firestore.collection('posts').doc(jobID);

      await doc.update({"acceptedApplicant": applicantID});
      res = "success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }
}
