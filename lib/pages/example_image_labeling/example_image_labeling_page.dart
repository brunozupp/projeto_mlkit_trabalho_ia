import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_mlkit/widgets/button_widget.dart';

class ExampleImageLabelingPage extends StatefulWidget {
  const ExampleImageLabelingPage({ Key? key }) : super(key: key);

  @override
  State<ExampleImageLabelingPage> createState() => _ExampleImageLabelingPageState();
}

class _ExampleImageLabelingPageState extends State<ExampleImageLabelingPage> {

  final ImagePicker _picker = ImagePicker();

  // Criando a instância do serviço responsável por processar a imagem
  final imageLabeler = GoogleMlKit.vision.imageLabeler();

  File? file;
  List<ImageLabel> labels = [];
  
  getPhoto(ImageSource source) async {
    var photo = await _picker.pickImage(source: source);

    if(photo != null) {

      setState(() {
        file = File(photo.path);
        labels.clear();
      });
    }
  }

  processImage() async {
    if(file == null) return;

    setState(() {
      labels.clear();
    });

    // Criando a instância da foto
    final inputImage = InputImage.fromFilePath(file!.path);

    try {
      // Executando processo de análise da imagem
      final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);

      setState(() {
        this.labels.addAll(labels);
      });

      for (ImageLabel label in labels) {
        final String text = label.label;
        final int index = label.index;
        final double confidence = label.confidence;

        print("Label: $text | Index: $index | confidence: $confidence");
      }
    } catch(e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();

    imageLabeler.close();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Labeling"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                
                ButtonWidget(
                  text: "Galeria", 
                  onPressed: () async => await getPhoto(ImageSource.gallery),
                ),
                ButtonWidget(
                  text: "Câmera", 
                  onPressed: () async => await getPhoto(ImageSource.camera),
                ),
                
              ],
            ),
            if(file != null)
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(file!),
                    fit: BoxFit.contain
                  ),
                ),
              ),
            
            if(file != null)
              ButtonWidget(
                  text: "Processar Imagem", 
                  onPressed: () async => await processImage(),
                ),
            
            if(labels.isNotEmpty)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: labels.length,
                separatorBuilder: (_,__) => const Divider(),
                itemBuilder: (_,index) {
                  return ListTile(
                    title: Text(labels[index].label),
                    subtitle: Text("Taxa de acerto: ${labels[index].confidence * 100}"),
                  );
                }
              ),
          ],
        ),
      )
    );
  }
}