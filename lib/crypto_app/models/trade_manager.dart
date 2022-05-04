import 'dart:convert';

import 'package:crypto_trade/crypto_app/crypto_trade_app_theme.dart';
import 'package:crypto_trade/network/network_util.dart';
import 'package:crypto_trade/utils/Dialogs.dart';
import 'package:crypto_trade/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class TradeManager extends StatefulWidget {
  const TradeManager({Key key, this.trade, @required this.completed})
      : super(key: key);

  final Map<String, dynamic> trade;
  final VoidCallback completed;

  @override
  _TradeManagerState createState() => _TradeManagerState();
}

class _TradeManagerState extends State<TradeManager> {
  SharedPreferences prefs;
  Map<String, dynamic> trade;
  List<dynamic> auth_options = [];
  double opacity3 = 0.0;
  String type = "Create",
      loading_status = "Creating",
      success_status = "Created",
      status,
      auth,
      ticker,
      id,
      link = Constant.create_trade;
  bool cryptoTrading = false;

  TextEditingController number_of_trades,
      buy_amount,
      change_percentage_buy,
      change_percentage_sell;

  @override
  void initState() {
    super.initState();
    number_of_trades = TextEditingController();
    buy_amount = TextEditingController();
    change_percentage_buy = TextEditingController();
    change_percentage_sell = TextEditingController();
    initAll();
  }

