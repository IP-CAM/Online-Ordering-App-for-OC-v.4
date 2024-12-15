class LoginInfoEntity {
  final String token;
  final String deviceId;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? telephone;
  final String? expiresAt;

  LoginInfoEntity({
    required this.token,
    required this.deviceId,
    this.email,
    this.firstName,
    this.lastName,
    this.telephone,
    this.expiresAt,
  });
}
