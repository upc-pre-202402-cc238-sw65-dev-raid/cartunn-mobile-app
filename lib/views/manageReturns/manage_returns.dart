import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'entity/manage_return.dart'; // Asegúrate de que este archivo existe y tiene la clase ProductRefund.
import 'package:cartunn/components/draggable_sheet_component.dart';

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
    final response = await http.get(Uri.parse('https://cartunn.up.railway.app/api/v1/product-refund'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        productRefunds = List<ProductRefund>.from(data.map((x) => ProductRefund.fromJson(x)));
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Rejected':
        return Colors.red;
      case 'Processing':
        return Colors.orange;
      case 'Processed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Rejected':
        return Icons.cancel;
      case 'Processing':
        return Icons.timelapse;
      case 'Processed':
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Product Refunds',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: productRefunds.length,
              itemBuilder: (context, index) {
                final productRefund = productRefunds[index];
                return GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: DraggableSheetComponent(
                                child: ProductRefundDetailContent(
                                  productRefund: productRefund,
                                  onSave: (newStatus) {
                                    _updateRefundStatus(productRefund, newStatus);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            productRefund.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            productRefund.description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _getStatusIcon(productRefund.status),
                                color: _getStatusColor(productRefund.status),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                productRefund.status,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _getStatusColor(productRefund.status),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductRefundDetailContent extends StatefulWidget {
  final ProductRefund productRefund;
  final ValueChanged<String> onSave;

  const ProductRefundDetailContent({
    super.key,
    required this.productRefund,
    required this.onSave,
  });

  @override
  _ProductRefundDetailContentState createState() => _ProductRefundDetailContentState();
}

class _ProductRefundDetailContentState extends State<ProductRefundDetailContent> {
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.productRefund.status;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.productRefund.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
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
            widget.productRefund.description,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Text(
            'Status',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          DropdownButton<String>(
            value: _selectedStatus,
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
                _selectedStatus = value!;
              });
            },
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onSave(_selectedStatus);
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
    );
  }
}
