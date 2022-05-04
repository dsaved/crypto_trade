import 'dart:convert';

import 'package:crypto_trade/crypto_app/ui_view/api_link.dart';
import 'package:crypto_trade/crypto_app/ui_view/auth_list.dart';
import 'package:crypto_trade/crypto_app/ui_view/base_currency.dart';
import 'package:crypto_trade/crypto_app/ui_view/finger_auth.dart';
import 'package:crypto_trade/crypto_app/ui_view/title_view.dart';
import 'package:crypto_trade/crypto_app/crypto_trade_app_theme.dart';
import 'package:crypto_trade/dbhandler/databaseHelper.dart';
import 'package:crypto_trade/network/network_util.dart';
import 'package:crypto_trade/utils/Dialogs.dart';
import 'package:crypto_trade/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySettingsScreen extends StatefulWidget {
  const MySettingsScreen({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;

  @override
  _MySettingsScreenState createState() => _MySettingsScreenState();
}

class _MySettingsScreenState extends State<MySettingsScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  Animation<double> topBarAnimation;
  NetworkUtil _netUtil = new NetworkUtil();
  Map auths = new Map<String, dynamic>();
  SharedPreferences prefs;
  bool linkOnline = false;
  String link = '';
  String currency = '';

  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    initAll();
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  initAll() async {
    link = await DatabaseHelper.internal().getLink();
    prefs = await SharedPreferences.getInstance();
    String p_auths = prefs.getString(Constant.AUTHS_PREF_KEY);
    if (p_auths != null) {
      var savedSettings = json.decode(p_auths);
      print(savedSettings);
      auths = savedSettings['auths'];
      currency = savedSettings['currency'];
      if (this.mounted) {
        setState(() {});
      }
    }
    linkOnline = await _netUtil.head('/', context);
    if (this.mounted) {
      setState(() {});
    }
    getData();
  }

  Future<bool> getData({reload = false}) async {
    await _netUtil
        .post("${Constant.get_settings}", context, body: new Map())
        .then((result) {
          if (result['success']) {
            auths = result['auths'];
            currency = result['currency'];
            prefs.setString(Constant.AUTHS_PREF_KEY, json.encode(result));
            if (this.mounted) {
              setState(() {});
            }
          }
        })
        .timeout(Duration(seconds: 10))
        .catchError((error) {
          print("Error $error");
        });
    return true;
  }

  @override
  Future didChangeAppLifecycleState(AppLifecycleState state) async {
    if (this.mounted) {
      await getData(reload: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CryptoTradeAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            Builder(builder: (BuildContext context) {
              const int count = 4;
              List<Widget> listViews = <Widget>[];

              listViews.add(
                ApiLinkView(
                  status: linkOnline,
                  link: link,
                  onClick: addLink,
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / count) * 0, 1.0,
                              curve: Curves.fastOutSlowIn))),
                  animationController: widget.animationController,
                ),
              );

              listViews.add(
                BaseCurrencyView(
                  currency: currency,
                  onChange: (newCurrency) {
                    currency = newCurrency;
                    setState(() {});
                    Map updateData = Map<String, dynamic>();
                    updateData['currency'] = newCurrency;
                    prefs.setString(Constant.AUTHS_PREF_KEY,
                        json.encode({"auths": auths, "currency": newCurrency}));
                    _netUtil
                        .post(Constant.update_base_currency, context,
                            body: updateData)
                        .then((result) {
                          print(result);
                        })
                        .timeout(Duration(seconds: 10))
                        .catchError((error) {
                          print("Error $error");
                        });
                    ;
                  },
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / count) * 1, 1.0,
                              curve: Curves.fastOutSlowIn))),
                  animationController: widget.animationController,
                ),
              );

              listViews.add(
                FingerAuthentication(
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / count) * 2, 1.0,
                              curve: Curves.fastOutSlowIn))),
                  animationController: widget.animationController,
                ),
              );

              listViews.add(
                TitleView(
                  titleTxt: 'API Authentications',
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / count) * 3, 1.0,
                              curve: Curves.fastOutSlowIn))),
                  animationController: widget.animationController,
                ),
              );

              listViews.add(
                AuthListView(
                  auths: auths,
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / count) * 4, 1.0,
                              curve: Curves.fastOutSlowIn))),
                  animationController: widget.animationController,
                ),
              );

              return ListView.builder(
                controller: scrollController,
                padding: EdgeInsets.only(
                  top: AppBar().preferredSize.height +
                      MediaQuery.of(context).padding.top +
                      24,
                  bottom: 62 + MediaQuery.of(context).padding.bottom,
                ),
                itemCount: listViews.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  widget.animationController.forward();
                  return listViews[index];
                },
              );
            }),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  void addLink() async {
    Dialogs dialogs = new Dialogs();
    dialogs.inputDialog(context,
        title: 'Please provide API End Point',
        initialValue: link,
        hintText: 'https://wesite.com:8378', result: (result) async {
      if (result != null) {
        bool _validURL =
            Uri.parse(result).isAbsolute && Uri.parse(result).hasPort;
        if (_validURL) {
          await DatabaseHelper.internal().saveLink(result);
          initAll();
        } else {
          dialogs.infoDialog(context, "Incorrect Link ",
              "Please make sure the link matches this example pattern (https://site.com:0000) ",
              onPressed: (pressed) {
            if (pressed) {
              addLink();
            }
          });
        }
      }
    }, cancel: () {});
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            const months = [
              "Jan",
              "Feb",
              "Mar",
              "Apr",
              "May",
              "Jun",
              "Jul",
              "Aug",
              "Sep",
              "Oct",
              "Nov",
              "Dec"
            ];
            var date1 = new DateTime.now().toString();
            var dateParse = DateTime.parse(date1);
            var formattedDate =
                "${dateParse.day} ${months[dateParse.month - 1]}";

            return FadeTransition(
              opacity: topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: CryptoTradeAppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: CryptoTradeAppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Settings',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: CryptoTradeAppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: CryptoTradeAppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Icon(
                                      Icons.calendar_today,
                                      color: CryptoTradeAppTheme.grey,
                                      size: 18,
                                    ),
                                  ),
                                  Text(
                                    '$formattedDate',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: CryptoTradeAppTheme.fontName,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                      letterSpacing: -0.2,
                                      color: CryptoTradeAppTheme.darkerText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
