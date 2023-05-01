import 'dart:io';

import 'package:aws_rekognition_api/rekognition-2016-06-27.dart' as aws;
import 'package:face_rekog/features/face/services/face_service.dart';
import 'package:face_rekog/features/firebase/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class SearchFace extends StatefulWidget {
  static const String routeName = '/search-face';
  const SearchFace({super.key, required this.image});
  final XFile image;
  @override
  State<SearchFace> createState() => _SearchFaceState();
}

class _SearchFaceState extends State<SearchFace> {
  bool loading = false;
  String? found;
  FirebaseServices firebaseServices = FirebaseServices();
  double? confidence;
  FaceService faceService = FaceService();
  @override
  void initState() {
    super.initState();
    searchFace();
  }

  void searchFace() async {
    setState(() {
      loading = true;
    });
    aws.SearchFacesByImageResponse? searchResponse =
        await faceService.searchImage(
      collectionId: FirebaseAuth.instance.currentUser!.uid,
      imageToSearch: widget.image,
      context: context,
    );

    // if the search response is null, then the face is not found
    if (searchResponse == null) {
      setState(() {
        found = 'Not Found';

        loading = false;
      });
      return;
    }

    // if the search response is not null, but empty, then the face is not found in db
    if (searchResponse.faceMatches!.isEmpty) {
      setState(() {
        loading = false;
      });
      return;
    }

    final faceId = searchResponse.faceMatches!.first.face!.faceId;
    confidence = searchResponse.faceMatches!.first.face!.confidence;
    String name = await firebaseServices.getFaceName(faceId!);
    setState(() {
      loading = false;
      found = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text(
              'Face Recognise',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
          loading
              ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Lottie.asset('assets/Person Scan.json'),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child:
                          const Stack(alignment: Alignment.center, children: [
                        LinearProgressIndicator(
                          color: Color(0xff08BC12),
                          value: 0.8,
                          minHeight: 40,
                          backgroundColor: Color(0xffE7F9E8),
                        ),
                        Text(
                          'Scanning...',
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                      ]),
                    ),
                  ),
                ])
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.file(
                      File(widget.image.path),
                      height: 400,
                      width: 400,
                    ),
                    const SizedBox(height: 20),
                    if (found != null && found != 'Not Found')
                      Text('Identified as $found')
                    else if (found == 'Not Found')
                      const Text('There is no face in the image')
                    else
                      const Text('Face Not Found in DB'),
                    if (found != null && found != 'Not Found')
                      Text(
                          'Confidence: ${confidence!.toStringAsPrecision(10)}'),
                  ],
                ),
          const SizedBox(height: 50),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              '*By providing your fingerprint you agree to all the Terms and Conditions of this particular retails sale',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      )
          // : Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       Image.file(File(widget.image.path)),
          //       if (found != null && found != 'Not Found')
          //         Text('Identified as $found')
          //       else if (found == 'Not Found')
          //         const Text('There is no face in the image')
          //       else
          //         const Text('Face Not Found in DB'),
          //       if (found != null && found != 'Not Found')
          //         Text('Confidence: ${confidence!.toStringAsPrecision(10)}'),
          //     ],
          //   ),
          ),
    );
  }
}
