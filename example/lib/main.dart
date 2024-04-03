import 'package:flutter/material.dart';
import 'package:phone_email_auth/phone_email_auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize phone email function with
  /// Client Id
  PhoneEmail.initializeApp(
    clientId: 'YOUR_CLIENT_ID',
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Phone Email',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 4, 201, 135),
        ),
        useMaterial3: true,
      ),
      home: const PhoneEmailAuthWidget(),
    );
  }
}

class PhoneEmailAuthWidget extends StatefulWidget {
  const PhoneEmailAuthWidget({super.key});

  @override
  State<PhoneEmailAuthWidget> createState() => _PhoneEmailAuthWidgetState();
}

class _PhoneEmailAuthWidgetState extends State<PhoneEmailAuthWidget> {
  String useraccessTokenn = "";
  String jwtUserToken = "";
  bool hasUserLogin = false;
  PhoneEmailUserModel? phoneEmailUserModel;
  final phoneEmail = PhoneEmail();

  String emailCount = '';

  /// Get email count after getting jwt token
  void getTotalEmailCount() async {
    await PhoneEmail.getEmailCount(
      jwtUserToken,
      onEmailCount: (count) {
        setState(() {
          emailCount = count;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Phone Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasUserLogin) ...[
              if (phoneEmailUserModel != null) ...[
                Divider(
                  thickness: 0.5,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16.0),
                const Text(
                  "User Data",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  "Phone Number : ${phoneEmailUserModel?.countryCode} ${phoneEmailUserModel?.phoneNumber}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
              if (emailCount.isNotEmpty) ...[
                Divider(
                  thickness: 0.5,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16.0),
                Text(
                  "Email Count : $emailCount",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            ],

            /// Default button
            if (!hasUserLogin) ...[
              // Align(
              //   alignment: Alignment.center,
              //   child: PhoneLoginButton(
              //     onSuccess: (String accessTokenn, String jwtToken) {
              //       debugPrint("Access Token :: $accessTokenn");
              //       debugPrint("Client ID :: $jwtToken");
              //       if (accessTokenn.isNotEmpty) {
              //         setState(() {
              //           useraccessTokenn = accessTokenn;
              //           jwtUserToken = jwtToken;
              //           hasUserLogin = true;
              //         });
              //       }
              //     },
              //   ),
              // ),
              const SizedBox(height: 16.0),

              /// Button With extra rounded corner
              /// and background color
              /// and different text
              Align(
                alignment: Alignment.center,
                child: PhoneLoginButton(
                  borderRadius: 15,
                  buttonColor: Colors.amber,
                  label: 'Sign in with Number',
                  onSuccess: (String accessTokenn, String jwtToken) {
                    // debugPrint("Access Token :: $accessTokenn");
                    // debugPrint("Client ID :: $jwtToken");
                    if (accessTokenn.isNotEmpty) {
                      setState(() {
                        useraccessTokenn = accessTokenn;
                        jwtUserToken = jwtToken;
                        hasUserLogin = true;
                      });

                      PhoneEmail.getUserInfo(
                        accessToken: useraccessTokenn,
                        clientId: phoneEmail.clientId,
                        onSuccess: (userData) {
                          setState(() {
                            phoneEmailUserModel = userData;
                            var countryCode = phoneEmailUserModel?.countryCode;
                            var phoneNumber = phoneEmailUserModel?.phoneNumber;
                            debugPrint("countryCode :: $countryCode");
                            debugPrint("phoneNumber :: $phoneNumber");
                            getTotalEmailCount();

                          });
                        },
                      );

                    }
                  },
                ),
              ),
            ],
            const SizedBox(height: 16.0),

            // if (hasUserLogin) ...[
            //   /// Get login user Data
            //   Align(
            //     alignment: Alignment.center,
            //     child: ElevatedButton(
            //       onPressed: () {
            //         PhoneEmail.getUserInfo(
            //           accessToken: useraccessTokenn,
            //           clientId: phoneEmail.clientId,
            //           onSuccess: (userData) {
            //             setState(() {
            //               phoneEmailUserModel = userData;
            //               var countryCode = phoneEmailUserModel?.countryCode;
            //               var phoneNumber = phoneEmailUserModel?.phoneNumber;
            //
            //             });
            //           },
            //         );
            //       },
            //       child: const Text("Get User Data"),
            //     ),
            //   ),
            //   const SizedBox(height: 16.0),

              /// Get login user Data
              // Align(
              //   alignment: Alignment.center,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       getTotalEmailCount();
              //     },
              //     child: const Text("Get Email count"),
              //   ),
              // ),
              // const SizedBox(height: 16.0),

              /// Logout
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    hasUserLogin = false;
                    useraccessTokenn = "";
                    jwtUserToken = "";
                    phoneEmailUserModel = null;
                    emailCount = '0';
                    setState(() {});
                  },
                  child: const Text("Logout"),
                ),
              ),
            ],
          // ],
        ),
      ),

      /// Email button
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: hasUserLogin
          ? EmailAlertButton(
              jwtToken: jwtUserToken,
            )
          : const Offstage(),
    );
  }
}
