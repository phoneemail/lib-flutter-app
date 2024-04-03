import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:phone_email_auth/phone_email_auth.dart';

class EmailListView extends StatefulWidget {
  const EmailListView({super.key});

  @override
  State<EmailListView> createState() => _EmailListViewState();
}

class _EmailListViewState extends State<EmailListView> {
  InAppWebViewController? emailWebViewController;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (pop) async {
        if (await emailWebViewController!.canGoBack()) {
          /// Go back till first page
          emailWebViewController!.goBack();
        } else {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppConstant.emailListTitle,
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
        ),
        body: InAppWebView(
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            mediaPlaybackRequiresUserGesture: false,
            cacheEnabled: true,
            allowsInlineMediaPlayback: true,
          ),
          onWebViewCreated: (controller) async {
            /// set webview controller
            emailWebViewController = controller;
            emailWebViewController!.loadUrl(
              urlRequest: URLRequest(
                url: WebUri(AppConstant.emailListUrl),
              ),
            );
          },
        ),
      ),
    );
  }
}
