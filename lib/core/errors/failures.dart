class Failure {
  final String message;
  Failure([this.message = 'An unexpected error occurred!']);
}

/// Represents a failure that occurred while interacting with the database
class DatabaseFailure extends Failure {
  DatabaseFailure(super.message);
}

/// Represents a failure that occurred in the application logic
class AppFailure extends Failure {
  AppFailure(super.message);
}

/// Represents an unexpected failure
class UnexpectedFailure extends Failure {
  UnexpectedFailure(super.message);
}
