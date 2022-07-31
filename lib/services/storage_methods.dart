import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Uint8List> compressImage(Uint8List list) async {
    var result = await FlutterImageCompress.compressWithList(
      list,
      quality: 50,
    );
    return result;
  }

  Future<String> uploadImageToStorage(
    String childName,
    Uint8List image, {
    String suffix = "",
  }) async {
    //compress image;
    final file = await compressImage(image);
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid + suffix);
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;
  }

  //todo implement multiple photos in post
  Future<String> uploadJobImageToStorage(
    String childName,
    Uint8List image,
    String postID,
  ) async {
    //compress image;
    final file = await compressImage(image);

    Reference ref = _storage.ref().child(childName).child(postID);

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;
  }
}
