part of 'dependencies.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> injectDependencies() async {
  serviceLocator
    ..registerLazySingleton(
      () => DatabaseHelper(),
    )
    ..registerLazySingleton(
      () => WebService(),
    )
    ..registerLazySingleton(
      () => CachedWebService(),
    );

  // _injectOnBoarding();
  _injectHome();
  _injectCore();
  _injectTheme();
  _injectAuth();
  _injectSplash();
  _injectAddressBook();
  _injectAbout();
  _injectMenu();
  _injectCart();
  _injectCheckout();
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
        databaseHelper: serviceLocator(),
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
        webService: serviceLocator(),
      ),
    )
    ..registerFactory<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(
        serviceLocator(),
      ),
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
        db: serviceLocator(),
      ),
    )
    ..registerFactory<SplashRemoteDataSource>(
      () => SplashRemoteDataSourceImpl(
        webService: serviceLocator(),
      ),
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
    ..registerFactory<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(
        webService: serviceLocator(),
      ),
    )

// Repositories
    ..registerFactory<HomeRepository>(
      () => HomeRepositoryImpl(
        menuLocalDataSource: serviceLocator(),
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

void _injectAddressBook() {
// Data sources

  serviceLocator
    ..registerFactory<AddressBookRemoteDataSource>(
      () => AddressBookRemoteDataSourceImpl(
        webService: serviceLocator(),
      ),
    )

// Repositories

    ..registerFactory<AddressBookRepository>(
      () => AddressBookRepositoryImpl(
          addressBookRemoteDataSource: serviceLocator()),
    )

// Use cases

    ..registerFactory(
      () => FetchAddressList(addressBookRepository: serviceLocator()),
    )
    ..registerFactory(
      () => FetchCountryList(addressBookRepository: serviceLocator()),
    )
    ..registerFactory(
      () => FetchZoneList(addressBookRepository: serviceLocator()),
    )
    ..registerFactory(
      () => SaveAddress(
        addressBookRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteAddress(addressBookRepository: serviceLocator()),
    )

// Blocs
    ..registerLazySingleton(
      () => AddressBookBloc(
        fetchCountryList: serviceLocator(),
        fetchAddressList: serviceLocator(),
        fetchZoneList: serviceLocator(),
        deleteAddress: serviceLocator(),
        saveAddress: serviceLocator(),
      ),
    );
}

void _injectAbout() {
// Data sources
  serviceLocator
    ..registerFactory<AboutRemoteDataSource>(
      () => AboutRemoteDataSourceImpl(
        cachedWebService: serviceLocator(),
      ),
    )
// Repositories
    ..registerFactory<AboutRepository>(
      () => AboutRepositoryImpl(
        aboutRemoteDataSource: serviceLocator(),
      ),
    )
// Use cases
    ..registerFactory(
      () => FetchInfo(
        aboutRepository: serviceLocator(),
      ),
    )
// Blocs
    ..registerLazySingleton(
      () => InfoBloc(
        fetchInfo: serviceLocator(),
      ),
    );
}

void _injectMenu() {
// Data sources

  serviceLocator
    ..registerFactory<MenuLocalDataSource>(
      () => MenuLocalDataSourceImpl(
        databaseHelper: serviceLocator(),
      ),
    )
    ..registerFactory<MenuRemoteDataSource>(
      () => MenuRemoteDataSourceImpl(
        webService: serviceLocator(),
      ),
    )

// Repositories
    ..registerFactory<MenuRepository>(
      () => MenuRepositoryImpl(
        menuLocalDataSource: serviceLocator(),
        menuRemoteDataSource: serviceLocator(),
      ),
    )
// Use cases
    ..registerFactory(
      () => FetchCategories(
        menuRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => FetchProducts(
        menuRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => AddToCart(
        menuRepository: serviceLocator(),
      ),
    )
// Blocs
    ..registerLazySingleton(
      () => MenuBloc(
        fetchCategories: serviceLocator(),
        fetchProducts: serviceLocator(),
        addToCart: serviceLocator(),
      ),
    );
}

void _injectCart() {
// Data sources
  serviceLocator
    ..registerFactory<CartRemoteDataSource>(
      () => CartRemoteDataSourceImpl(
        webService: serviceLocator(),
      ),
    )
// Repositories
    ..registerFactory<CartRepository>(
      () => CartRepositoryImpl(
        cartRemoteDataSource: serviceLocator(),
      ),
    )
// Use cases
    ..registerFactory(
      () => FetchCart(
        cartRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateCart(
        cartRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => RemoveItem(
        cartRepository: serviceLocator(),
      ),
    )
// Blocs
    ..registerLazySingleton(
      () => CartBloc(
        fetchCart: serviceLocator(),
        removeItem: serviceLocator(),
        updateCart: serviceLocator(),
      ),
    );
}

void _injectCheckout() {
// Data sources
  serviceLocator
    ..registerFactory<CheckoutRemoteDataSource>(
      () => CheckoutRemoteDataSourceImpl(
        webService: serviceLocator(),
      ),
    )

// Repositories
    ..registerFactory<CheckoutRepository>(
      () => CheckoutRepositoryImpl(
        checkoutRemoteDataSource: serviceLocator(),
      ),
    )
// Use cases

    ..registerFactory(
      () => ConfirmOrder(
        checkoutRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => FetchPaymentMethods(
        checkoutRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => FetchShippingMethods(
        checkoutRepository: serviceLocator(),
      ),
    )

    ..registerFactory(
      () => SetPaymentMethod(
        checkoutRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => SetShippingAddress(
        checkoutRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => SetShippingMethod(
        checkoutRepository: serviceLocator(),
      ),
    )

// Blocs
    ..registerLazySingleton(
      () => CheckoutBloc(
        confirmOrder: serviceLocator(),
        fetchPaymentMethods: serviceLocator(),
        fetchShippingMethods: serviceLocator(),
        setPaymentMethod: serviceLocator(),
        setShippingAddress: serviceLocator(),
        setShippingMethod: serviceLocator(),
      ),
    );
}

// Data sources

// Repositories

// Use cases

// Blocs
