import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:projeto_mlkit/widgets/button_widget.dart';

class ExampleLanguageDetectorPage extends StatefulWidget {
  const ExampleLanguageDetectorPage({ Key? key }) : super(key: key);

  @override
  _ExampleLanguageDetectorPageState createState() => _ExampleLanguageDetectorPageState();
}

class _ExampleLanguageDetectorPageState extends State<ExampleLanguageDetectorPage> {

  final _textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final languageIdentifier = GoogleMlKit.nlp.languageIdentifier();

  String? language;

  Future<void> processText() async {
    
    setState(() {
      language = null;
    });

    if(!_formKey.currentState!.validate()) return;

    try {

      final String response = await languageIdentifier.identifyLanguage(_textEditingController.text);

      setState(() {
        language = response;
      });

    } catch(e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    languageIdentifier.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Language Detector"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                      label: Text("Digite uma frase")
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty) return "Digite alguma coisa";

                      return null;
                    },
                  ),
                  ButtonWidget(
                    text: "Processar texto", 
                    onPressed: () async => await processText(),
                  ),
                ],
              )
            ),

            const SizedBox(
              height: 10,
            ),

            if(language != null)
              Text("Idioma reconhecido: ${buildText(language)}")
            
          ],
        ),
      ),
    );
  }

  String buildText(String? language) {
    if(language == null || language == 'und') {
      return 'Não foi possível reconhecer um idioma';
    }

    return language;
  }
}