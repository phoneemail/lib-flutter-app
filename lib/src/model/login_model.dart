class LoginModel {
  final String? accessTokenn;
  final String? clientId;
  final bool? isVerify;
  final String? jwtToken;

  LoginModel({
    this.accessTokenn,
    this.clientId,
    this.isVerify,
    this.jwtToken,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      accessTokenn: json['access_token'],
      clientId: json['client_id'],
      isVerify: json['is_verify'],
      jwtToken: json['jwt']
    );
  }
}
