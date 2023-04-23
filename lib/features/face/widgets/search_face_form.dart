import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:face_rekog/features/face/screens/search_face.dart';
import 'package:face_rekog/features/face/services/face_service.dart';
import 'package:face_rekog/features/firebase/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SearchFaceForm extends StatefulWidget {
  const SearchFaceForm({super.key});

  @override
  State<SearchFaceForm> createState() => _SearchFaceFormState();
}

class _SearchFaceFormState extends State<SearchFaceForm> {
  ImagePicker imagePicker = ImagePicker();
  FaceService faceService = FaceService();
  FirebaseServices firebaseServices = FirebaseServices();
  XFile? image;

  void searchImage() {
// if image is not selected prompt user to select an image
    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image'),
        ),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      SearchFace.routeName,
      arguments: image,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              image = await imagePicker.pickImage(source: ImageSource.camera);
              setState(() {});
            },
            child: image != null
                ? Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.59,
                        child: Image.file(
                          fit: BoxFit.contain,
                          File(image!.path),
                        ),
                      ),
                      const SizedBox(height: 10),
                      IconButton(
                        onPressed: () {
                          setState(
                            () {
                              image = null;
                            },
                          );
                        },
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  )
                : DottedBorder(
                    borderPadding: const EdgeInsets.all(20),
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(10),
                    strokeCap: StrokeCap.round,
                    dashPattern: const [10, 4],
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.62,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.camera_outlined),
                            const SizedBox(height: 15),
                            Text(
                              'Open Camera',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey.shade400),
                            ),
                          ]),
                    ),
                  ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              backgroundColor: Colors.blue,
            ),
            onPressed: searchImage,
            child: const Text(
              'Search',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ]),
    );
  }
}
