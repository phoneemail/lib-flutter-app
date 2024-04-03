import 'package:flutter/material.dart';
import 'package:phone_email_auth/phone_email_auth.dart';

/// Phone email sign button with customization
///
class PhoneLoginButton extends StatelessWidget {
  /// Button label
  final String label;

  /// Button corner border radius
  final double borderRadius;

  /// Button background color
  final Color? buttonColor;

  /// Button text style
  final TextStyle? buttonTextStyle;
  final Function(String, String) onSuccess;
  final Function(String)? onFailure;

  const PhoneLoginButton({
    super.key,
    this.label = "Sign in with Phone Number",
    this.borderRadius = 4,
    this.buttonColor,
    this.buttonTextStyle,
    required this.onSuccess,
    this.onFailure,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        try {
          /*
         * Navigate to the authentication webview
         * */
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) {
                return AuthScreen();
              },
            ),
          ).then((value) {
            if (value != null && value[AppConstant.authResponse] != null) {
              final loginData = value[AppConstant.authResponse] as LoginModel;
              onSuccess.call(loginData.accessTokenn!, loginData.jwtToken!);
            }
          });
        } catch (e) {
          /// On Failure when something get broke
          onFailure?.call(e.toString());
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 3.2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.phone,
              color: Colors.white,
            ),
            SizedBox(width: 8.5),
            Text(
              label,
              style: buttonTextStyle ??
                  TextStyle(
                    color: Colors.white,
                    fontSize: 15.2,
                  ),
            ),
          ],
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor ?? Color.fromARGB(255, 4, 201, 135),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius,
          ),
        ),
      ),
    );
  }
}
