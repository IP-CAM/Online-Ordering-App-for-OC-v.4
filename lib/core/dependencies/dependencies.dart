import 'package:get_it/get_it.dart';
import 'package:ordering_app/core/common/cubits/cubit/auth_cubit.dart';
import 'package:ordering_app/core/utils/database_helper.dart';
import 'package:ordering_app/core/utils/web_service.dart';
import 'package:ordering_app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:ordering_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:ordering_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ordering_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:ordering_app/features/auth/domain/use_cases/fetch_login_info.dart';
import 'package:ordering_app/features/auth/domain/use_cases/login.dart';
import 'package:ordering_app/features/auth/domain/use_cases/logout.dart';
import 'package:ordering_app/features/auth/domain/use_cases/register.dart';
import 'package:ordering_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ordering_app/features/theme/data/data_sources/theme_local_data_source.dart';
import 'package:ordering_app/features/theme/data/repositories/theme_repository_impl.dart';
import 'package:ordering_app/features/theme/domain/repositories/theme_repository.dart';
import 'package:ordering_app/features/theme/domain/use_cases/fetch_theme.dart';
import 'package:ordering_app/features/theme/domain/use_cases/save_theme.dart';
import 'package:ordering_app/features/theme/presentation/bloc/theme_bloc.dart';



part 'dependencies_main.dart';
