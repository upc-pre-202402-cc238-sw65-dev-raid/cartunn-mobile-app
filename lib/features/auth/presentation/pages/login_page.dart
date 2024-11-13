import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cartunn/features/auth/presentation/blocs/login_bloc.dart';
import 'package:cartunn/features/auth/presentation/blocs/login_event.dart';
import 'package:cartunn/features/auth/presentation/blocs/login_state.dart';
import 'package:get_it/get_it.dart';
import 'package:cartunn/features/inventory/presentation/pages/inventory_page.dart';
import 'package:cartunn/views/orders/orders.dart';
import 'package:cartunn/views/manageReturns/manage_returns.dart';
import 'package:cartunn/views/editItem/edit_item.dart';
import 'package:cartunn/views/settings/settings.dart';
import 'package:cartunn/features/inventory/domain/usecases/get_products_usecase.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    return isAuthenticated
        ? const BottomNavBarScreen()
        : Scaffold(
            body: SafeArea(
              child: BlocConsumer<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is LoginSuccess) {
                    setState(() {
                      isAuthenticated = true;
                    });
                  } else if (state is LoginError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(24, 0, 24, 8),
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                            child: TextField(
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(),
                                labelText: 'Username',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                            child: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                            child: SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {
                                  final username = _usernameController.text;
                                  final password = _passwordController.text;
                                  context.read<LoginBloc>().add(
                                        LoginSubmitted(
                                          username: username,
                                          password: password,
                                        ),
                                      );
                                },
                                child: const Text('Login'),
                              ),
                            ),
                          )
                        ],
                      ),
                      if (state is LoginLoading)
                        const Center(child: CircularProgressIndicator()),
                    ],
                  );
                },
              ),
            ),
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
      icon: Icon(
        icon,
        color: _selectedIndex == index ? const Color(0xFF5766f5) : Colors.black38,
      ),
      label: label,
    );
  }
}
