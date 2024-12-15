import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/exceptions.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:ordering_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:ordering_app/features/auth/data/models/login_info_model.dart';
import 'package:ordering_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource authRemoteDataSource,
    required AuthLocalDataSource authLocalDataSource,
  })  : _authLocalDataSource = authLocalDataSource,
        _authRemoteDataSource = authRemoteDataSource;

  @override
  Future<Either<Failure, LoginInfoModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _authRemoteDataSource.login(
        email: email,
        password: password,
      );
      await _authLocalDataSource.login(
        authInfo: res,
      );
      return right(res);
    } on AppException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _authLocalDataSource.logout();
      final authInfo = await _authLocalDataSource.getLoginInfo();

      await _authRemoteDataSource.logout(customerToken: authInfo!.token);
      return right(null);
    } on AppException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, LoginInfoModel>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String telephone,
    required String password,
    required String confirm,
    required bool agree,
    required bool newsletter,
  }) async {
    try {
      final res = await _authRemoteDataSource.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        telephone: telephone,
        password: password,
        confirm: confirm,
        agree: agree,
        newsletter: newsletter,
      );
      await _authLocalDataSource.login(
        authInfo: res,
      );

      return right(res);
    } on AppException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, LoginInfoModel>> getLoginInfo() async {
    try {
      final res = await _authLocalDataSource.getLoginInfo();
      if (res == null) {
        return left(Failure('No user found!'));
      } else {
        final validateRes = await _authRemoteDataSource.validateToken(
          customerToken: res.token,
          deviceId: res.deviceId,
        );
        if (!validateRes) {
          return left(Failure('User session expired!'));
        }
      }
      return right(res);
    } on AppException catch (e) {
      return left(Failure(e.message));
    }
  }
}
