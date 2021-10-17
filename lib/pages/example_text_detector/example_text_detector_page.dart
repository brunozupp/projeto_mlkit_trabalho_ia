import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_mlkit/widgets/button_widget.dart';

class ExampleTextDetectorPage extends StatefulWidget {
  const ExampleTextDetectorPage({ Key? key }) : super(key: key);

  @override
  State<ExampleTextDetectorPage> createState() => _ExampleTextDetectorPageState();
}

class _ExampleTextDetectorPageState extends State<ExampleTextDetectorPage> {

  final ImagePicker _picker = ImagePicker();

  // Criando a instância do serviço responsável por processar a imagem
  final textDetector = GoogleMlKit.vision.textDetector();

  File? file;
  List<TextBlock> blocks = [];
  
  getPhoto(ImageSource source) async {
    var photo = await _picker.pickImage(source: source);

    if(photo != null) {

      setState(() {
        file = File(photo.path);
        blocks.clear();
      });
    }
  }

  processImage() async {
    if(file == null) return;

    // Criando a instância da foto
    final inputImage = InputImage.fromFilePath(file!.path);

    try {

      final RecognisedText recognisedText = await textDetector.processImage(inputImage);

      // Executando processo de análise da imagem
      String text = recognisedText.text;

      setState(() {
        blocks = recognisedText.blocks;
      });

      for (TextBlock block in recognisedText.blocks) {
        final Rect rect = block.rect;
        final List<Offset> cornerPoints = block.cornerPoints;
        final String text = block.text;
        final List<String> languages = block.recognizedLanguages;

        print("Sentença de um bloco = $text");
        //print("Idioma = ${languages.reduce((acc,current) => acc + ", " + current)}");
        print(languages);

        for (TextLine line in block.lines) {
          // Same getters as TextBlock

          print("Sentença de uma linha = ${line.text}");

          for (TextElement element in line.elements) {
            // Same getters as TextBlock

            print("Sentença de um elemento = ${element.text}");
          }
        }
      }
    } catch(e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();

    textDetector.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Text Detector"),
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
            
            if(blocks.isNotEmpty)
              ListView.separated(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: blocks.length,
                separatorBuilder: (_,__) => Divider(),
                itemBuilder: (_,index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Bloco ${index + 1}"),
                      Text("Idiomas reconhecido: ${blocks[index].recognizedLanguages.reduce((acc,current) => acc + ", " + current)}"),
                      Text(blocks[index].text),
                    ],
                  );
                }
              ),
          ],
        ),
      ),
    );
  }
}