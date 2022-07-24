import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:udanpani/domain/models/user_model/user.dart' as model;
import 'package:udanpani/services/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromJson(snap.data() as Map<String, dynamic>);
  }

  Future<String> signUpUser(
      {required model.User user,
      required String password,
      Uint8List? file}) async {
    String res = "Some error occured";

    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: user.email, password: password);

      String photoUrl = await StorageMethods().uploadImageToStorage(
        'profilePics',
        file!,
      );

      await _firestore.collection('users').doc(cred.user!.uid).set(
            user.copyWith(profilePicture: photoUrl).toJson(),
          );

      await _firestore
          .collection('applications')
          .doc(_auth.currentUser!.uid)
          .set(
        {
          "jobs_applied": [],
        },
      );

      res = "success";
    } on FirebaseAuthException catch (fberror) {
      res = fberror.code;
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      res = "success";
    } on FirebaseAuthException catch (fberror) {
      res = fberror.code;
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> signoutUser() async {
    String res = "Some error occured";

    try {
      await _auth.signOut();
      res = "success";
    } on FirebaseAuthException catch (fberror) {
      res = fberror.code;
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
