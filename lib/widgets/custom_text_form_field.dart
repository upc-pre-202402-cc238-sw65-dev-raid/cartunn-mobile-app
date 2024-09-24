import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final IconData? icon;
  final IconData? suffixIcon;
  final TextInputType? keyboardType;
  final String formProperty;
  final Map<String, String> formValues;

  const CustomTextFormField({
    super.key,
    this.hintText,
    this.labelText,
    this.helperText,
    this.icon,
    this.suffixIcon,
    this.keyboardType,
    required this.formProperty,
    required this.formValues,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,  // Ajustar el ancho según sea necesario
      child: TextFormField(
        keyboardType: keyboardType,
        obscureText: keyboardType == TextInputType.visiblePassword ? true : false,
        onChanged: (value) => formValues[formProperty] = value,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          helperText: helperText,
          prefixIcon: Icon(icon),
          suffixIcon: Icon(suffixIcon),
          border: const OutlineInputBorder(),  // Aplicar borde
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}
