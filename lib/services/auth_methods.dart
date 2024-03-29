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
      required UserCredential cred,
      required Uint8List addressProof,
      required Uint8List file}) async {
    String res = "Some error occured";

    try {
      // UserCredential cred = await _auth.createUserWithEmailAndPassword(
      //     email: user.email, password: password);

      String photoUrl = await StorageMethods().uploadImageToStorage(
        'profilePics',
        file,
      );

      String proofUrl = await StorageMethods().uploadImageToStorage(
        'addressProofs',
        addressProof,
        suffix: user.verifications!,
      );

      await _firestore.collection('users').doc(cred.user!.uid).set(
            user
                .copyWith(
                    uid: cred.user!.uid,
                    profilePicture: photoUrl,
                    addressProof: proofUrl)
                .toJson(),
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

  Future<List> loginUser({
    required PhoneAuthCredential credential,
  }) async {
    String res = "Some error occured";
    UserCredential? cred;
    try {
      cred = await _auth.signInWithCredential(credential);
      res = "success";
    } on FirebaseAuthException catch (fberror) {
      res = fberror.code;
    } catch (err) {
      res = err.toString();
    }
    return [res, cred];
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
