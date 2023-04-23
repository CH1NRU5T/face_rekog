import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../auth/widgets/custom_text_form_field.dart';
import '../services/face_service.dart';

class AddFaceForm extends StatefulWidget {
  const AddFaceForm({super.key});

  @override
  State<AddFaceForm> createState() => _AddFaceFormState();
}

class _AddFaceFormState extends State<AddFaceForm> {
  FaceService faceService = FaceService();
  final TextEditingController nameController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  bool loading = false;
  ImagePicker imagePicker = ImagePicker();
  XFile? image;
  final imageNameKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Form(
          key: imageNameKey,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: CustomTextFormField(
                  controller: nameController,
                  hintText: 'Name',
                  type: TextInputType.name,
                ),
              ),
              const SizedBox(height: 10),
              image != null
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
                        // const SizedBox(height: 10),
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
                  : GestureDetector(
                      onTap: () async {
                        image = await imagePicker.pickImage(
                            source: ImageSource.camera);
                        setState(() {});
                      },
                      child: DottedBorder(
                        borderPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
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
                                      fontSize: 15,
                                      color: Colors.grey.shade400),
                                ),
                              ]),
                        ),
                      ),
                    ),
            ],
          ),
        ),
        // IconButton(
        //   onPressed: () {
        //     faceService.deleteAllFacesFromCollection(
        //         collectionId: FirebaseAuth.instance.currentUser!.uid);
        //   },
        //   icon: const Icon(Icons.car_crash),
        // ),
        // const Expanded(child: SizedBox()),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              backgroundColor: Colors.blue,
            ),
            onPressed: () async {
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
                );
                setState(() {
                  loading = false;
                  image = null;
                  nameController.clear();
                });
              }
            },
            child: loading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Text(
                    'Add',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
          ),
        ),
      ],
    );
  }
}
