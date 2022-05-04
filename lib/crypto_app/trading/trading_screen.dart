import 'dart:async';
import 'dart:convert';

import 'package:crypto_trade/crypto_app/crypto_trade_app_theme.dart';
import 'package:crypto_trade/crypto_app/my_history_page/history_page.dart';
import 'package:crypto_trade/crypto_app/my_history_page/unsold_trade_page.dart';
import 'package:crypto_trade/crypto_app/ui_view/about_to_trade_view.dart';
import 'package:crypto_trade/crypto_app/ui_view/trading_view.dart';
import 'package:crypto_trade/crypto_app/ui_view/title_view.dart';
import 'package:crypto_trade/crypto_app/ui_view/history_banner_view.dart';
import 'package:crypto_trade/dbhandler/databaseHelper.dart';
import 'package:crypto_trade/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class TradeScreen extends StatefulWidget {
  const TradeScreen({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;

  @override
  _TradeScreenState createState() => _TradeScreenState();
}

class _TradeScreenState extends State<TradeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  Animation<double> topBarAnimation;
  List<dynamic> transactions = [], transactionsToTrade = [];
  SharedPreferences prefs;
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  IO.Socket socket;
  Timer _timer;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    startSocket();

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

  @override
  Future didChangeAppLifecycleState(AppLifecycleState state) async {
    startSocket();
  }

  void startSocket() async {
    var link = await DatabaseHelper.internal().getLink();
    if (socket == null) {
      socket = IO.io(
          '$link',
          OptionBuilder()
              .setTransports(['websocket']) // for Flutter or Dart VM
              .disableAutoConnect()
              .build());
    }

    if (socket.disconnected) {
      socket.onConnect((_) {
        print('socket connected');
        socket.emit('new_connection', 'get');
        socket.emit('trading', 'get');
        socket.emit('abouttotrade', 'get');
        _timer = new Timer.periodic(
          const Duration(seconds: 15),
          (Timer t) {socket.emit('abouttotrade', 'get');},
        );
      });
      socket.on('event_response', (data) => print('$data'));

      socket.on('trade', (data) {
        if (data['success']) {
          transactions = data['trade'];
          prefs.setString(Constant.TRADING_PREF_KEY, json.encode(transactions));
          if (this.mounted) {
            setState(() {});
          }
        }
      });
      socket.on('totrade', (data) {
        if (data['success']) {
          transactionsToTrade = data['trade'];
          prefs.setString(Constant.ABOUT_TO_BUY_PREF_KEY, json.encode(transactionsToTrade));
          if (this.mounted) {
            setState(() {});
          }
        }
      });
      socket.onDisconnect((_) {
        print('socket disconnected');
        _timer.cancel();
      });
      socket.connect();
    }

    prefs = await SharedPreferences.getInstance();
    String p_stats = prefs.getString(Constant.TRADING_PREF_KEY);
    String ABOUT_TO_TRADE_ = prefs.getString(Constant.ABOUT_TO_BUY_PREF_KEY);
    if (p_stats != null) {
      transactions = json.decode(p_stats);
    }
    if (ABOUT_TO_TRADE_ != null) {
      transactionsToTrade = json.decode(ABOUT_TO_TRADE_);
    }
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    if (socket.connected) {
      socket.disconnect();
      socket.dispose();
    }
    super.dispose();
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
              if (transactions == null) {
                return const SizedBox();
              } else {
                List<Widget> listViews = <Widget>[];
                const int count = 6;

                listViews.add(
                  TitleView(
                    titleTxt: 'Unsold Trades',
                    subTxt: 'Details',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UnsoldTradeScreen(
                              animationController: widget.animationController,
                            ),
                          ));
                    },
                    animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: widget.animationController,
                            curve: Interval((1 / count) * 0, 1.0,
                                curve: Curves.fastOutSlowIn))),
                    animationController: widget.animationController,
                  ),
                );

                listViews.add(
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HistoryScreen(
                              animationController: widget.animationController,
                            ),
                          ));
                    },
                    child: HistoryBannerView(
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 2, 1.0,
                                  curve: Curves.fastOutSlowIn))),
                      animationController: widget.animationController,
                    ),
                  ),
                );

                listViews.add(
                  TitleView(
                    titleTxt: 'Currently Trading',
                    animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: widget.animationController,
                            curve: Interval((1 / count) * 3, 1.0,
                                curve: Curves.fastOutSlowIn))),
                    animationController: widget.animationController,
                  ),
                );

                listViews.add(
                  TradingView(
                    trading: transactions,
                    animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: widget.animationController,
                            curve: Interval((1 / count) * 4, 1.0,
                                curve: Curves.fastOutSlowIn))),
                    animationController: widget.animationController,
                  ),
                );

                if(transactionsToTrade.length > 0) {
                  listViews.add(
                    TitleView(
                      titleTxt: 'About To Buy',
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 3, 1.0,
                                  curve: Curves.fastOutSlowIn))),
                      animationController: widget.animationController,
                    ),
                  );
                }

                listViews.add(
                  AboutToTradeView(
                    trading: transactionsToTrade,
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
              }
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
                                  'Trading',
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
