class AppException implements Exception{

  final String message;

  AppException(this.message);


}
class DatabaseException extends AppException {
  DatabaseException(super.message);
}