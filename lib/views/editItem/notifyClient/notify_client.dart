import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cartunn/components/button.dart';
import 'package:cartunn/components/textfield.dart';

class NotifyClientPage extends StatefulWidget {
  const NotifyClientPage({super.key});

  @override
  NotifyClientPageState createState() => NotifyClientPageState();
}
class NotifyClientPageState extends State<NotifyClientPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();


  Future<void> _notifyClient() async {
    if (_formKey.currentState!.validate()) {
      final String id = _idController.text;
      const String url = 'https://cartunn.up.railway.app/api/v1/orders';
      final Map<String, dynamic> data = {
        "id": id,
        "description": _descriptionController.text,
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

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notification sent successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to send notification.')),
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
                'Notify the Customer by Id',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2B3674)),
              ),
              const SizedBox(height: 20),
              CustomTextField(controller: _idController, label: 'Order ID'),
              const SizedBox(height: 10),
              CustomTextField(controller: _descriptionController, label: 'Description'),
              const SizedBox(height: 10),
              CustomTextField(controller: _imageController, label: 'Image URL'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    text: 'Notify',
                    buttonColor: const Color(0xFF5766f5),
                    textColor: Colors.white,
                    onPressed: _notifyClient,
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
    _idController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    super.dispose();
  }
}