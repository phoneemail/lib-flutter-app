class PhoneEmailUserModel {
  final int? status;
  final String? countryCode;
  final String? phoneNumber;
  final String? phEmailJwt;
  final String? firstName;
  final String? lastName;

  PhoneEmailUserModel({
    this.status,
    this.countryCode,
    this.phoneNumber,
    this.phEmailJwt,
    this.firstName,
    this.lastName
  });

  factory PhoneEmailUserModel.fromJson(Map<String, dynamic> json) {
    return PhoneEmailUserModel(
        status: json['status'],
        countryCode: json['country_code'],
        phoneNumber: json['phone_no'],
        phEmailJwt: json['ph_email_jwt'],
        firstName : json['first_name'],
        lastName : json['last_name']
    );
  }
}
