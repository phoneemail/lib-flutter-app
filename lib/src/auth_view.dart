import 'package:flutter/material.dart';
import 'package:phone_email_auth/phone_email_auth.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey webViewKey = GlobalKey();

  /// InAppWebView Controller
  InAppWebViewController? webViewController;

  /// Initial Authentication URL
  late String authenticationUrl;

  /// Unique device token
  String? deviceId;

  @override
  void initState() {
    super.initState();
  }

  Future<void> inAppWebViewConfiguration(
      InAppWebViewController controller) async {
    final _phoneEmail = PhoneEmail();

    if(_phoneEmail.deviceId!.isNotEmpty){
      deviceId = _phoneEmail.deviceId;
      print('deviceId pref: $deviceId');
    }else{
      /// Get Unique device token
      deviceId = await PhoneEmail.getUDID();
      print('deviceId API: $deviceId');
    }

    /// Build authentication url with registered details
    authenticationUrl = "${AppConstant.authUrl}?" +
        "${AppConstant.clientId}=${_phoneEmail.clientId}" +
        "&${AppConstant.device}=${deviceId ?? ""}" +
        // "&${AppConstant.redirectUrl}=${_phoneEmail.redirectUrl ?? ""}" +
        "&${AppConstant.authType}=5";

    print('Authentication URL: $authenticationUrl');

    /// Load authentication url in WebView
    webViewController!.loadUrl(
      urlRequest: URLRequest(url: WebUri(authenticationUrl)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppConstant.authViewTitle,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.close_rounded),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Color.fromARGB(255, 4, 201, 135),
          // backgroundColor: Color.fr
        ),
        body: InAppWebView(
          key: webViewKey,
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            mediaPlaybackRequiresUserGesture: false,
            cacheEnabled: true,
            allowsInlineMediaPlayback: true,
          ),
          onWebViewCreated: (controller) async {
            /// set webview controller
            webViewController = controller;

            /*
            * Call configuration method and build auth URL
            * */
            inAppWebViewConfiguration(controller);
          },
          onLoadStart: (controller, url) {
            /// callback method for listen response
            webViewController!.addJavaScriptHandler(
              handlerName: AppConstant.sendTokenToApp,
              callback: (arguments) {
                print("Success Data :: $arguments");

                /// Get access token from JS and pop back to main screen
                print(arguments.first.runtimeType);
                Navigator.pop(
                  context,
                  {
                    AppConstant.authResponse:
                        LoginModel.fromJson(arguments.first),
                  },
                );
              },
            );
          },
          onReceivedError: (controller, request, error) {
            print("Error ============>>>>>${error.description}");
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
