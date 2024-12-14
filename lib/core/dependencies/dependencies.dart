import 'package:get_it/get_it.dart';
import 'package:ordering_app/core/utils/database_helper.dart';
import 'package:ordering_app/features/theme/data/data_sources/theme_local_data_source.dart';
import 'package:ordering_app/features/theme/data/repositories/theme_repository_impl.dart';
import 'package:ordering_app/features/theme/domain/repositories/theme_repository.dart';
import 'package:ordering_app/features/theme/domain/use_cases/fetch_theme.dart';
import 'package:ordering_app/features/theme/domain/use_cases/save_theme.dart';
import 'package:ordering_app/features/theme/presentation/bloc/theme_bloc.dart';



part 'dependencies_main.dart';
