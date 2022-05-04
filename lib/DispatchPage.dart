import 'dart:async';
import 'dart:convert';

import 'package:crypto_trade/dbhandler/databaseHelper.dart';
import 'package:crypto_trade/crypto_app/crypto_trade_app_theme.dart';
import 'package:crypto_trade/crypto_app/crypto_trade_app_home_screen.dart';
import 'package:crypto_trade/network/network_util.dart';
import 'package:crypto_trade/utils/Dialogs.dart';
import 'package:crypto_trade/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

class DispatchPage extends StatefulWidget {
  static const String tag = "dispatch-page";

  @override
  State<StatefulWidget> createState() => DispatchPageState();
}

class DispatchPageState extends State<DispatchPage> {
  DatabaseHelper db = DatabaseHelper.internal();
  bool has_link = false;
  NetworkUtil _netWork = new NetworkUtil();
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  SharedPreferences prefs;
  bool shouldAuthenticate = false;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    checkLinkAvailable();
    init();
  }

  void init() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      shouldAuthenticate = prefs.getBool(Constant.BIOMETRIC_PREF_KEY) ?? false;
    });
    if (shouldAuthenticate) {
      Timer(Duration(seconds: 1), _authenticateUser);
    } else {
      initialize();
    }
  }

  Future checkLinkAvailable() async {
    has_link = await db.hasLink();
    setState(() {
      has_link = has_link;
    });
    if (has_link) await getAuthOptions();
  }

  Future<void> _authenticateUser() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Please authenticate to use app",
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    isAuthenticated
        ? print('User is authenticated!')
        : print('User is not authenticated.');

    setState(() {});
    _isAuthenticated = isAuthenticated;
    if (isAuthenticated) {
      initialize();
    }
  }

  Future getAuthOptions() async {
    await _netWork
        .post("${Constant.auth_options}", context, body: new Map())
        .then((result) {
          if (result['success']) {
            prefs.setString(
                Constant.AUTH_OPTION_PREF_KEY, json.encode(result['options']));
          }
        })
        .timeout(Duration(seconds: 10))
        .catchError((error) {
          print("Auth Option error: $error");
        });
  }

  initialize() async {
    new Timer(new Duration(seconds: 2), handleTimeout);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CryptoTradeAppTheme.background,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FittedBox(
            child: Image.asset(
              Constant.splash,
            ),
            fit: BoxFit.fitHeight,
          ),
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 210,
                decoration: BoxDecoration(
                  color: CryptoTradeAppTheme.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(8.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: CryptoTradeAppTheme.grey.withOpacity(0.2),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Container(
                        child: Image.asset(
                          Constant.logoWhite,
                          width: 180,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              shouldAuthenticate && !_isAuthenticated
                  ? ElevatedButton(
                      onPressed: () async {
                        await _authenticateUser();
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              CryptoTradeAppTheme.getColor),
                          enableFeedback: true),
                      child: Text(
                        'Unlock',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: CryptoTradeAppTheme.fontName,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          letterSpacing: 1.2,
                          color: CryptoTradeAppTheme.white,
                        ),
                      ),
                    )
                  : Container(),
            ],
          )),
        ],
      ),
    );
  }

  void handleTimeout() async {
    if (has_link) {
      home();
    } else {
      addLink();
    }
  }

  void addLink() async {
    Dialogs dialogs = new Dialogs();
    await dialogs.inputDialog(context,
        title: 'Please provide API End Point',
        initialValue: 'https://',
        hintText: 'https://wesite.com:8378', result: (result) async {
      if (result != null) {
        bool _validURL =
            Uri.parse(result).isAbsolute && Uri.parse(result).hasPort;
        if (_validURL) {
          bool isValid = await _netWork.head(result, context);
          if (isValid) {
            await DatabaseHelper.internal().saveLink(result);
            await getAuthOptions();
            home();
          } else {
            await dialogs.infoDialog(context, "Not Reachable",
                "The link you entered cannot be reached, please check the link",
                onPressed: (pressed) {
              if (pressed) {
                addLink();
              }
            });
          }
        } else {
          await dialogs.infoDialog(context, "Incorrect Link ",
              "Please make sure the link matches this example pattern (https://site.com:0000) ",
              onPressed: (pressed) {
            if (pressed) {
              addLink();
            }
          });
        }
      }
    }, cancel: () async {
      await dialogs
          .infoDialog(context, "No  Link ", "App is going to exist now ",
              onPressed: (pressed) {
        SystemNavigator.pop();
      });
    });
  }

  void home() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FitnessAppHomeScreen(),
        ));
  }
}
