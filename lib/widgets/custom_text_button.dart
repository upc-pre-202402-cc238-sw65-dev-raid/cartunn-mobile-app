import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget{
  final String text;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onPressed;
  const CustomTextButton({
    super.key,
    required this.text,
    required this.color,
    required this.backgroundColor,
    required this.onPressed
  });
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.purple
      ),
      onPressed: ()=> { onPressed() },
      child: Center(
        child: Text(text, style: TextStyle(color: color)),
      ),
    );
  }

}