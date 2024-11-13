import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cartunn/features/inventory/presentation/pages/inventory_page.dart';
import 'package:cartunn/views/orders/orders.dart';
import 'package:cartunn/views/manageReturns/manage_returns.dart';
import 'package:cartunn/views/editItem/edit_item.dart';
import 'package:cartunn/views/settings/settings.dart';
import 'package:get_it/get_it.dart';
import 'package:cartunn/features/inventory/domain/usecases/get_products_usecase.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: InventoryView(
        getProductsUseCase: GetIt.I<GetProductsUseCase>(),
      ),
    ),
    const OrdersPage(),
    const ManageReturnsPage(),
    const EditItemPage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF5766f5),
        unselectedItemColor: Colors.black38,
        items: [
          _buildBottomNavigationBarItem(Iconsax.note4, 'Inventory', 0),
          _buildBottomNavigationBarItem(Iconsax.task_square, 'Orders', 1),
          _buildBottomNavigationBarItem(Iconsax.book_square, 'Manage Returns', 2),
          _buildBottomNavigationBarItem(Iconsax.edit, 'Edit Item', 3),
          _buildBottomNavigationBarItem(Iconsax.setting_3, 'Settings', 4),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Icon(icon, color: _selectedIndex == index ? const Color(0xFF5766f5) : Colors.black38),
      label: label,
    );
  }
}