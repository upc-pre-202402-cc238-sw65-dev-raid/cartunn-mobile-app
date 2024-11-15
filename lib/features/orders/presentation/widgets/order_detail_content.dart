import 'package:flutter/material.dart';
import 'package:cartunn/features/orders/domain/entities/order.dart';

class OrderDetailContent extends StatelessWidget {
  final Order order;

  const OrderDetailContent({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: Image.network(
              order.imageUrl,
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Description: ${order.description}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Entry Date: ${order.entryDate}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Exit Date: ${order.exitDate}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Status: ${order.status}',
            style: TextStyle(
              fontSize: 16,
              color: order.status == 'completed'
                  ? Colors.green
                  : order.status == 'in_process'
                      ? Colors.orange
                      : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}