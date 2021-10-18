import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_mlkit/widgets/button_widget.dart';

class ExampleFaceDetectorPage extends StatefulWidget {
  const ExampleFaceDetectorPage({ Key? key }) : super(key: key);

  @override
  _ExampleFaceDetectorPageState createState() => _ExampleFaceDetectorPageState();
}

class _ExampleFaceDetectorPageState extends State<ExampleFaceDetectorPage> {

  final faceDetector = GoogleMlKit.vision.faceDetector(const FaceDetectorOptions(
    enableClassification: true,
  ));

  final ImagePicker _picker = ImagePicker();

  File? file;
  List<Face> faces = [];
  
  getPhoto(ImageSource source) async {
    var photo = await _picker.pickImage(source: source);

    if(photo != null) {

      setState(() {
        file = File(photo.path);
        faces.clear();
      });
    }
  }

  processImage() async {
    if(file == null) return;

    setState(() {
      faces.clear();
    });

    // Criando a instância da foto
    final inputImage = InputImage.fromFilePath(file!.path);

    try {
      // Executando processo de análise da imagem
      final List<Face> faces = await faceDetector.processImage(inputImage);

      setState(() {
        this.faces.addAll(faces);
      });

      for (Face face in faces) {
        // final Rect boundingBox = face.boundingBox;

        // final double? rotY = face.headEulerAngleY; // Head is rotated to the right rotY degrees
        // final double? rotZ = face.headEulerAngleZ; // Head is tilted sideways rotZ degrees

        // If landmark detection was enabled with FaceDetectorOptions (mouth, ears,
        // eyes, cheeks, and nose available):
        // final FaceLandmark? leftEar = face.getLandmark(FaceLandmarkType.leftEar);
        // if (leftEar != null) {
        //   final leftEarPos = leftEar.position;
        // }

        // If classification was enabled with FaceDetectorOptions:
        if (face.smilingProbability != null) {
          final smileProb = face.smilingProbability;
          print("Sorrindo: ${smileProb.toString()}");
        }

        // If face tracking was enabled with FaceDetectorOptions:
        // if (face.trackingId != null) {
        //   final int id = face.trackingId;
        // }
      }
    } catch(e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    faceDetector.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Face Detector"),
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
            
            if(faces.isNotEmpty)
              ListView.separated(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: faces.length,
                separatorBuilder: (_,__) => const Divider(),
                itemBuilder: (_,index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Face ${index + 1}"),
                      Text("Probabilidade de sorrindo: ${faces[index].smilingProbability! * 100}%"),
                      Text("Probabilidade do olho esquerdo aberto: ${faces[index].leftEyeOpenProbability! * 100}%"),
                      Text("Probabilidade do olho direito aberto: ${faces[index].rightEyeOpenProbability! * 100}%"),
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