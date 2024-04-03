# phone_email_auth plugin

Flutter plugin for authenticating phone number. this plugin send OTP to mobile numbers and verify it and return verified  mobile number to user. 

# Getting Started

Install

```
    dependencies:
    phone_email_auth: ^0.0.1
```

Import

```
    import 'package:phone_email_auth/phone_email_auth.dart';
```

Initialize phone email plugin

```
    PhoneEmail.initializeApp(clientId: 'YOUR_CLIENT_ID',);
```

## Note:
clientId : Set clientId which you obtained from Profile Details section of [Admin Dashboard](https://admin.phone.email/) of Phone Email.


# Add Phone Email Login Button

```dart
    
    child: PhoneLoginButton(
    borderRadius: 8,
    buttonColor: Colors.teal,
    label: 'Sign in with Phone',
    onSuccess: (String accessToken, String jwtToken) {
      if (accessToken.isNotEmpty) {
        setState(() {
          userAccessToken = accessToken;
          jwtUserToken = jwtToken;
          hasUserLogin = true;
        });
      }
    },
    )
```

The PhoneLoginButton will return the `accessToken` and `jwtToken`, which are necessary for obtaining the verified phone number.

# Get Verified phone number:

Once you've obtained the `accessToken`, get verified phone number by calling the `getUserInfo()` function. Use the following code snippet to retrieve the verified phone number.

```dart
        PhoneEmail.getUserInfo(
        accessToken: userAccessToken,
        clientId: phoneEmail.clientId,
        onSuccess: (userData) {
            setState(() {
            phoneEmailUserModel = userData;
            var countryCode = phoneEmailUserModel?.countryCode;
            var phoneNumber = phoneEmailUserModel?.phoneNumber;

            // Use this verified phone number to register user and create your session

            });
        },
        );
```

# Display Email Alert:

Integrate an email alert icon on your screen for a successfully authenticated user. Use the following code snippet to fetch the unread email count and display the email icon.

```dart
        floatingActionButton: hasUserLogin
            ? EmailAlertButton(
            jwtToken: jwtUserToken,
            ) : const Offstage(),
        );
```







