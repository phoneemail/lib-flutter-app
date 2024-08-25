import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:phone_email_auth/phone_email_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_udid/flutter_udid.dart';

class PhoneEmail {
  /// API key
  // late String _apiKey;

  /// Client ID
  late String _clientId;

  /// Redirect URL
  // String? _redirectUrl;

  String? _deviceId;

  static final PhoneEmail _instance = PhoneEmail();

  static initializeApp(
      {
      // required String apiKey,
      required String clientId
      // String? redirectUrl,
      }) async {
    // _instance._apiKey = apiKey;
    _instance._clientId = clientId;
    // _instance._redirectUrl = redirectUrl;

    _instance._deviceId = await getUDID();

    sharedPreference = await SharedPreferences.getInstance();
  }

  /// Get api key from initialize function
  // String get apiKey => _instance._apiKey;

  /// Get client Id from initialize function
  String get clientId => _instance._clientId;

  /// Get redirect url from initialize function
  // String? get redirectUrl => _instance._redirectUrl;

  /// Get device id from initialize function
  String? get deviceId => _instance._deviceId;

  /*
  * Check JWT token is valid or not
  * And also check is expired or not
  */
  // static bool _isValidJwtToken(String jwtToken) {
  //   try {
  //     final phoneEmail = PhoneEmail();
  //     final jwt = JWT.verify(jwtToken, SecretKey(phoneEmail.apiKey));
  //     print(jwt.payload);
  //     return jwt.payload != null;
  //   } on JWTExpiredException {
  //     print('jwt expired');
  //     return false;
  //   } on JWTException catch (ex) {
  //     print(ex.message);
  //     return false;
  //   }
  // }

  /*
  * Get email count using authorized number with JWT token
  * */
  static getEmailCount(
    String token, {
    required Function(String) onEmailCount,
  }) async {
    await PhoneEmail._getEmailCountApi(token).then((emailCount) {
      onEmailCount.call(emailCount);
    });
  }

  /*
  * Get email count using authorized number with JWT token
  * */
  static getUserInfo({
    required String accessToken,
    required String clientId,
    required Function(PhoneEmailUserModel) onSuccess,
  }) async {
    await PhoneEmail._getUserInfoApi(
      accessToken: accessToken,
      clientId: clientId,
    ).then((value) {
      final userData = PhoneEmailUserModel.fromJson(value);
      onSuccess.call(userData);
    });
  }

  /// Network Calls
  /// Get user data using clientId and Access Token
  static Future<Map<String, dynamic>> _getUserInfoApi({
    required String accessToken,
    required String clientId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstant.userUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          '${AppConstant.accessTokenn}': accessToken,
          '${AppConstant.clientId}': clientId,
        },
      );
      if (response.statusCode == 200) {
        /// Return user details
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load email count');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load email count');
    }
  }

  static Future<String> _getEmailCountApi(String jwtToken) async {
    try {
      // if (!_isValidJwtToken(jwtToken)) {
      //   return "Invalid Token";
      // }
      final response = await http.post(
        Uri.parse(AppConstant.emailUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'${AppConstant.merchantEmailJwtToken}': jwtToken},
      );
      if (response.statusCode == 200) {
        /// Return total number of email count
        return response.body;
      } else {
        throw Exception('Failed to load email count');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load email count');
    }
  }

  static Future<String?> getUDID() async {
    String udid = await FlutterUdid.udid;
    return udid;
  }
}
