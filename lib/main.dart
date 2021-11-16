// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

const API_CLIENT_ID = "679fbae9-0a1a-4885-9fba-e90a1a188580";
const API_ISSUER = "https://am-nightly-gateway.cloud.gravitee.io/demo/oidc";
const API_REDIRECT_URI = "io.gravitee.oauth.test:/oauthredirect";

FlutterAppAuth appAuth = FlutterAppAuth();
AuthorizationTokenResponse? tokenResponse;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gravitee',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Gravitee OAuth'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String logs = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () async {
                  AuthorizationTokenResponse? infos = await getInformations();
                  if (infos != null) {
                    setState(() {
                      logs = "Access Token : ${infos.accessToken}\nIDToken : ${infos.idToken}\nTokenType : ${infos.tokenType}";
                    });
                  }
                },
                child: const Text("Get informations"),
              ),
              const SizedBox(height: 8.0),
              Text(
                logs,
                maxLines: 1000,
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<AuthorizationTokenResponse?> getInformations() async {
  final AuthorizationTokenResponse? result = await appAuth.authorizeAndExchangeCode(
    AuthorizationTokenRequest(
      API_CLIENT_ID,
      API_REDIRECT_URI,
      issuer: API_ISSUER,
      scopes: ['openid', 'profile', 'email'],
    ),
  );
  tokenResponse = result;
  return result;
}
