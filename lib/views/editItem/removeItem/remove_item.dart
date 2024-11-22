import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cartunn/shared/presentation/widgets/button.dart';
import 'package:cartunn/shared/presentation/widgets/textfield.dart';

class RemoveItemPage extends StatefulWidget {
  const RemoveItemPage({super.key});

  @override
  RemoveItemPageState createState() => RemoveItemPageState();
}

class RemoveItemPageState extends State<RemoveItemPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _idController = TextEditingController();

  Future<void> _removeItemById() async {
    if (_formKey.currentState!.validate()) {
      final String id = _idController.text;
      final String url = 'https://cartunn.up.railway.app/api/v1/products/$id';

      try {
        final response = await http.delete(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
        );

        if (!mounted) return;

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item removed successfully!')),
          );
        } else if (response.statusCode == 404) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item not found.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to remove item.')),
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
                'Remove Item by ID',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 8),
              const Text(
                'Are you sure you want to delete this Item(this action es irreversible)?',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 20),
              CustomTextField(controller: _idController, label: 'Item ID'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    text: 'Remove',
                    buttonColor: const Color(0xFF5766f5),
                    textColor: Colors.white,
                    onPressed: _removeItemById,
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
    super.dispose();
  }
}
