import 'package:flutter/material.dart';
import 'package:projeto_mlkit/pages/menu/components/card_component.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu do MLKit"),
        centerTitle: true,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(10),
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: [
          CardComponent(
            onPressed: () => Navigator.of(context).pushNamed("/example-image-labeling"),
            text: "Image Labeling", 
            icon: Icons.image
          ),
          CardComponent(
            onPressed: () => Navigator.of(context).pushNamed("/example-text-detector"), 
            text: "Text Detector", 
            icon: Icons.text_fields
          ),
        ],
      ),
    );
  }
}