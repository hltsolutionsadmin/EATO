import 'package:dio/dio.dart';
import 'package:eato/core/network/dio_client.dart';
import 'package:eato/core/network/network_cubit.dart';
import 'package:eato/core/network/network_service.dart';
import 'package:eato/data/datasource/authentication/current_customer_remote_data_source.dart';
import 'package:eato/data/datasource/authentication/rolesPost_dataSource.dart';
import 'package:eato/data/datasource/authentication/signin_remote_data_source.dart';
import 'package:eato/data/datasource/authentication/signup_remote_data_source.dart';
import 'package:eato/data/datasource/authentication/trigger_otp_remote_data_source.dart';
import 'package:eato/data/datasource/cart/createCart/createCart_dataSource.dart';
import 'package:eato/data/datasource/cart/getCart/getCart_dataSource.dart';
import 'package:eato/data/datasource/cart/productsAddToCart/productsAddtoCart_dataSource.dart';
import 'package:eato/data/datasource/cart/updateCartItems/updateCartItems_dataSource.dart';
import 'package:eato/data/datasource/location/location_remotedatasource.dart';
import 'package:eato/data/datasource/restaurants/getMenuByRestaurantId/getMenuByRestaurantId_dataSource.dart';
import 'package:eato/data/datasource/restaurants/getNearbyRestaurants/getNearByrestarants_dataSource.dart';
import 'package:eato/data/repositoryImpl/authentication/current_customer_repository_impl.dart';
import 'package:eato/data/repositoryImpl/authentication/rolesPost_repoImpl.dart';
import 'package:eato/data/repositoryImpl/authentication/signin_repository_impl.dart';
import 'package:eato/data/repositoryImpl/authentication/signup_repository_impl.dart';
import 'package:eato/data/repositoryImpl/authentication/trigger_otp_repository_impl.dart';
import 'package:eato/data/repositoryImpl/cart/createCart/createCart_repoImpl.dart';
import 'package:eato/data/repositoryImpl/cart/getCart/getCart_repoImpl.dart';
import 'package:eato/data/repositoryImpl/cart/productsAddToCart/productsAddtoCart_repoImpl.dart';
import 'package:eato/data/repositoryImpl/cart/updateCartItems/updateCartItems_repoImpl.dart';
import 'package:eato/data/repositoryImpl/location/location_repoImpl.dart';
import 'package:eato/data/repositoryImpl/restaurants/getMenuByRestaurantId/getMenuByRestaurantId_repoImpl.dart';
import 'package:eato/data/repositoryImpl/restaurants/getNearbyRestaurants/getNearByrestarants_repoImpl.dart';
import 'package:eato/domain/repository/authentication/current_customer_repository.dart';
import 'package:eato/domain/repository/authentication/rolesPost_repository.dart';
import 'package:eato/domain/repository/authentication/signin_repository.dart';
import 'package:eato/domain/repository/authentication/signup_repository.dart';
import 'package:eato/domain/repository/authentication/trigger_otp_repository.dart';
import 'package:eato/domain/repository/cart/createCart/createCart_repository.dart';
import 'package:eato/domain/repository/cart/getCart/getCart_repository.dart';
import 'package:eato/domain/repository/cart/productsAddToCart/productsAddtoCart_repository.dart';
import 'package:eato/domain/repository/cart/updateCartItems/updateCartItems_repository.dart';
import 'package:eato/domain/repository/location/location_repo.dart';
import 'package:eato/domain/repository/restaurants/getMenuByRestaurantId/getMenuByRestaurantId_repository.dart';
import 'package:eato/domain/repository/restaurants/getNearbyRestaurants/getNearByrestarants_repository.dart';
import 'package:eato/domain/usecase/authentication/current_customer_usecase.dart';
import 'package:eato/domain/usecase/authentication/rolesPost_usecase.dart';
import 'package:eato/domain/usecase/authentication/signin_usecase.dart';
import 'package:eato/domain/usecase/authentication/signup_usecase.dart';
import 'package:eato/domain/usecase/authentication/trigger_otp_usecase.dart';
import 'package:eato/domain/usecase/cart/createCart/createCart_usecase.dart';
import 'package:eato/domain/usecase/cart/getCart/getCart_usecase.dart';
import 'package:eato/domain/usecase/cart/productsAddToCart/productsAddtoCart_usecase.dart';
import 'package:eato/domain/usecase/cart/updateCartItems/updateCartItems_usecase.dart';
import 'package:eato/domain/usecase/location/location_usecase.dart';
import 'package:eato/domain/usecase/restaurants/getMenuByRestaurantId/getMenuByRestaurantId_usecase.dart';
import 'package:eato/domain/usecase/restaurants/getNearbyRestaurants/getNearByrestarants_usecase.dart';
import 'package:eato/presentation/cubit/authentication/currentcustomer/current_customer_cubit.dart';
import 'package:eato/presentation/cubit/authentication/login/trigger_otp_cubit.dart';
import 'package:eato/presentation/cubit/authentication/roles/rolesPost_cubit.dart';
import 'package:eato/presentation/cubit/authentication/signUp/signup_cubit.dart';
import 'package:eato/presentation/cubit/authentication/signin/sigin_cubit.dart';
import 'package:eato/presentation/cubit/cart/createCart/createCart_cubit.dart';
import 'package:eato/presentation/cubit/cart/getCart/getCart_cubit.dart';
import 'package:eato/presentation/cubit/cart/productsAddToCart/productsAddtoCart_cubit.dart';
import 'package:eato/presentation/cubit/cart/updateCartItems/updateCartItems_cubit.dart';
import 'package:eato/presentation/cubit/location/location_cubit.dart';
import 'package:eato/presentation/cubit/restaurants/getMenuByRestaurantId/getMenuByRestaurantId_cubit.dart';
import 'package:eato/presentation/cubit/restaurants/getNearbyRestaurants/getNearByrestarants_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final GetIt sl = GetIt.instance;

