import 'package:face_rekog/features/face/screens/add_face.dart';
import 'package:face_rekog/firebase_options.dart';
import 'package:face_rekog/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'features/auth/screens/login_screen.dart';
import 'features/face/widgets/search_face_form.dart';

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
        onGenerateRoute: (settings) => generateRoute(settings),
        title: 'Face Rekog',
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
                  body: const IndexedStack(children: [
                    TabBarView(
                      children: [
                        AddFace(),
                        SearchFaceForm(),
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
                    title: const Text('Face Rekog'),
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
              return const LoginScreen();
            }
          },
        ));
  }
}
