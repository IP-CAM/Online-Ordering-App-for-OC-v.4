part of 'dependencies.dart';

final GetIt serviceLocator = GetIt.instance;
final DatabaseHelper _databaseHelper = DatabaseHelper();
final WebService _webService = WebService();

Future<void> injectDependencies() async {
  // _injectOnBoarding();
  // _injectHome();
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
// Blocs
    ..registerLazySingleton(
      () => AuthBloc(
        login: serviceLocator(),
        logout: serviceLocator(),
        register: serviceLocator(),
        fetchLoginInfo: serviceLocator(),
        authCubit: serviceLocator(),
      ),
    );
}

void _injectSplash() {
// Data sources
  serviceLocator
    ..registerFactory<SplashLocalDataSource>(
      () => SplashLocalDataSourceImpl(
        _databaseHelper,
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

// void _injectHome() {
// // Data sources

//   serviceLocator
//     ..registerFactory<HomeLocalDataSource>(
//       () => HomeLocalDataSourceImpl(),
//     )

// // Repositories
//     ..registerFactory<HomeRepository>(
//       () => HomeRepositoryImpl(
//         serviceLocator(),
//       ),
//     )
// // Use cases
//     ..registerFactory(
//       () => AddTopic(
//         serviceLocator(),
//       ),
//     )
//     ..registerFactory(
//       () => AddQuestionAndAnswer(
//         serviceLocator(),
//       ),
//     )
//     ..registerFactory(
//       () => RemoveTopic(
//         serviceLocator(),
//       ),
//     )
//     ..registerFactory(
//       () => RemoveQuestionAndAnswers(
//         serviceLocator(),
//       ),
//     )
//     ..registerFactory(
//       () => UpdateTopic(
//         serviceLocator(),
//       ),
//     )
//     ..registerFactory(
//       () => UpdateQuestionAndAnswer(
//         serviceLocator(),
//       ),
//     )
//     ..registerFactory(
//       () => GetTopics(
//         serviceLocator(),
//       ),
//     )
//     ..registerFactory(
//       () => GetQuestionAndAnswer(
//         serviceLocator(),
//       ),
//     )
// // Blocs
//     ..registerLazySingleton(
//       () => TopicBloc(
//         addTopic: serviceLocator(),
//         removeTopic: serviceLocator(),
//         updateTopic: serviceLocator(),
//         getTopics: serviceLocator(),
//       ),
//     );
// }

// Data sources

// Repositories

// Use cases

// Blocs