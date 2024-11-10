import 'dart:convert';
import 'package:cartunn/presentation/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cartunn/features/inventory/domain/entities/product.dart';

class UploadItemPage extends StatefulWidget {
  const UploadItemPage({super.key});

  @override
  UploadItemPageState createState() => UploadItemPageState();
}

class UploadItemPageState extends State<UploadItemPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  Future<void> _uploadItem() async {
    if (_formKey.currentState!.validate()) {
      const String url = 'https://cartunn.up.railway.app/api/v1/products';
      final Map<String, dynamic> data = {
        "title": _nameController.text,
        "description": _descriptionController.text,
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
          final product = Product.fromJson(jsonDecode(response.body));

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item uploaded successfully!')),
          );
          Navigator.of(context).pop(product);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload item.')),
          );
          Navigator.of(context).pop();
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            const Text(
              'Upload product',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _nameController,
              label: 'Name',
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _descriptionController,
              label: 'Description',
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _priceController,
              label: 'Price',
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _imageController,
              label: 'Image URL',
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _uploadItem,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5766f5),
                foregroundColor: const Color(0xFFFFFFFF),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    super.dispose();
  }
}
