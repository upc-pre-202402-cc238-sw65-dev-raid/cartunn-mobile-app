import 'package:cartunn/features/manageRefunds/data/datasources/manage_refund_remote_datasource.dart';
import 'package:cartunn/features/manageRefunds/data/repository/manage_refund_repository_impl.dart';
import 'package:cartunn/features/manageRefunds/domain/repository/manage_refund_repository.dart';
import 'package:cartunn/features/manageRefunds/domain/usecases/get_products_refunds_usecase.dart';
import 'package:cartunn/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:cartunn/features/orders/data/repositories/order_repository_impl.dart';
import 'package:cartunn/features/orders/domain/repositories/order_repository.dart';
import 'package:cartunn/features/orders/domain/usecases/get_orders_usecase.dart';
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
  getIt.registerLazySingleton(() => http.Client());

  getIt.registerLazySingleton(() => AuthService());
  getIt.registerFactory(() => LoginBloc(getIt<AuthService>()));
  //inventory
  getIt.registerLazySingleton<InventoryRemoteDatasource>(
    () => InventoryRemoteDatasource(getIt<AuthService>()),
  );
  getIt.registerLazySingleton<InventoryRepository>(
    () => InventoryRepositoryImpl(remoteDatasource: getIt()),
  );
  getIt.registerLazySingleton(
    () => GetProductsUseCase(repository: getIt()),
  );
  //Orders
  getIt.registerLazySingleton(() => OrderRemoteDataSource(getIt<AuthService>()));
  getIt.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(remoteDataSource: getIt()),
  );
   getIt.registerLazySingleton(
    () => GetOrdersUsecase(repository: getIt()),
  );

  //Manage Refunds
  getIt.registerLazySingleton<ManageRefundRemoteDatasource>(
    () => ManageRefundRemoteDatasource(getIt<AuthService>()), // Inyecta AuthService
  );
  getIt.registerLazySingleton<ManageRefundRepository>(
    () => ManageRefundRepositoryImpl(remoteDatasource: getIt()),
  );
  getIt.registerLazySingleton(
    () => GetProductsRefundsUseCase(repository: getIt()),
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