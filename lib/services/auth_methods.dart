import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:udanpani/domain/models/user.dart' as model;
import 'package:udanpani/services/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpUser({required model.User user, Uint8List? file}) async {
    String res = "Some error occured";

    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);

      //todo handle if file is null

      String photoUrl = await StorageMethods()
          .uploadImageToStorage('profilePics', file!, false);

      await _firestore.collection('users').doc(cred.user!.uid).set(
            user.copyWith(profilePicture: photoUrl).toJson(),
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
}
