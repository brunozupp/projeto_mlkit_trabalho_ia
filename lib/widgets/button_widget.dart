
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {

  final String text;
  final VoidCallback onPressed;

  const ButtonWidget({ 
    Key? key, 
    required this.text, 
    required this.onPressed 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width * 0.4
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text)
      ),
    );
  }
}