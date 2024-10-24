import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './entity/order.dart';
import 'package:cartunn/components/draggable_sheet_component.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Order> orders = [];
  List<Order> filteredOrders = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchOrders();
    searchController.addListener(() {
      filterOrders();
    });
  }

  Future<void> fetchOrders() async {
    final response = await http
        .get(Uri.parse('https://cartunn.up.railway.app/api/v1/orders'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        orders = List<Order>.from(data.map((x) => Order.fromJson(x)));
        filteredOrders = orders;
      });
    } else {
      throw Exception('Failed to load orders');
    }
  }

  void filterOrders() {
    String searchText = searchController.text.toLowerCase();
    setState(() {
      filteredOrders = orders
          .where((order) => order.name.toLowerCase().contains(searchText))
          .toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Orders',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) {
              final order = filteredOrders[index];
              return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    isDismissible: true,
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
                              child: OrderDetailContent(order: order),
                            ),
                          ),
                        ],
                      ),
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
        ],
      ),
    );
  }
}

class OrderDetailContent extends StatelessWidget {
  final Order order;

  const OrderDetailContent({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
          Image(
            image: NetworkImage(order.imageUrl),
            height: 200,
            width: 200,
            alignment: Alignment.center,
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
            order.description,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Entry',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            order.entryDate,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Exit',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            order.exitDate,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'State',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                order.status == 'completed'
                    ? Icons.check_circle
                    : order.status == 'in_process'
                        ? Icons.hourglass_top
                        : Icons.cancel,
                color: order.status == 'completed'
                    ? Colors.green
                    : order.status == 'in_process'
                        ? Colors.orange
                        : Colors.red,
              ),
              const SizedBox(width: 8),
              Text(
                order.status == 'completed'
                    ? 'Finished'
                    : order.status == 'in_process'
                        ? 'In progress'
                        : 'Cancelled',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
