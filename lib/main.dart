import 'package:flutter/material.dart';
import 'package:cartunn/views/orders/orders.dart';
import 'package:cartunn/views/manageReturns/manage_returns.dart';
import 'package:cartunn/views/editItem/edit_item.dart';
import 'package:cartunn/views/help&Center/help_center.dart';
import 'package:cartunn/views/settings/settings.dart';

void main() => runApp(const BottomNavBarApp());

class BottomNavBarApp extends StatelessWidget {
  const BottomNavBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cartunn Mobile App',
      home: BottomNavBarScreen(),
    );
  }
}

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    OrdersPage(),
    ManageReturnsPage(),
    EditItemPage(),
    HelpCenterPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cartunn Application'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w900,
        ),
        backgroundColor: const Color(0xFF5766f5),
      ),
      body: _pages[_selectedIndex], // Cambia el cuerpo dinámicamente
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Manage returns',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Edit Item',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_center),
            label: 'Help & Center',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.black38,
        selectedItemColor: const Color(0xFF5766f5),
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}