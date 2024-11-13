import 'package:cartunn/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:cartunn/features/orders/data/repositories/order_repository_impl.dart';
import 'package:cartunn/features/orders/domain/usecases/get_orders.dart';
import 'package:cartunn/features/orders/presentation/orders_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:cartunn/views/inventory/inventory.dart';
import 'package:cartunn/views/manageReturns/manage_returns.dart';
import 'package:cartunn/views/editItem/edit_item.dart';
import 'package:cartunn/views/settings/settings.dart';
import 'package:http/http.dart' as http;


void main() => runApp(const SplashScreen());

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cartunn Mobile App',
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      home: FlutterSplashScreen.scale(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF5766f5), Color(0xFF5766f5)],
        ),
        childWidget: SizedBox(
          height: 45,
          // mi logo se encuentra en la ruta assets/images/cartunn-logo.png
          child: Image.asset('assets/images/cartunn-logo.png'),
        ),
        duration: const Duration(milliseconds: 3000),
        animationDuration: const Duration(milliseconds: 500),
        onAnimationEnd: () => debugPrint("On Scale End"),
        nextScreen: const BottomNavBarApp(),
      ),
    );
  }
}

class BottomNavBarApp extends StatelessWidget {
  const BottomNavBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cartunn Mobile App',
      theme: Theme.of(context),
      home: const BottomNavBarScreen(),
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
  static final OrderRemoteDataSource remoteDataSource =
    OrderRemoteDataSourceImpl(client: http.Client());

static final OrderRepositoryImpl orderRepository =
    OrderRepositoryImpl(remoteDataSource: remoteDataSource);

static final GetOrders getOrders = GetOrders(orderRepository);

  static final List<Widget> _pages = [
  const Padding(
    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
    child: InventoryPage(),
  ),
  Padding(
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
    child: OrdersPage(getOrders: getOrders),
  ),
  const Padding(
    padding: EdgeInsets.symmetric(horizontal: 24),
    child: ManageReturnsPage(),
  ),
  const Padding(
    padding: EdgeInsets.symmetric(horizontal: 24),
    child: EditItemPage(),
  ),
  const Padding(
    padding: EdgeInsets.symmetric(horizontal: 24),
    child: SettingsPage(),
  ),
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
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 0 ? Iconsax.note4 : Iconsax.note4,
              color: _selectedIndex == 0
                  ? const Color(0xFF5766f5)
                  : Colors.black38,
            ),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 1 ? Iconsax.task_square : Iconsax.task_square,
              color: _selectedIndex == 1
                  ? const Color(0xFF5766f5)
                  : Colors.black38,
            ),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 2 ? Iconsax.book_square : Iconsax.book_square,
              color: _selectedIndex == 2
                  ? const Color(0xFF5766f5)
                  : Colors.black38,
            ),
            label: 'Manage returns',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 3 ? Iconsax.edit : Iconsax.edit,
              color: _selectedIndex == 3
                  ? const Color(0xFF5766f5)
                  : Colors.black38,
            ),
            label: 'Edit Item',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 4 ? Iconsax.setting_3 : Iconsax.setting_3,
              color: _selectedIndex == 4
                  ? const Color(0xFF5766f5)
                  : Colors.black38,
            ),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF5766f5),
        unselectedItemColor: Colors.black38,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
