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
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
    fetchProducts();
  }

  Future<void> fetchOrders() async {
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

  Future<void> fetchProducts() async {
    final response = await http
        .get(Uri.parse('https://cartunn.up.railway.app/api/v1/products'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        products = List<Product>.from(data.map((x) => Product.fromJson(x)));
      });
    } else {
      throw Exception('Failed to load products');
    }
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
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
          )
        ],
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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order ID',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.id.toString(),
                      style: const TextStyle(fontSize: 16),
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
                      order.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 16),
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(product.image),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text(
                        'Description',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: SizedBox(
                        width: 250,
                        child: Text(product.description,
                            textAlign: TextAlign.right),
                      ),
                    ),
                    ListTile(
                      title: const Text('Price',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Text('\$${product.price}'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Order {
  final int id;
  final String name;
  final String description;
  final int code;
  final String entryDate;
  final String exitDate;
  final String status;

  Order({
    required this.id,
    required this.name,
    required this.description,
    required this.code,
    required this.entryDate,
    required this.exitDate,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      code: json['code'],
      entryDate: json['entryDate'],
      exitDate: json['exitDate'],
      status: json['status'],
    );
  }
}

class Product {
  final String title;
  final String description;
  final String image;
  final double price;

  Product({
    required this.title,
    required this.description,
    required this.image,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: json['title'],
      description: json['description'],
      image: json['image'],
      price: json['price'].toDouble(),
    );
  }
}
