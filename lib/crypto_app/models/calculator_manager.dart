import 'dart:convert';

import 'package:crypto_trade/crypto_app/crypto_trade_app_theme.dart';
import 'package:crypto_trade/network/network_util.dart';
import 'package:crypto_trade/utils/Dialogs.dart';
import 'package:crypto_trade/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class CalculatorManager extends StatefulWidget {
  const CalculatorManager({
    Key key,
  }) : super(key: key);

  @override
  _CalculatorManagerState createState() => _CalculatorManagerState();
}

class _CalculatorManagerState extends State<CalculatorManager> {
  double opacity3 = 0.0;
  double percentDifference = 0.0;
  String calculation1 = "", calculation2 = "";

  TextEditingController highAmount, lowAmount, investAmount, investPercentage;

  @override
  void initState() {
    super.initState();
    highAmount = TextEditingController();
    lowAmount = TextEditingController();
    investAmount = TextEditingController();
    investPercentage = TextEditingController();
    initAll();
  }

  void initAll() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: CryptoTradeAppTheme.iconTheme,
        title: Text(
          "Trade Calculator",
          style: TextStyle(
            fontFamily: CryptoTradeAppTheme.fontName,
            fontWeight: FontWeight.w500,
            fontSize: 22,
            letterSpacing: 0.25,
            color: CryptoTradeAppTheme.nearlyBlack,
          ),
        ),
        backgroundColor: CryptoTradeAppTheme.nearlyWhite,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  cursorColor: CryptoTradeAppTheme.grey.withOpacity(0.8),
                  style: TextStyle(
                    fontFamily: CryptoTradeAppTheme.fontName,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    letterSpacing: -0.2,
                    color: CryptoTradeAppTheme.grey.withOpacity(0.8),
                  ),
                  controller: highAmount,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter High Amount',
                    labelStyle: TextStyle(
                      fontFamily: CryptoTradeAppTheme.fontName,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      letterSpacing: -0.2,
                      color: CryptoTradeAppTheme.grey.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  cursorColor: CryptoTradeAppTheme.grey.withOpacity(0.8),
                  style: TextStyle(
                    fontFamily: CryptoTradeAppTheme.fontName,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    letterSpacing: -0.2,
                    color: CryptoTradeAppTheme.grey.withOpacity(0.8),
                  ),
                  controller: lowAmount,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter Low Amount',
                    labelStyle: TextStyle(
                      fontFamily: CryptoTradeAppTheme.fontName,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      letterSpacing: -0.2,
                      color: CryptoTradeAppTheme.grey.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  cursorColor: CryptoTradeAppTheme.grey.withOpacity(0.8),
                  style: TextStyle(
                    fontFamily: CryptoTradeAppTheme.fontName,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    letterSpacing: -0.2,
                    color: CryptoTradeAppTheme.grey.withOpacity(0.8),
                  ),
                  controller: investAmount,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter Amount To Invest',
                    labelStyle: TextStyle(
                      fontFamily: CryptoTradeAppTheme.fontName,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      letterSpacing: -0.2,
                      color: CryptoTradeAppTheme.grey.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  cursorColor: CryptoTradeAppTheme.grey.withOpacity(0.8),
                  style: TextStyle(
                    fontFamily: CryptoTradeAppTheme.fontName,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    letterSpacing: -0.2,
                    color: CryptoTradeAppTheme.grey.withOpacity(0.8),
                  ),
                  controller: investPercentage,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Invest Percentage',
                    labelStyle: TextStyle(
                      fontFamily: CryptoTradeAppTheme.fontName,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      letterSpacing: -0.2,
                      color: CryptoTradeAppTheme.grey.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Calculation using percentage difference",
                      style: TextStyle(
                        fontFamily: CryptoTradeAppTheme.fontName,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        letterSpacing: 0.25,
                        color: CryptoTradeAppTheme.nearlyDarkBlue,
                      ),
                    ),
                    Text(
                      "$calculation1",
                      style: TextStyle(
                        fontFamily: CryptoTradeAppTheme.fontName,
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                        letterSpacing: 0.25,
                        color: CryptoTradeAppTheme.nearlyBlack,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Calculation using provided percentage",
                      style: TextStyle(
                        fontFamily: CryptoTradeAppTheme.fontName,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        letterSpacing: 0.25,
                        color: CryptoTradeAppTheme.nearlyDarkBlue,
                      ),
                    ),
                    Text(
                      "$calculation2",
                      style: TextStyle(
                        fontFamily: CryptoTradeAppTheme.fontName,
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                        letterSpacing: 0.25,
                        color: CryptoTradeAppTheme.nearlyBlack,
                      ),
                    ),
                  ],
                ),
              )),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: opacity3,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16, bottom: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (highAmount.text.isEmpty) {
                              return showToast("Please Enter high amount");
                            }
                            if (lowAmount.text.isEmpty) {
                              return showToast("Please Enter lowest amount");
                            }
                            if (investAmount.text.isEmpty) {
                              return showToast(
                                  "Please Enter investment amount");
                            }

                            var amount = double.parse(investAmount.text);
                            var difference = double.parse(highAmount.text) - double.parse(lowAmount.text);

                            percentDifference = (difference / double.parse(lowAmount.text)) * 100;
                            if (investPercentage.text.isNotEmpty) {
                              //Percentage increase
                              var _investPercentage = double.parse(investPercentage.text);
                              var _investProfit = (_investPercentage / 100) * amount;
                              calculation2 = "If you invest ${amount.toStringAsFixed(2)} and set your sell percentage to  ${_investPercentage.toStringAsFixed(1)}% you will get a return profit of ${_investProfit.toStringAsFixed(2)}";
                            }
                            //Percentage increase
                            var percentage = percentDifference;
                            var profit = (percentage / 100) * amount;
                            calculation1 = "If you invest ${amount.toStringAsFixed(2)} and set your sell percentage to ${percentage.toStringAsFixed(1)}% you will get a return profit of ${profit.toStringAsFixed(2)}";
                            setState(() {});
                          },
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: CryptoTradeAppTheme.nearlyDarkBlue,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: CryptoTradeAppTheme.nearlyDarkBlue
                                        .withOpacity(0.8),
                                    offset: const Offset(1.1, 1.1),
                                    blurRadius: 10.0),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'Calculate',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  letterSpacing: 0.0,
                                  color: CryptoTradeAppTheme.nearlyWhite,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showToast(text) {
    return Toast.show(text, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }
}
