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
          Center(
            child: Text(
              order.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
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
            'Description: ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            order.description,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Entry Date: ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            order.entryDate,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Exit Date: ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            order.exitDate,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Status:',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                order.status.toUpperCase(),
                style: TextStyle(
                    fontSize: 16,
                    color: order.status == 'initiated'
                        ? Colors.blue
                        : order.status == 'processing'
                            ? Colors.orange
                            : Colors.green),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: order.status == 'initiated'
                      ? Colors.blue
                      : order.status == 'processing'
                          ? Colors.orange
                          : Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  order.status == 'initiated'
                      ? Icons.timer
                      : order.status == 'processing'
                          ? Icons.cached
                          : Icons.check,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}