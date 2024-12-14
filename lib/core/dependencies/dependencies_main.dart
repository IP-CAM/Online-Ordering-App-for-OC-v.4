part of 'dependencies.dart';

final GetIt serviceLocator = GetIt.instance;
final DatabaseHelper _databaseHelper = DatabaseHelper();

Future<void> injectDependencies() async {
  // _injectOnBoarding();
  // _injectHome();

  _injectTheme();
}

void _injectTheme() {
  // Data sources

  serviceLocator
    ..registerFactory<ThemeLocalDataSource>(
      () => ThemeLocalDataSourceImpl(
        _databaseHelper,
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