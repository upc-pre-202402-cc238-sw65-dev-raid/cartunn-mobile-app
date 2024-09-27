import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../components/button.dart';
import '../../components/textfield.dart';

class ManageReturnsPage extends StatefulWidget {
  const ManageReturnsPage({super.key});

  @override
  _ManageReturnsPageState createState() => _ManageReturnsPageState();
}

class _ManageReturnsPageState extends State<ManageReturnsPage> {
  List<ReturnItem> returns = [];

  @override
  void initState() {
    super.initState();
    fetchReturns();
  }

  Future<void> fetchReturns() async {
    final response = await http.get(Uri.parse('https://cartunn.up.railway.app/api/v1/product-refund'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        returns = List<ReturnItem>.from(data.map((x) => ReturnItem.fromJson(x)));
      });
    } else {
      throw Exception('Failed to load returns');
    }
  }

  void _showEditDialog(ReturnItem returnItem) {
    final titleController = TextEditingController(text: returnItem.title);
    final descriptionController = TextEditingController(text: returnItem.description);
    String selectedStatus = returnItem.status;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Return Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: titleController,
                label: 'Title',
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: descriptionController,
                label: 'Description',
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                items: [
                  'Processed',
                  'Processing',
                  'Rejected',
                ].map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedStatus = value;
                    });
                  }
                },
                decoration: const InputDecoration(labelText: 'Status'),
              ),
            ],
          ),
          actions: [
            CustomButton(
              text: 'Cancel',
              buttonColor: const Color(0xFF5766f5),
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CustomButton(
              text: 'Save',
              buttonColor: const Color(0xFF5766f5),
              textColor: Colors.white,
              onPressed: () {
                _updateReturnItem(returnItem, titleController.text, descriptionController.text, selectedStatus);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateReturnItem(ReturnItem returnItem, String title, String description, String status) {
    setState(() {
      returns[returns.indexOf(returnItem)] = ReturnItem(
        title: title,
        description: description,
        status: status,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Returns', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
      ),
      body: ListView.builder(
        itemCount: returns.length,
        itemBuilder: (context, index) {
          final returnItem = returns[index];
          return GestureDetector(
            onTap: () {
              _showEditDialog(returnItem);
            },
            child: Card(
              child: ListTile(
                title: Text(returnItem.title),
                subtitle: Text(returnItem.description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      returnItem.status == 'Processed'
                          ? Icons.check_circle
                          : returnItem.status == 'Processing'
                          ? Icons.access_time
                          : Icons.cancel,
                      color: returnItem.status == 'Processed'
                          ? Colors.green
                          : returnItem.status == 'Processing'
                          ? Colors.yellow
                          : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(returnItem.status == 'Processed'
                        ? 'Processed'
                        : returnItem.status == 'Processing'
                        ? 'Processing'
                        : 'Rejected'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ReturnItem {
  final String title;
  final String description;
  final String status;

  ReturnItem({
    required this.title,
    required this.description,
    required this.status,
  });

  factory ReturnItem.fromJson(Map<String, dynamic> json) {
    return ReturnItem(
      title: json['title'],
      description: json['description'],
      status: json['status'],
    );
  }
}
