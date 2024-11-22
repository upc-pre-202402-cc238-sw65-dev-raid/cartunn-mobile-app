import 'package:cartunn/features/orders/presentation/widgets/order_detail_content.dart';
import 'package:flutter/material.dart';
import 'package:cartunn/features/orders/domain/entities/order.dart';
import 'package:cartunn/features/orders/domain/usecases/get_orders_usecase.dart';
import 'package:cartunn/shared/presentation/widgets/search_input.dart';
import 'package:cartunn/shared/presentation/widgets/draggable_sheet_component.dart';

class OrdersPage extends StatefulWidget {
  final GetOrdersUsecase getOrdersUsecase;

  const OrdersPage({Key? key, required this.getOrdersUsecase})
      : super(key: key);

  @override
  OrdersPageState createState() => OrdersPageState();
}

class OrdersPageState extends State<OrdersPage> {
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
    final fetchedOrders = await widget.getOrdersUsecase.call();
    setState(() {
      orders = fetchedOrders;
      filteredOrders = orders.reversed.toList();
    });
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
      appBar: AppBar(
        title: const Text(
          'Orders',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await fetchOrders();
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: SearchInput(
                controller: searchController,
                hintText: "Search orders...",
                onChanged: (value) {
                  filterOrders();
                },
              ),
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
                  final order = filteredOrders[index];
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
                                  child: OrderDetailContent(order: order),
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
                                order.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              order.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: filteredOrders.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