void init() {
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => NetworkService());
  sl.registerLazySingleton<DioClient>(
    () => DioClient(sl<Dio>(), secureStorage: sl<FlutterSecureStorage>()),
  );

  //network
  sl.registerFactory<NetworkCubit>(() => NetworkCubit());

  sl.registerLazySingleton<TriggerOtpRemoteDataSource>(
    () => TriggerOtpRemoteDataSourceImpl(client: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<TriggerOtpRepository>(
    () => TriggerOtpRepositoryImpl(
        remoteDataSource: sl<TriggerOtpRemoteDataSource>()),
  );
  sl.registerLazySingleton(
    () => TriggerOtpValidationUseCase(repository: sl<TriggerOtpRepository>()),
  );
  sl.registerFactory(() => TriggerOtpCubit(
        useCase: sl<TriggerOtpValidationUseCase>(),
        networkService: sl<NetworkService>(),
      ));

//signin

  sl.registerLazySingleton<SignInRemoteDataSource>(
    () => SignInRemoteDataSourceImpl(client: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<SignInRepository>(
    () => SignInRepositoryImpl(remoteDataSource: sl<SignInRemoteDataSource>()),
  );
  sl.registerLazySingleton(
    () => SignInValidationUseCase(repository: sl<SignInRepository>()),
  );
  sl.registerFactory(() => SignInCubit(
        useCase: sl<SignInValidationUseCase>(),
        // createCartCubit: sl(),
      ));

  //signup

  sl.registerLazySingleton<SignUpRemoteDataSource>(
    () => SignUpRemoteDataSourceImpl(client: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<SignUpRepository>(
    () => SignUpRepositoryImpl(remoteDataSource: sl<SignUpRemoteDataSource>()),
  );
  sl.registerLazySingleton(
    () => SignUpValidationUseCase(repository: sl<SignUpRepository>()),
  );
  sl.registerFactory(() => SignUpCubit(
        useCase: sl<SignUpValidationUseCase>(),
        networkService: sl<NetworkService>(),
      ));

  //RolePost
  sl.registerLazySingleton<RolePostRemoteDatasource>(
    () => RolePostRemoteDataSourceImpl(client: sl<DioClient>().dio),
  );

  sl.registerLazySingleton<RolePostRepository>(
    () => RolePostRepoImpl(remoteDataSource: sl<RolePostRemoteDatasource>()),
  );
  sl.registerLazySingleton(
    () => RolePostUsecase(sl<RolePostRepository>()),
  );

  sl.registerFactory(() => RolePostCubit(sl<RolePostUsecase>()));

  //currentcustomer

  sl.registerLazySingleton<CurrentCustomerRemoteDataSource>(
    () => CurrentCustomerRemoteDataSourceImpl(client: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<CurrentCustomerRepository>(
    () => CurrentCustomerRepositoryImpl(
        remoteDataSource: sl<CurrentCustomerRemoteDataSource>()),
  );
  sl.registerLazySingleton(
    () => CurrentCustomerValidationUseCase(sl<CurrentCustomerRepository>()),
  );
  sl.registerFactory(() => CurrentCustomerCubit(
      sl<CurrentCustomerValidationUseCase>(), sl<NetworkService>()));

  //location//

  sl.registerLazySingleton<LocationRemoteDataSource>(
    () => LocationRemoteDataSourceImpl(client: http.Client()),
  );
  sl.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(
        remoteDataSource: sl<LocationRemoteDataSource>(),
        latLangRemoteDataSource: sl<LocationRemoteDataSource>()),
  );
  sl.registerLazySingleton(
    () => LocationUsecase(
        repository: sl<LocationRepository>(),
        latLongRepository: sl<LocationRepository>()),
  );
  sl.registerFactory(() => LocationCubit(usecase: sl<LocationUsecase>()));

  //GetNearByRestaurants

  sl.registerLazySingleton<GetNearByRestaurantsRemoteDataSource>(
    () => GetNearByRestaurantsRemoteDataSourceImpl(client: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<GetNearByRestaurantsRepository>(
    () => GetNearByRestaurantsRepositoryImpl(
        remoteDataSource: sl<GetNearByRestaurantsRemoteDataSource>()),
  );
  sl.registerLazySingleton(
    () => GetNearByRestaurantsUseCase(
        repository: sl<GetNearByRestaurantsRepository>()),
  );
  sl.registerFactory(() => GetNearbyRestaurantsCubit(
        getNearbyRestaurantsUseCase: sl<GetNearByRestaurantsUseCase>(),
      ));

  //GetMenuByRestaurantId
  sl.registerLazySingleton<GetMenuByRestaurantIdRemoteDataSource>(
    () =>
        GetMenuByRestaurantIdRemoteDataSourceImpl(client: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<GetMenuByRestaurantIdRepository>(
    () => GetMenuByRestaurantIdRepositoryImpl(
        remoteDataSource: sl<GetMenuByRestaurantIdRemoteDataSource>()),
  );
  sl.registerLazySingleton(
    () => GetMenuByRestaurantIdUseCase(
        repository: sl<GetMenuByRestaurantIdRepository>()),
  );
  sl.registerFactory(() => GetMenuByRestaurantIdCubit(
        sl<GetMenuByRestaurantIdUseCase>(),
      ));

  //CreateCart
  sl.registerLazySingleton<CreateCartRemoteDataSource>(
    () => CreateCartRemoteDataSourceImpl(client: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<CreateCartRepository>(
    () => CreateCartRepositoryImpl(
        remoteDataSource: sl<CreateCartRemoteDataSource>()),
  );
  sl.registerLazySingleton(
    () => CreateCartUseCase(repository: sl<CreateCartRepository>()),
  );
  sl.registerFactory(() => CreateCartCubit(
        sl<CreateCartUseCase>(),
      ));

  //GetCart
  sl.registerLazySingleton<GetCartRemoteDataSource>(
    () => GetCartRemoteDataSourceImpl(client: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<GetCartRepository>(
    () =>
        GetCartRepositoryImpl(remoteDataSource: sl<GetCartRemoteDataSource>()),
  );
  sl.registerLazySingleton(
    () => GetCartUseCase(repository: sl<GetCartRepository>()),
  );
  sl.registerFactory(() => GetCartCubit(
        sl<GetCartUseCase>(),
      ));

  //ProductsAddToCart
  sl.registerLazySingleton<ProductsAddToCartRemoteDataSource>(
    () => ProductsAddToCartRemoteDataSourceImpl(client: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<ProductsAddToCartRepository>(
    () => ProductsAddToCartRepositoryImpl(
        remoteDataSource: sl<ProductsAddToCartRemoteDataSource>()),
  );
  sl.registerLazySingleton(
    () =>
        ProductsAddToCartUseCase(repository: sl<ProductsAddToCartRepository>()),
  );
  sl.registerFactory(() => ProductsAddToCartCubit(
        sl<ProductsAddToCartUseCase>(),
      ));

      //UpdateCartItems
  sl.registerLazySingleton<UpdateCartItemsRemoteDataSource>(
    () => UpdateCartItemsRemoteDataSourceImpl(client: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<UpdateCartItemsRepository>(
    () => UpdateCartItemsRepositoryImpl(
        remoteDataSource: sl<UpdateCartItemsRemoteDataSource>()),
  );
  sl.registerLazySingleton(
    () =>
        UpdateCartItemsUseCase(repository: sl<UpdateCartItemsRepository>()),
  );
  sl.registerFactory(() => UpdateCartItemsCubit(
        sl<UpdateCartItemsUseCase>(),
      ));
}
