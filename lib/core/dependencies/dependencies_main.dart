part of 'dependencies.dart';

final GetIt serviceLocator = GetIt.instance;
final DatabaseHelper _databaseHelper = DatabaseHelper();
final WebService _webService = WebService();
final CachedWebService _cachedWebService = CachedWebService();
Future<void> injectDependencies() async {
  // _injectOnBoarding();
  _injectHome();
  _injectCore();
  _injectTheme();
  _injectAuth();
  _injectSplash();
}

void _injectCore() {
  serviceLocator.registerLazySingleton(
    () => AuthCubit(),
  );
}

void _injectTheme() {
  // Data sources

  serviceLocator
    ..registerFactory<ThemeLocalDataSource>(
      () => ThemeLocalDataSourceImpl(
        databaseHelper: _databaseHelper,
      ),
    )

// Repositories
    ..registerFactory<ThemeRepository>(
      () => ThemeRepositoryImpl(
        serviceLocator(),
      ),
    )
// Use cases
    ..registerFactory(
      () => FetchTheme(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => SaveTheme(
        serviceLocator(),
      ),
    )

// Blocs
    ..registerLazySingleton(
      () => ThemeBloc(
        fetchTheme: serviceLocator(),
        saveTheme: serviceLocator(),
      ),
    );
}

void _injectAuth() {
  // Data sources
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        webService: _webService,
      ),
    )
    ..registerFactory<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(_databaseHelper),
    )
// Repositories
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        authRemoteDataSource: serviceLocator(),
        authLocalDataSource: serviceLocator(),
      ),
    )
// Use cases
    ..registerFactory(
      () => Login(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => Logout(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => Register(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => FetchLoginInfo(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteAccount(
        authRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => ForgotPassword(
        authRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => ResetPassword(
        authRepository: serviceLocator(),
      ),
    )
// Blocs
    ..registerLazySingleton(
      () => AuthBloc(
        login: serviceLocator(),
        logout: serviceLocator(),
        register: serviceLocator(),
        fetchLoginInfo: serviceLocator(),
        authCubit: serviceLocator(),
        deleteAccount: serviceLocator(),
        forgotPassword: serviceLocator(),
        resetPassword: serviceLocator(),
      ),
    );
}

void _injectSplash() {
// Data sources
  serviceLocator
    ..registerFactory<SplashLocalDataSource>(
      () => SplashLocalDataSourceImpl(
        db: _databaseHelper,
      ),
    )
    ..registerFactory<SplashRemoteDataSource>(
      () => SplashRemoteDataSourceImpl(webService: _webService),
    )

// Repositories
    ..registerFactory<SplashRepository>(
      () => SplashRepositoryImpl(
        splashRemoteDataSource: serviceLocator(),
        splashLocalDataSource: serviceLocator(),
      ),
    )
// Use cases
    ..registerFactory(
      () => FetchMenu(
        splashRepository: serviceLocator(),
      ),
    )

// Blocs
    ..registerLazySingleton(
      () => SplashBloc(
        fetchMenu: serviceLocator(),
      ),
    );
}

// void _injectOnBoarding() {
//   // Data sources

//   serviceLocator
//     ..registerFactory<OnboardingScreenLocalDataSource>(
//       () => OnboardingScreenLocalDataSourceImpl(),
//     )

//     // Repositories
//     ..registerFactory<OnboardingScreenRepository>(
//       () => OnboardingScreenRepositoryImpl(
//         serviceLocator(),
//       ),
//     )
//     // Use cases

//     ..registerFactory(
//       () => FetchShownStatus(
//         serviceLocator(),
//       ),
//     )
//     ..registerFactory(
//       () => SaveShownStatus(
//         serviceLocator(),
//       ),
//     )

//     // Blocs
//     ..registerLazySingleton(
//       () => ShownStatusBloc(
//         fetchShownStatus: serviceLocator(),
//         saveShownStatus: serviceLocator(),
//       ),
//     );
// }

void _injectHome() {
// Data sources

  serviceLocator
    ..registerFactory<HomeLocalDataSource>(
      () => HomeLocalDataSourceImpl(
        db: _databaseHelper,
      ),
    )
    ..registerFactory<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(webService: _cachedWebService),
    )

// Repositories
    ..registerFactory<HomeRepository>(
      () => HomeRepositoryImpl(
        homeLocalDataSource: serviceLocator(),
        homeRemoteDataSource: serviceLocator(),
      ),
    )

// Use cases
    ..registerFactory(
      () => FetchHomeBanners(
        homeRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => FetchFeaturedProducts(
        homeRepository: serviceLocator(),
      ),
    )

// Blocs
    ..registerLazySingleton(
      () => BannerBloc(
        fetchHomeBanners: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => FeaturedProductsBloc(
        fetchFeaturedProducts: serviceLocator(),
      ),
    );
}

// Data sources

// Repositories

// Use cases

// Blocs
