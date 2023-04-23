import 'package:face_rekog/features/face/screens/search_face.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case SearchFace.routeName:
      XFile image = routeSettings.arguments as XFile;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => SearchFace(image: image),
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
