import 'package:cartunn/components/button.dart';
import 'package:cartunn/features/auth/data/remote/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:cartunn/features/inventory/domain/entities/product.dart';
import 'package:cartunn/shared/presentation/widgets/textfield.dart';
import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

class ProductDetailContent extends StatefulWidget {
  final Product product;

  const ProductDetailContent({super.key, required this.product});

  @override
  State<ProductDetailContent> createState() => _ProductDetailContentState();
}

class _ProductDetailContentState extends State<ProductDetailContent> {
  bool _showForm = false;
  final authService = GetIt.I<AuthService>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  Future<void> _updateItem(int productId) async {
    if (_formKey.currentState!.validate()) {
      final String url =
          'https://cartunn.up.railway.app/api/v1/products/$productId';

      final Map<String, dynamic> data = {
        "title": _nameController.text,
        "description": _descriptionController.text,
        "price": double.parse(_priceController.text),
        "image": _imageController.text,
      };
      final token = authService.token;
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No autorizado. Inicia sesión primero.')),
        );
        return;
      }
      try {
        final response = await http.put(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(data),
        );

        if (!mounted) return;

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item updated successfully!')),
          );
        } else {
          final errorData = jsonDecode(response.body);

          final errorMessage = errorData['error'] ?? 'Failed to update item.';

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
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

  Future<void> _removeItem(int productId) async {
      final token = authService.token;
      if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No autorizado. Inicia sesión primero.')),
      );
        return;
      }

      try {
      final response = await http.delete(
        Uri.parse('https://cartunn.up.railway.app/api/v1/products/$productId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item removed successfully!')),
        );
        // Cierra el DraggableSheetComponent después de eliminar el producto
        Navigator.pop(context);
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

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.product.title;
    _descriptionController.text = widget.product.description;
    _priceController.text = widget.product.price.toString();
    _imageController.text = widget.product.image;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _showForm ? _buildForm() : _buildDetails(),
    );
  }

  Widget _buildDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.product.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: Image.network(
              widget.product.image,
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Description',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.product.description,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Price',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '\$${widget.product.price}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _showForm = true;
                  });
                },
                icon: const Icon(Icons.edit),
                color: Colors.orange.shade400,
              ),
              IconButton(
                onPressed: () {
                  final int productId = widget.product.id;
                  _removeItem(productId);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.delete),
                color: Colors.red.shade400,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
  return Form(
    key: _formKey,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Update Product',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomButton(
                text: 'Update',
                buttonColor: const Color(0xFF5766F5),
                textColor: Colors.white,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updateItem(widget.product.id);
                    Navigator.pop(context);
                  }
                },
              ),
              const SizedBox(width: 16),
              CustomButton(
                text: 'Cancel',
                buttonColor: const Color.fromARGB(255, 255, 252, 252),
                textColor: Colors.black,
                onPressed: () {
                  setState(() {
                    _showForm = false;
                  });
                },
              ),
            ],
          )
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
