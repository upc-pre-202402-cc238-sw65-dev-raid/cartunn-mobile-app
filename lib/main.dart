import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cartunn/features/auth/presentation/pages/login_page.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:cartunn/features/inventory/data/datasources/inventory_remote_datasource.dart';
import 'package:cartunn/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:cartunn/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:cartunn/features/inventory/domain/usecases/get_products_usecase.dart';
import 'package:cartunn/features/auth/data/remote/auth_service.dart';
import 'package:cartunn/features/auth/presentation/blocs/login_bloc.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  // HTTP Client
  getIt.registerLazySingleton(() => http.Client());
  
  // Auth Service
  getIt.registerLazySingleton(() => AuthService());
  
  // Login Bloc
  getIt.registerFactory(() => LoginBloc(getIt<AuthService>()));
  
  // Inventory Dependencies
  getIt.registerLazySingleton(() => InventoryRemoteDatasource());
  getIt.registerLazySingleton<InventoryRepository>(
    () => InventoryRepositoryImpl(remoteDatasource: getIt()),
  );
  getIt.registerLazySingleton(
    () => GetProductsUseCase(repository: getIt()),
  );
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupGetIt();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => getIt<LoginBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cartunn Mobile App',
        theme: ThemeData(fontFamily: 'Poppins'),
        home: const LoginPage(),
      ),
    );
  }
}