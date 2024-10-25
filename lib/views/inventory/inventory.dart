import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:cartunn/views/uploadItem/upload_item.dart';
import './entity/product.dart';
import 'package:cartunn/components/draggable_sheet_component.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
    searchController.addListener(() {
      filterProducts();
    });
  }

  Future<void> fetchProducts() async {
    final response = await http
        .get(Uri.parse('https://cartunn.up.railway.app/api/v1/products'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        products =
            List<Product>.from(data.map((x) => Product.fromJson(x))).toList();
        filteredProducts = products;
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  void filterProducts() {
    String searchText = searchController.text.toLowerCase();
    setState(() {
      filteredProducts = products
          .where((product) => product.title.toLowerCase().contains(searchText))
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
            child: Text('Inventory',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                )),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final product = filteredProducts.reversed.toList()[index];
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
                                child: ProductDetailContent(product: product),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              product.image,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Mostrar el modal y esperar el nuevo producto
          final newProduct = await showModalBottomSheet<Product>(
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
                    child: const DraggableSheetComponent(
                      child: UploadItemPage(),
                    ),
                  ),
                ],
              ),
            ),
          );
          if (newProduct != null) {
            setState(() {
              products.insert(0, newProduct);
              filterProducts();
            });
          }
        },
        backgroundColor: const Color(0xFF5766f5),
        child: const Icon(
          Iconsax.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ProductDetailContent extends StatelessWidget {
  final Product product;

  const ProductDetailContent({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            product.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: Image.network(
              product.image,
              height: 200,
              fit: BoxFit.contain,
            ),
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
            product.description,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Price',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '\$${product.price}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
