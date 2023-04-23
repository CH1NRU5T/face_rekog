import 'dart:developer';

import 'package:aws_rekognition_api/rekognition-2016-06-27.dart' as aws;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_rekog/features/auth/widgets/custom_text_form_field.dart';
import 'package:face_rekog/features/face/screens/add_face.dart';
import 'package:face_rekog/features/face/screens/search_face.dart';
import 'package:face_rekog/features/face/services/face_service.dart';
import 'package:face_rekog/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import './features/auth/screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return DefaultTabController(
                length: 2,
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: IndexedStack(children: const [
                    TabBarView(
                      children: [
                        AddFace(),
                        SearchFace(),
                      ],
                    ),
                  ]),
                  appBar: AppBar(
                    actions: [
                      IconButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        },
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                      ),
                    ],
                    title: const Text('Home'),
                    bottom: const TabBar(
                      tabs: [
                        Tab(
                          icon: Icon(Icons.add_a_photo),
                          text: "Add Image",
                        ),
                        Tab(
                          icon: Icon(Icons.image_search),
                          text: "Search Image",
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const AuthScreen();
            }
          },
        ));
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference user = FirebaseFirestore.instance
      .collection(FirebaseAuth.instance.currentUser!.uid);
  final TextEditingController nameController = TextEditingController();
  FaceService faceService = FaceService();

  @override
  void initState() {
    super.initState();
  }

  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     faceService.indexFaces(
      //         FirebaseAuth.instance.currentUser!.uid, nameController.text);
      //     log('added the face of ${nameController.text} to the collection');
      //   },
      //   child: const Icon(Icons.add),
      // ),
      appBar: AppBar(
        title: const Text('Hello'),
      ),
      body: Center(
          child: Column(
        children: [
          IconButton(
            onPressed: () async {
              final searchResponse = await faceService.searchImage(
                  FirebaseAuth.instance.currentUser!.uid, null);
              if (searchResponse.faceMatches!.isEmpty) {
                log('no match found');
                return;
              }
              for (aws.FaceMatch fm in searchResponse.faceMatches!) {
                log('faceMatch faceId: ${fm.face!.faceId}');
              }
            },
            icon: const Icon(Icons.add),
          ),
          CustomTextFormField(
              controller: nameController,
              hintText: 'Name',
              type: TextInputType.name),
          IconButton(
              onPressed: () {
                faceService.deleteAllFacesFromCollection(
                    collectionId: FirebaseAuth.instance.currentUser!.uid);
              },
              icon: const Icon(Icons.car_crash)),
        ],
      )),
    );
  }
}
