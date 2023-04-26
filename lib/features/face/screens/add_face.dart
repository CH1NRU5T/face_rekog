import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../auth/widgets/custom_text_form_field.dart';
import '../services/face_service.dart';

class AddFace extends StatefulWidget {
  const AddFace({super.key});

  @override
  State<AddFace> createState() => _AddFaceState();
}

class _AddFaceState extends State<AddFace> {
  bool loading = false;
  ImagePicker imagePicker = ImagePicker();
  XFile? image;
  final imageNameKey = GlobalKey<FormState>();
  FaceService faceService = FaceService();
  final TextEditingController nameController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void openCamera() async {
    image = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  void addImage() async {
    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image'),
        ),
      );
      return;
    }
    if (loading) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please wait, adding an image'),
        ),
      );
      return;
    }

    if (imageNameKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      await faceService.indexFaces(
        collectionId: FirebaseAuth.instance.currentUser!.uid,
        name: nameController.text,
        imagePassed: image,
        context: context,
      );
      setState(() {
        loading = false;
        image = null;
        nameController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: imageNameKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: CustomTextFormField(
                controller: nameController,
                hintText: 'Name',
                type: TextInputType.name,
              ),
            ),
            const SizedBox(height: 10),
            image != null
                ? Expanded(
                    flex: 8,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Image.file(
                            fit: BoxFit.contain,
                            File(image!.path),
                          ),
                        ),
                        // const SizedBox(height: 10),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: () {
                              setState(
                                () {
                                  image = null;
                                },
                              );
                            },
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ),
                      ],
                    ),
                  )
                : Expanded(
                    flex: 8,
                    child: GestureDetector(
                      onTap: openCamera,
                      child: DottedBorder(
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
                                  'Tap here to Open Camera',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade400),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ),
            const SizedBox(height: 10),
            Expanded(
              flex: 1,
              // child: Visibility(child: child),
              child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: addImage,
                  child: Visibility(
                    visible: !loading,
                    replacement: const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
