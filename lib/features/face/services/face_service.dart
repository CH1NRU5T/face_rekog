import 'dart:developer';

import 'package:aws_rekognition_api/rekognition-2016-06-27.dart' as aws;
import 'package:face_rekog/constants/utils.dart';
import 'package:face_rekog/env/env.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../firebase/services/firebase_services.dart';

class FaceService {
  FirebaseServices firebaseServices = FirebaseServices();

  final picker = ImagePicker();
  final service = aws.Rekognition(
    region: 'eu-west-1',
    credentials: aws.AwsClientCredentials(
        accessKey: Env.accessKey, secretKey: Env.secretKey),
  );

  void createCollection() async {
    final list = await service.listCollections();
    if (list.collectionIds!.contains(FirebaseAuth.instance.currentUser!.uid)) {
      log('collection already exists');
      final res = await service.listFaces(
          collectionId: FirebaseAuth.instance.currentUser!.uid);
      log('faces already in the collection = ${res.faces!.length}');
      return;
    }
    await service.createCollection(
        collectionId: FirebaseAuth.instance.currentUser!.uid);
    log('created collection ${FirebaseAuth.instance.currentUser!.uid}');
  }

  void deleteAllFacesFromCollection({required String collectionId}) async {
    aws.ListFacesResponse facesRes =
        await service.listFaces(collectionId: collectionId);
    List<String> faceIds = [];
    for (var element in facesRes.faces!) {
      faceIds.add(element.faceId!);
    }
    await service.deleteFaces(collectionId: collectionId, faceIds: faceIds);
    log('deleted all the faces in collection: $collectionId');
  }

  Future<aws.SearchFacesByImageResponse?> searchImage(
      {required String collectionId,
      required XFile imageToSearch,
      required BuildContext context}) async {
    aws.SearchFacesByImageResponse? searchResponse;
    try {
      final image = imageToSearch;
      searchResponse = await service.searchFacesByImage(
        collectionId: collectionId,
        image: aws.Image(
          bytes: await image.readAsBytes(),
        ),
      );

      return searchResponse;
    } on aws.InvalidParameterException catch (e) {
      showSnackBar(context, '${e.message}');
      return searchResponse;
    } catch (e) {
      showSnackBar(context, e.toString());
      return searchResponse;
    }
  }

  Future<void> indexFaces(
      {required String collectionId,
      required String name,
      required BuildContext context,
      XFile? imagePassed}) async {
    final image = imagePassed;

    // search if the face already exists in the aws collection
    final searchImageResponse = await searchImage(
        collectionId: collectionId, imageToSearch: image!, context: context);
    if (searchImageResponse == null) return;
    if (searchImageResponse.faceMatches!.isEmpty) {
      aws.IndexFacesResponse indexFacesResponse = await service.indexFaces(
        collectionId: collectionId,
        image: aws.Image(
          bytes: await image.readAsBytes(),
        ),
      );
      log('face not found in db, adding it');
      firebaseServices.addFaceIdToCollection(
        indexFacesResponse.faceRecords!.first.face!.faceId!,
        name,
      );
      return;
    }
    log('face found in db');
    // get the faceID of the that was matched in aws collection
    final matchedFaceId = searchImageResponse.faceMatches!.first.face!.faceId;
    log('matchedFaceId: $matchedFaceId');
    // get the name of the face from firebase using the faceID
    String faceFoundName = await firebaseServices.getFaceName(matchedFaceId!);
    aws.IndexFacesResponse indexFacesResponse = await service.indexFaces(
      collectionId: collectionId,
      image: aws.Image(
        bytes: await image.readAsBytes(),
      ),
    );
    firebaseServices.addFaceIdToCollection(
      indexFacesResponse.faceRecords!.first.face!.faceId!,
      faceFoundName,
    );
  }
}
