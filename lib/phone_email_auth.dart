library phone_email_auth;

import 'package:shared_preferences/shared_preferences.dart';

export 'package:phone_email_auth/src/services.dart';
export 'package:phone_email_auth/src/auth_view.dart';
export 'package:phone_email_auth/src/sign_in_button.dart';
export 'package:phone_email_auth/src/email_alert_button.dart';
export 'package:phone_email_auth/src/constants.dart';
export 'package:phone_email_auth/src/model/user_model.dart';
export 'package:phone_email_auth/src/model/login_model.dart';
export 'package:phone_email_auth/src/email_list_view.dart';

SharedPreferences? sharedPreference;
