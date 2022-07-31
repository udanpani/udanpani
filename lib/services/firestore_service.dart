import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:udanpani/domain/models/job_model/job.dart';
import 'package:udanpani/domain/models/review/review.dart';
import 'package:udanpani/domain/models/user_model/user.dart' as udanpani;
import 'package:udanpani/services/rest_services.dart';
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
    required String price,
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

      String locationAsName = await RestServices()
          .geoCodeLocationFromCoordinates(
              coordinates.latitude, coordinates.longitude);

      Job job = Job(
        jobId: jobID,
        title: title,
        description: description,
        price: price,
        posterUid: posterUid,
        geoHash: myLocation.data,
        locationAsName: locationAsName,
        photoUrl: photoURL,
        applicants: [],
        status: "pending",
        workerReviewed: false,
        employerReviewed: false,
      );

      await _firestore.collection('posts').doc(jobID).set(job.toJson());

      res = "success";
    } catch (e) {
      res = e.toString();
      print(res);
    }

    return res;
  }

  Future<List<Review>> getReviews(List<String> reviewRef) async {
    List<Review> reviews = [];
    try {
      for (var review in reviewRef) {
        var data = await _firestore.collection('reviews').doc(review).get();
        if (data != null) {
          reviews.add(Review.fromJson((data.data() as Map<String, dynamic>)));
        }
      }
    } catch (e) {
      print(e);
    }

    return reviews;
  }

  Future<List<Review>> getReviewsForJob(String jobID) async {
    List<Review> reviews = [];
    var reviewRef = await _firestore
        .collection('reviews')
        .where("jobID", isEqualTo: jobID)
        .get();
    try {
      for (var review in reviewRef.docs) {
        var data = review.data();
        if (data != null) {
          reviews.add(Review.fromJson((data as Map<String, dynamic>)));
        }
      }
    } catch (e) {
      print(e);
    }

    return reviews;
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

    var data = await _firestore
        .collection("posts")
        .doc(docID)
        .get(const GetOptions(source: Source.server));

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

    var collectionReference =
        _firestore.collection('posts').where("status", isEqualTo: "pending");

    double radius = 15;
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
    The user's id is appended to the application list in job entry in "jobs" collection
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

  Future<String> withdrawJob(String jobID, {bool afterAccept = false}) async {
    String res = "Something went wrong";

    try {
      DocumentReference docRef =
          await _firestore.collection("posts").doc(jobID);

      var data = await docRef.get();

      Job job = Job.fromJson(data.data() as Map<String, dynamic>);

      List<String> currentList = [];

/*
    We have two places to store the applications. This is a redundancy.
    The user's id is appended to the application list in job entry in "jobs" collection
    The jobId is added to the user's entry in "applications"
    here, currentList is the list of userIds in applicants field of job.
    and currentApplicationList is the list of jobIds in the user's entry.
*/
      if (job.status != "pending" && afterAccept == false) {
        res = "Cannot withdraw application. Accepted applicant";
        return res;
      }

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

      if (afterAccept) {
        udanpani.User user = await getUser(_auth.currentUser!.uid);
        double newRating = user.rating! - 0.1;
        newRating = (newRating < 0) ? 0 : newRating;
        await _firestore
            .collection('users')
            .doc(user.uid)
            .update({"rating": newRating});

        await docRef.update(
          {
            "applicants": currentList,
            "acceptedApplicant": null,
            "status": "pending"
          },
        );
      } else {
        await docRef.update(
          {
            "applicants": currentList,
          },
        );
      }

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
      final doc = await _firestore
          .collection('users')
          .doc(uid)
          .get(GetOptions(source: Source.server));

      user = udanpani.User.fromJson(doc.data()!);
    } catch (e) {
      user = udanpani.User(
          username: e.toString(),
          name: "ERROR",
          email: "ERROR",
          phoneNumber: "ERROR");
    }

    return user;
  }

  Future<String> acceptApplicant(
      {required String jobID, required String applicantID}) async {
    String res = "Some error occured";

    try {
      final doc = await _firestore.collection('posts').doc(jobID);

      await doc
          .update({"acceptedApplicant": applicantID, "status": "accepted"});
      res = "success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> updateJobStatus({
    required String jobID,
    required String status,
  }) async {
    String res = "Some error occured";

    try {
      final doc = await _firestore.collection('posts').doc(jobID);

      await doc.update({"status": status});
      res = "success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> sendReview({
    required double stars,
    required String comment,
    required String reviewerUid,
    required String reviewedUid,
    required String jobID,
    String status = "paid",
    required int reviewer, // if worker then 0, if employer then 1
  }) async {
    String res = "Something went wrong";

    try {
      String uname = (await getUser(reviewerUid)).username;

      String uid = Uuid().v1();

      Review review = Review(
        reviewUid: uid,
        rating: stars,
        review: comment,
        reviewedUid: reviewedUid,
        reviewerUid: reviewerUid,
        jobID: jobID,
        reviewerUname: uname,
      );

      await _firestore.collection('reviews').doc(uid).set(review.toJson());

      var docRef = await _firestore.collection('users').doc(reviewedUid);

      var data = (await docRef.get()).data() as Map<String, dynamic>;
      udanpani.User user = udanpani.User.fromJson(data);
      List<String> reviews = [uid];

      if (user.reviews!.isNotEmpty) {
        reviews.addAll(user.reviews!);
      }
      double rating = (((user.rating! * user.noOfReviews!) + stars) /
          (user.noOfReviews! + 1).floor());

      docRef.update({
        "reviews": reviews,
        "rating": rating,
        "noOfReviews": user.noOfReviews! + 1,
      });

      final doc = await _firestore.collection('posts').doc(jobID);
      String reviewStatus =
          (reviewer == 0) ? "workerReviewed" : "employerReviewed";

      await doc.update({"status": status, reviewStatus: true});

      res = "success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<bool> checkForUsername(String username) async {
    try {
      var doc = await _firestore
          .collection('users')
          .where("username", isEqualTo: username)
          .get();
      if (doc.docs.isNotEmpty) {
        return true;
      }

      return false;
    } catch (e) {
      return true;
    }
  }

  Future<bool> checkForEmail(String email) async {
    try {
      var doc = await _firestore
          .collection('users')
          .where("email", isEqualTo: email)
          .get();
      if (doc.docs.isNotEmpty) {
        return true;
      }

      return false;
    } catch (e) {
      return true;
    }
  }

  Future<bool> checkForPhone(String phoneNumber) async {
    try {
      var doc = await _firestore
          .collection('users')
          .where("phoneNumber", isEqualTo: phoneNumber)
          .get();
      if (doc.docs.isNotEmpty) {
        return true;
      }

      return false;
    } catch (e) {
      return true;
    }
  }
}
