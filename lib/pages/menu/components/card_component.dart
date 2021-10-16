import 'dart:ffi';

import 'package:flutter/material.dart';

class CardComponent extends StatelessWidget {

  final VoidCallback onPressed;
  final String text;
  final IconData icon;

  const CardComponent({ 
    Key? key, 
    required this.onPressed, 
    required this.text, 
    required this.icon 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        shadowColor: Colors.blue[900],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 70,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(text),
          ],
        ),
      ),
    );
  }
}