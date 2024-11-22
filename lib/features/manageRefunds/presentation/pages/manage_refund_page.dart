import 'dart:convert';
import 'package:cartunn/features/auth/data/remote/auth_service.dart';
import 'package:cartunn/features/manageRefunds/domain/entity/product_refund.dart';
import 'package:cartunn/features/manageRefunds/domain/usecases/get_products_refunds_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:cartunn/shared/presentation/widgets/draggable_sheet_component.dart';
import 'package:cartunn/features/manageRefunds/presentation/widgets/manage_refund_detail_content.dart';

class ManageRefundView extends StatefulWidget {
  final GetProductsRefundsUseCase getProductsRefundsUseCase;

  const ManageRefundView({Key? key, required this.getProductsRefundsUseCase})
      : super(key: key);

  @override
  ManageRefundViewState createState() => ManageRefundViewState();
}

class ManageRefundViewState extends State<ManageRefundView> {
  List<ProductRefund> refunds = [];
  final authService = GetIt.I<AuthService>();
  @override
  void initState() {
    super.initState();
    _fetchRefunds();
  }

  Future<void> _fetchRefunds() async {
    try {
      final result = await widget.getProductsRefundsUseCase.call();
      if (mounted) {
        setState(() {
          refunds = result;
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load refunds: $error')),
        );
      }
    }
  }

  Future<void> _updateRefundStatus(
      ProductRefund refund, String newStatus) async {
    final token = authService.token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No autorizado. Inicia sesión primero.')),
      );
      return;
    }

    final url = Uri.parse(
        'https://cartunn.up.railway.app/api/v1/product-refund/${refund.id}');
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode({
        'id': refund.id,
        'title': refund.title,
        'description': refund.description,
        'status': newStatus,
      }),
    );

    if (response.statusCode == 200 && mounted) {
      setState(() {
        final updatedRefund = ProductRefund(
          id: refund.id,
          title: refund.title,
          description: refund.description,
          status: newStatus,
        );

        final index = refunds.indexWhere((r) => r.id == refund.id);
        if (index != -1) {
          refunds[index] = updatedRefund;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Status updated successfully!')),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update status.')),
      );
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Processed':
        return Icons.check_circle;
      case 'Processing':
        return Icons.hourglass_empty;
      case 'Rejected':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Processed':
        return Colors.green;
      case 'Processing':
        return Colors.yellow;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Refunds',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: refunds.length,
          itemBuilder: (context, index) {
            final productRefund = refunds[index];
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
                          color: Color(0xFF5766F5),
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
    );
  }
}
