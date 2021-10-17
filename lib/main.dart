import 'package:flutter/material.dart';
import 'package:projeto_mlkit/pages/example_image_labeling/example_image_labeling_page.dart';
import 'package:projeto_mlkit/pages/example_language_detector/example_language_detector_page.dart';
import 'package:projeto_mlkit/pages/example_text_detector/example_text_detector_page.dart';
import 'package:projeto_mlkit/pages/menu/menu_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => const MenuPage(),
        "/example-image-labeling": (context) => const ExampleImageLabelingPage(),
        "/example-text-detector": (context) => const ExampleTextDetectorPage(),
        "/example-language-detector": (context) => const ExampleLanguageDetectorPage(),
      },
    );
  }
}