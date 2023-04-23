import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> getFaceName(String faceId) async {
    final collectionId = _auth.currentUser!.uid;

    final compressedFaceName =
        await _firestore.collection(collectionId).doc(faceId).get();
    final List<int> decompress =
        gzip.decode(compressedFaceName.data()!['name'].cast<int>());
    final String decoded = utf8.decode(decompress);

    log('got from fb: $decoded');
    return decoded;
  }

  void addFaceIdToCollection(String faceId, String name) async {
    final gzip = GZipCodec();
    final collectionId = _auth.currentUser!.uid;
    // Map<String, String> map = {'name': name};
    final List<int> original = utf8.encode(name);
    final List<int> compressed = gzip.encode(original);
    log(compressed.toString());
    final DocumentReference doc =
        _firestore.collection(collectionId).doc(faceId);
    doc.set({'name': compressed});
    log('added the faceId to the database');
  }
}
