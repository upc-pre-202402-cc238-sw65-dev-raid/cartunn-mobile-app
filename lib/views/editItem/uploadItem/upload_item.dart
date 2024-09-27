import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cartunn/components/button.dart';
import 'package:cartunn/components/textfield.dart';

class UploadItemPage extends StatefulWidget {
  const UploadItemPage({super.key});

  @override
  UploadItemPageState createState() => UploadItemPageState();
}

class UploadItemPageState extends State<UploadItemPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  Future<void> _uploadItem() async {
    if (_formKey.currentState!.validate()) {
      const String url = 'https://cartunn.up.railway.app/api/v1/products';
      final Map<String, dynamic> data = {
        "title": _nameController.text,
        "description": _descriptionController.text,
        "model": _modelController.text,
        "price": double.parse(_priceController.text),
        "image": _imageController.text,
      };

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(data),
        );

        if (!mounted) return;

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item uploaded successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload item.')),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Upload Item Page',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2B3674)),
              ),
              const SizedBox(height: 20),
              CustomTextField(controller: _nameController, label: 'Name'),
              const SizedBox(height: 10),
              CustomTextField(controller: _descriptionController, label: 'Description'),
              const SizedBox(height: 10),
              CustomTextField(controller: _modelController, label: 'Model'),
              const SizedBox(height: 10),
              CustomTextField(controller: _priceController, label: 'Price'),
              const SizedBox(height: 10),
              CustomTextField(controller: _imageController, label: 'Image URL'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    text: 'Upload',
                    buttonColor: const Color(0xFF5766f5),
                    textColor: Colors.white,
                    onPressed: _uploadItem,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _modelController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    super.dispose();
  }
}