  void initAll() async {
    prefs = await SharedPreferences.getInstance();
    String _auth_option = prefs.getString(Constant.AUTH_OPTION_PREF_KEY);
    if (_auth_option != null) {
      auth_options = json.decode(_auth_option);
      if (this.mounted) {
        setState(() {});
      }
    }

    trade = widget.trade;
    if (trade != null && trade.isNotEmpty) {
      link = Constant.update_trade;
      type = "Update";
      loading_status = "Updating";
      success_status = "Updated";
      id = "${trade['id']}";
      status = trade['status'];
      auth = trade['auth'];
      ticker = trade['ticker'];
      cryptoTrading = (trade['trading'] == "yes") ? true : false;

      number_of_trades.text = "${trade['number_of_trades']}";
      buy_amount.text = "${trade['buy_amount']}";
      change_percentage_buy.text = "${trade['change_percentage_buy']}";
      change_percentage_sell.text = "${trade['change_percentage_sell']}";
    }

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
          "$type Trade",
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
              DropdownButton<dynamic>(
                underline: Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.black.withOpacity(0.3)),
                itemHeight: 70,
                hint: Text("Crypto Currency",
                    style: TextStyle(
                      fontFamily: CryptoTradeAppTheme.fontName,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      letterSpacing: -0.2,
                      color: CryptoTradeAppTheme.grey.withOpacity(0.8),
                    )),
                value: ticker,
                isExpanded: true,
                icon: Icon(
                  Icons.money_sharp,
                  color: CryptoTradeAppTheme.grey.withOpacity(0.8),
                ),
                items: Constant.cryptos.map((dynamic value) {
                  return new DropdownMenuItem<dynamic>(
                    value: value,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 15.0, top: 15.0, bottom: 15.0),
                          child: Image.asset('${Constant.crypto}$value.png',
                              width: 25),
                        ),
                        Text(
                          value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: CryptoTradeAppTheme.fontName,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            letterSpacing: -0.2,
                            color: CryptoTradeAppTheme.grey.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (_) {
                  ticker = _;
                  setState(() {});
                },
              ),
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
                  controller: number_of_trades,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter Number Of Trades',
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
                  controller: buy_amount,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Amount To Trade',
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
                  controller: change_percentage_buy,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter Change Percent Buy',
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
                  controller: change_percentage_sell,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter Change Percent Sell',
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
              DropdownButton<dynamic>(
                underline: Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.black.withOpacity(0.3)),
                itemHeight: 70,
                hint: Text("Authentication Method",
                    style: TextStyle(
                      fontFamily: CryptoTradeAppTheme.fontName,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      letterSpacing: -0.2,
                      color: CryptoTradeAppTheme.grey.withOpacity(0.8),
                    )),
                value: auth,
                isExpanded: true,
                icon: Icon(
                  Icons.vpn_lock_rounded,
                  color: CryptoTradeAppTheme.grey.withOpacity(0.8),
                ),
                items: auth_options.map((dynamic value) {
                  return new DropdownMenuItem<dynamic>(
                    value: value,
                    child: new Text(
                      value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: CryptoTradeAppTheme.fontName,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        letterSpacing: -0.2,
                        color: CryptoTradeAppTheme.grey.withOpacity(0.8),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (_) {
                  auth = _;
                  setState(() {});
                },
              ),
              DropdownButton<String>(
                underline: Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.black.withOpacity(0.3)),
                itemHeight: 70,
                hint: Text("Status",
                    style: TextStyle(
                      fontFamily: CryptoTradeAppTheme.fontName,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      letterSpacing: -0.2,
                      color: CryptoTradeAppTheme.grey.withOpacity(0.8),
                    )),
                value: status,
                isExpanded: true,
                icon: Icon(
                  Icons.error,
                  color: CryptoTradeAppTheme.grey.withOpacity(0.8),
                ),
                items: <String>['active', 'inactive'].map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(
                      value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: CryptoTradeAppTheme.fontName,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        letterSpacing: -0.2,
                        color: CryptoTradeAppTheme.grey.withOpacity(0.8),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (_) {
                  status = _;
                  setState(() {});
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Trading: ",
                        style: TextStyle(
                          fontFamily: CryptoTradeAppTheme.fontName,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          letterSpacing: -0.2,
                          color: CryptoTradeAppTheme.grey.withOpacity(0.8),
                        )),
                    FlutterSwitch(
                      width: 60.0,
                      height: 25.0,
                      valueFontSize: 12.0,
                      toggleSize: 15.0,
                      value: cryptoTrading,
                      borderRadius: 30.0,
                      padding: 4.0,
                      onToggle: (val) async {
                        setState(() {
                          cryptoTrading = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()),
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
                            if (ticker == null || ticker.isEmpty) {
                              return showToast("Please Select Crypto Currency");
                            }
                            if (number_of_trades.text.isEmpty) {
                              return showToast("Please Enter Trade Limit");
                            }
                            if (buy_amount.text.isEmpty) {
                              return showToast("Please Enter Amount Trade");
                            }
                            if (change_percentage_buy.text.isEmpty) {
                              return showToast(
                                  "Please Enter Percent Change Buy");
                            }
                            if (change_percentage_sell.text.isEmpty) {
                              return showToast(
                                  "Please Enter Percent Change Sell");
                            }
                            if (auth == null || auth.isEmpty) {
                              return showToast("Please Select Authentication ");
                            }
                            if (status == null || status.isEmpty) {
                              return showToast("Please Select Status");
                            }
                            Map<String, dynamic> _trade = new Map();
                            _trade['id'] = id;
                            _trade['ticker'] = ticker;
                            _trade['number_of_trades'] = number_of_trades.text;
                            _trade['buy_amount'] = buy_amount.text;
                            _trade['change_percentage_buy'] =
                                change_percentage_buy.text;
                            _trade['change_percentage_sell'] =
                                change_percentage_sell.text;
                            _trade['auth'] = auth;
                            _trade['status'] = status;
                            _trade['trading'] =
                                cryptoTrading == true ? "yes" : "no";
                            addTrade(_trade);
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
                                '$type',
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

  void addTrade(Map<String, dynamic> trade) async {
    NetworkUtil _netUtil = new NetworkUtil();
    Dialogs dialogs = new Dialogs();
    dialogs.loading(
        context, "$loading_status trade, Please wait", Dialogs.GLOWING);
    await _netUtil.post("$link", context, body: trade).then((value) async {
      dialogs.close(context);
      if (value['success'] == true) {
        await dialogs.infoDialog(context, "Completed",
            "The Trade has been $success_status successfully",
            onPressed: (pressed) {
          if (pressed) {
            widget.completed();
            Navigator.of(context).pop();
          }
        });
      } else {
        showToast(value['message']);
      }
    }).catchError((error) {
      dialogs.close(context);
      showToast("An Error Occurred");
      print("Error $error");
    });
  }
}
