import 'package:flutter/material.dart';
import 'package:cartunn/components/button.dart';
import 'package:cartunn/features/manageRefunds/domain/entity/product_refund.dart';

class ProductRefundDetailContent extends StatefulWidget {
  final ProductRefund productRefund;
  final ValueChanged<String> onSave;

  const ProductRefundDetailContent({
    super.key,
    required this.productRefund,
    required this.onSave,
  });

  @override
  _ProductRefundDetailContentState createState() =>
      _ProductRefundDetailContentState();
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
                child: CustomButton(
                  text: 'Save',
                  buttonColor: const Color(0xFF5766F5),
                  textColor: Colors.white,
                  onPressed: () {
                    widget.onSave(_selectedStatus);
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                  text: 'Cancel',
                  buttonColor: const Color.fromARGB(255, 255, 252, 252),
                  textColor: const Color(0xFF5766F5),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
