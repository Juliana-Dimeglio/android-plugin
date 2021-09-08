import 'package:flutter/material.dart';

class PluginButton extends StatelessWidget {
  final Function() onPressed;
  final String buttonText;
  final double fontSize;

  const PluginButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.grey.shade300,
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.red.shade900,
      ),
    );
  }
}
