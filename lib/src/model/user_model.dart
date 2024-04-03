class PhoneEmailUserModel {
  final int? status;
  final String? countryCode;
  final String? phoneNumber;
  final String? phEmailJwt;

  PhoneEmailUserModel({
    this.status,
    this.countryCode,
    this.phoneNumber,
    this.phEmailJwt,
  });

  factory PhoneEmailUserModel.fromJson(Map<String, dynamic> json) {
    return PhoneEmailUserModel(
        status: json['status'],
        countryCode: json['country_code'],
        phoneNumber: json['phone_no'],
        phEmailJwt: json['ph_email_jwt']);
  }
}
