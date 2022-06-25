import 'dart:html';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:udanpani/domain/models/job_model/job.dart';
import 'package:udanpani/services/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadNewJob({
    required String title,
    required String description,
    required String locX,
    required String locY,
    required Uint8List photo,
  }) async {
    String res = "Something went wrong";

    try {
      String posterUid = _auth.currentUser!.uid;

      String jobID = Uuid().v1();

      String photoURL =
          await StorageMethods().uploadJobImageToStorage('jobs', photo, jobID);

      Job job = Job(
        title: title,
        description: description,
        posterUid: posterUid,
        locX: locX,
        locY: locY,
        applicants: [],
      );

      await _firestore.collection('posts').doc(jobID).set(job.toJson());
    } catch (e) {}

    return res;
  }
}
