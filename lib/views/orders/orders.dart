import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Order> orders = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http
        .get(Uri.parse('https://cartunn.up.railway.app/api/v1/orders'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        orders = List<Order>.from(data.map((x) => Order.fromJson(x)));
      });
    } else {
      throw Exception('Failed to load orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(order: order),
                ),
              );
            },
            child: Card(
              child: ListTile(
                title: Text(order.name),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Order order;

  const DetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(order.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // Alineamos los elementos a la izquierda
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  title: const Text(
                    'Description',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: SizedBox(
                    width: 250,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(order.description, textAlign: TextAlign.right),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Date of entry',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Text(order.entryDate),
                ),
                ListTile(
                  title: const Text('Date of exit',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Text(order.exitDate),
                ),
                ListTile(
                  title: const Text('Status',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: order.status == 'completed'
                            ? Colors.green
                            : order.status == 'in_process'
                                ? Colors.orange
                                : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(order.status == 'completed'
                          ? 'Completed'
                          : order.status == 'in_process'
                              ? 'In progress'
                              : 'Cancelled'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Order {
  final String name;
  final String description;
  final int code;
  final String entryDate;
  final String exitDate;
  final String status;

  Order({
    required this.name,
    required this.description,
    required this.code,
    required this.entryDate,
    required this.exitDate,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      name: json['name'],
      description: json['description'],
      code: json['code'],
      entryDate: json['entryDate'],
      exitDate: json['exitDate'],
      status: json['status'],
    );
  }
}
