import 'package:cartunn/features/manageRefunds/data/datasources/manage_refund_remote_datasource.dart';
import 'package:cartunn/features/manageRefunds/data/repository/manage_refund_repository_impl.dart';
import 'package:cartunn/features/manageRefunds/domain/repository/manage_refund_repository.dart';
import 'package:cartunn/features/manageRefunds/domain/usecases/get_products_refunds_usecase.dart';
import 'package:cartunn/features/settings/data/repositories/profile_repository_impl.dart';
import 'package:cartunn/features/settings/domain/repositories/profile_repository.dart';
import 'package:cartunn/features/settings/domain/usescases/get_profile_usecase.dart';
import 'package:cartunn/features/settings/domain/usescases/update_profile_usecase.dart';
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
  
  getIt.registerLazySingleton(() => InventoryRemoteDatasource());
  getIt.registerLazySingleton<InventoryRepository>(
    () => InventoryRepositoryImpl(remoteDatasource: getIt()),
  );
  getIt.registerLazySingleton(
    () => GetProductsUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(() => ManageRefundRemoteDatasource());
  getIt.registerLazySingleton<ManageRefundRepository>(
    () => ManageRefundRepositoryImpl(remoteDatasource: getIt()),
  );
  getIt.registerLazySingleton(
    () => GetProductsRefundsUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(baseUrl: 'https://cartunn.up.railway.app/api/v1'));

  getIt.registerLazySingleton<GetProfileUsecase>(() => GetProfileUsecase(getIt<ProfileRepository>()));
  getIt.registerLazySingleton<UpdateProfileUsecase>(() => UpdateProfileUsecase(getIt<ProfileRepository>()));

  // Registra el profileId si es un valor fijo, o asegúrate de configurarlo dinámicamente
  //morì jijij
  getIt.registerSingleton<int>(1); 

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