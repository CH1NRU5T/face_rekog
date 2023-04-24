import 'package:face_rekog/features/auth/screens/register_screen.dart';
import 'package:face_rekog/features/face/screens/search_face.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'features/auth/screens/login_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case SearchFace.routeName:
      XFile image = routeSettings.arguments as XFile;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => SearchFace(image: image),
      );
    case RegisterScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const RegisterScreen(),
      );
    case LoginScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const LoginScreen(),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${routeSettings.name}'),
          ),
        ),
      );
  }
}
