import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ManageReturnsPage extends StatefulWidget {
  const ManageReturnsPage({super.key});

  @override
  _ManageReturnsPageState createState() => _ManageReturnsPageState();
}

class _ManageReturnsPageState extends State<ManageReturnsPage> {
  List<ProductRefund> productRefunds = [];

  @override
  void initState() {
    super.initState();
    fetchProductRefunds();
  }

  Future<void> fetchProductRefunds() async {
    final response = await http
        .get(Uri.parse('https://cartunn.up.railway.app/api/v1/product-refund'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        productRefunds = List<ProductRefund>.from(
            data.map((x) => ProductRefund.fromJson(x)));
      });
    } else {
      throw Exception('Failed to load product refunds');
    }
  }

  Future<void> _updateRefundStatus(
      ProductRefund refund, String newStatus) async {
    final url = Uri.parse(
        'https://cartunn.up.railway.app/api/v1/product-refund/${refund.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': refund.id,
        'title': refund.title,
        'description': refund.description,
        'status': newStatus,
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        refund.status = newStatus;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Status updated successfully!')),
      );
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update status.')),
      );
    }
  }

  void _openRefundDetailModal(ProductRefund refund) {
    String selectedStatus = refund.status;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 32,
            right: 32,
            top: 32,
            bottom: MediaQuery.of(context).viewInsets.bottom + 32,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Wrap(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      refund.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5766F5),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Description:',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        refund.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Status:',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<String>(
                      value: selectedStatus,
                      items: const [
                        DropdownMenuItem(
                          value: 'Rejected',
                          child: Text('Rejected'),
                        ),
                        DropdownMenuItem(
                          value: 'Processing',
                          child: Text('Processing'),
                        ),
                        DropdownMenuItem(
                          value: 'Processed',
                          child: Text('Processed'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await _updateRefundStatus(refund, selectedStatus);
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5766F5),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'SAVE',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'CLOSE',
                              style: TextStyle(
                                color: Color(0xFF5766F5),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Icon _buildStatusIcon(String status) {
    return Icon(
      status == 'Processed'
          ? Icons.check_circle
          : status == 'Processing'
              ? Icons.access_time
              : Icons.cancel,
      color: status == 'Processed'
          ? Colors.green
          : status == 'Processing'
              ? Colors.orange
              : Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Manage Refunds',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: productRefunds.length,
            itemBuilder: (context, index) {
              final refund = productRefunds[index];
              return GestureDetector(
                onTap: () {
                  _openRefundDetailModal(refund);
                },
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                refund.title,
                                style: const TextStyle(
                                  color: Color(0xFF5766F5),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                refund.description,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _buildStatusIcon(refund.status),
                                  const SizedBox(width: 8),
                                  Text(
                                    refund.status,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }
}

class ProductRefund {
  final int id;
  final String title;
  final String description;
  String status;

  ProductRefund({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
  });

  factory ProductRefund.fromJson(Map<String, dynamic> json) {
    return ProductRefund(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
    );
  }
}
