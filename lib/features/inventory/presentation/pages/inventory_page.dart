import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cartunn/views/uploadItem/upload_item.dart';
import 'package:cartunn/components/draggable_sheet_component.dart';
import 'package:cartunn/features/inventory/domain/entities/product.dart';
import 'package:cartunn/features/inventory/domain/usecases/get_products_usecase.dart';
import 'package:cartunn/features/inventory/presentation/widgets/product_detail_content.dart';
import 'package:cartunn/shared/presentation/widgets/search_input.dart';

class InventoryView extends StatefulWidget {
  final GetProductsUseCase getProductsUseCase;

  const InventoryView({Key? key, required this.getProductsUseCase})
      : super(key: key);

  @override
  InventoryViewState createState() => InventoryViewState();
}

class InventoryViewState extends State<InventoryView> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    searchController.addListener(() {
      filterProducts();
    });
  }

  Future<void> _fetchProducts() async {
    final result = await widget.getProductsUseCase.call();
    setState(() {
      products = result;
      filteredProducts = products.reversed.toList();
    });
  }

  void filterProducts() {
    String searchText = searchController.text.toLowerCase();
    setState(() {
      filteredProducts = products.reversed
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
      appBar: AppBar(
        title: const Text(
          'Inventory',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: SearchInput(
                controller: searchController,
                hintText: "Write here ...",
                onChanged: (value) {
                  filterProducts();
                }),
            floating: true,
            pinned: true,
            titleSpacing: 0,
            toolbarHeight: 80,
            leadingWidth: 8,
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = filteredProducts[index];
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
                              fit: BoxFit.cover,
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
              childCount: filteredProducts.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
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
