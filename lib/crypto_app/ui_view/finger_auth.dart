import 'package:crypto_trade/crypto_app/crypto_trade_app_theme.dart';
import 'package:crypto_trade/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef void CurrencyCallback(String currency);

class FingerAuthentication extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;

  const FingerAuthentication(
      {Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  _FingerAuthenticationState createState() => _FingerAuthenticationState();
}

class _FingerAuthenticationState extends State<FingerAuthentication> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  String hasBiometric = "(Not Available)";
  bool biometricAvailable = false;
  SharedPreferences prefs;
  bool shouldAuthenticate = false;

  @override
  void initState() {
    super.initState();
    initPrint();
  }

  void initPrint() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      shouldAuthenticate =
          prefs.getBool(Constant.BIOMETRIC_PREF_KEY) ?? false;
    });
    biometricAvailable = await _isBiometricAvailable();
    if (biometricAvailable) {
      hasBiometric = "";
    }
    setState(() {});
  }

  Future<bool> _isBiometricAvailable() async {
    bool isAvailable = false;
    try {
      isAvailable = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return isAvailable;

    isAvailable
        ? print('Biometric is available!')
        : print('Biometric is unavailable.');

    return isAvailable;
  }

  Future<bool> _authenticateUser() async {
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

    if (!mounted) return false;

    isAuthenticated
        ? print('User is authenticated!')
        : print('User is not authenticated.');

    return isAuthenticated;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 13),
              child: Container(
                decoration: BoxDecoration(
                  color: CryptoTradeAppTheme.white,
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
                          const EdgeInsets.only(top: 16, left: 16, right: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, bottom: 8),
                                    child: Text(
                                      'Authentication',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily:
                                              CryptoTradeAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          letterSpacing: -0.1,
                                          color: CryptoTradeAppTheme.darkText),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, top: 8, bottom: 8),
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: CryptoTradeAppTheme.background,
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, top: 8, bottom: 16),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Unlock app with biometric $hasBiometric',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: CryptoTradeAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    letterSpacing: -0.2,
                                    color: CryptoTradeAppTheme.grey
                                        .withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                biometricAvailable?FlutterSwitch(
                                  width: 100.0,
                                  height: 25.0,
                                  valueFontSize: 12.0,
                                  toggleSize: 15.0,
                                  value: shouldAuthenticate,
                                  borderRadius: 30.0,
                                  padding: 4.0,
                                  onToggle: (val) async {
                                    bool success = await _authenticateUser();
                                    if(success){
                                      setState(() {
                                        shouldAuthenticate = val;
                                      });
                                      prefs.setBool(Constant.BIOMETRIC_PREF_KEY, shouldAuthenticate);
                                    }
                                  },
                                ):Container(),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
