import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_mlkit/widgets/button_widget.dart';

class ValidateCpfPage extends StatefulWidget {
  const ValidateCpfPage({ Key? key }) : super(key: key);

  @override
  _ValidateCpfPageState createState() => _ValidateCpfPageState();
}

class _ValidateCpfPageState extends State<ValidateCpfPage> {

  final textEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool? status;

  final ImagePicker _picker = ImagePicker();

  // Criando a instância do serviço responsável por processar a imagem
  final textDetector = GoogleMlKit.vision.textDetector();

  List<TextBlock> blocks = [];
  
  Future<File?> getDocument(ImageSource source) async {
    var photo = await _picker.pickImage(source: source);

    if(photo == null) return null;

    return File(photo.path);
  }

  Future<bool> validateDocument(ImageSource source) async {

    setState(() {
      status = null;
    });

    var file = await getDocument(source);

    if(file == null) return false;

    // Criando a instância da foto
    final inputImage = InputImage.fromFilePath(file.path);

    try {

      final RecognisedText recognisedText = await textDetector.processImage(inputImage);

      setState(() {
        status = recognisedText.text.contains(textEditingController.text);
      });

      return status!;

    } catch(e) {
      print(e);
    }

    return false;
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
        title: const Text("Validador de CPF"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                    controller: textEditingController,
                    decoration: const InputDecoration(
                      label: Text("Digite o CPF"),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CpfInputFormatter(),
                    ],
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if(value == null || value.isEmpty) return "Campo obrigatório";

                      if(!CPFValidator.isValid(value)) return "CPF inválido";

                      return null;
                    },
                  ),
                  ButtonWidget(
                    text: "Validar com foto", 
                    onPressed: () async {

                      if(!formKey.currentState!.validate()) return;

                      var imageSource = await getImageSource();

                      if(imageSource == null) return;

                      await validateDocument(imageSource);
                      
                    }
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            if(status != null)
              buildStatus(status!)
          ],
        ),
      ),
    );
  }

  Future<ImageSource?> getImageSource() async {
    return await showDialog<ImageSource?>(
      context: context,
      builder: (_) => AlertDialog(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
              child: const Icon(
                Icons.camera_alt,
                size: 70,
              ),
            ),

            GestureDetector(
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              child: const Icon(
                Icons.image,
                size: 70,
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget buildStatus(bool status) {

    if(status) {
      return Text(
        "VALIDADO COM SUCESSO",
        style: TextStyle(
          color: Colors.green[900]
        ),
      ); 
    }

    return Text(
      "VALIDADO COM FALHA",
      style: TextStyle(
        color: Colors.red[900]
      ),
    ); 
  }



}