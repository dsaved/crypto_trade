import 'dart:convert';

import 'package:crypto_trade/crypto_app/models/calculator_manager.dart';
import 'package:crypto_trade/crypto_app/my_history_page/history_page.dart';
import 'package:crypto_trade/crypto_app/ui_view/barchart_view.dart';
import 'package:crypto_trade/crypto_app/ui_view/information_view.dart';
import 'package:crypto_trade/crypto_app/ui_view/dashboard_summary_view.dart';
import 'package:crypto_trade/crypto_app/ui_view/piechart_view.dart';
import 'package:crypto_trade/crypto_app/ui_view/title_view.dart';
import 'package:crypto_trade/crypto_app/crypto_trade_app_theme.dart';
import 'package:crypto_trade/network/network_util.dart';
import 'package:crypto_trade/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDashboardScreen extends StatefulWidget {
  const MyDashboardScreen({Key key, this.animationController})
      : super(key: key);

  final AnimationController animationController;

  @override
  _MyDashboardScreenState createState() => _MyDashboardScreenState();
}

class _MyDashboardScreenState extends State<MyDashboardScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  Animation<double> topBarAnimation;
  NetworkUtil _netUtil = new NetworkUtil();
  Map stats = new Map<String, dynamic>();
  SharedPreferences prefs;

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
    prefs = await SharedPreferences.getInstance();
    String p_stats = prefs.getString(Constant.STATS_PREF_KEY);
    if (p_stats != null) {
      stats = json.decode(p_stats);
      if (this.mounted) {
        setState(() {});
      }
    }
    getData();
  }

  Future<bool> getData({reload = false}) async {
    await _netUtil
        .post("${Constant.stats}", context, body: new Map())
        .then((result) {
          if (result['success']) {
            stats = result['stats'];
            prefs.setString(Constant.STATS_PREF_KEY, json.encode(stats));
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
              if (stats == null) {
                return const SizedBox();
              } else {
                const int count = 5;
                List<Widget> listViews = <Widget>[];

                listViews.add(
                  DashboardSummaryView(
                    animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: widget.animationController,
                            curve: Interval((1 / count) * 1, 1.0,
                                curve: Curves.fastOutSlowIn))),
                    animationController: widget.animationController,
                    stats: stats,
                  ),
                );

                listViews.add(
                  GestureDetector(
                    onTap: (){
                      showMaterialModalBottomSheet(
                        context: context,
                        builder: (context) => CalculatorManager(),
                      );
                    },
                    child: InfomationView(
                        animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: widget.animationController,
                                curve: Interval((1 / count) * 2, 1.0,
                                    curve: Curves.fastOutSlowIn))),
                        animationController: widget.animationController),
                  ),
                );

                listViews.add(
                  BarchartDataView(
                    animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: widget.animationController,
                            curve: Interval((1 / count) * 3, 1.0,
                                curve: Curves.fastOutSlowIn))),
                    animationController: widget.animationController,
                    stats: stats,
                  ),
                );

                listViews.add(
                  TitleView(
                    titleTxt: 'Transaction Summary',
                    subTxt: 'See All',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HistoryScreen(
                              animationController: widget.animationController,
                            ),
                          ));
                    },
                    animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: widget.animationController,
                            curve: Interval((1 / count) * 4, 1.0,
                                curve: Curves.fastOutSlowIn))),
                    animationController: widget.animationController,
                  ),
                );

                listViews.add(
                  PiechartDataView(
                    animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: widget.animationController,
                            curve: Interval((1 / count) * 5, 1.0,
                                curve: Curves.fastOutSlowIn))),
                    animationController: widget.animationController,
                    stats: stats,
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
                                  'Home',
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
