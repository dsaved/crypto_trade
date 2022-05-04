import 'dart:async';
import 'dart:convert';

import 'package:crypto_trade/crypto_app/crypto_trade_app_theme.dart';
import 'package:crypto_trade/crypto_app/ui_view/transaction_list_view.dart';
import 'package:crypto_trade/crypto_app/ui_view/unsold_trade_list_view.dart';
import 'package:crypto_trade/network/network_util.dart';
import 'package:crypto_trade/utils/Dialogs.dart';
import 'package:crypto_trade/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UnsoldTradeScreen extends StatefulWidget {
  const UnsoldTradeScreen({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;

  @override
  _UnsoldTradeScreenState createState() => _UnsoldTradeScreenState();
}

class _UnsoldTradeScreenState extends State<UnsoldTradeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  Animation<double> topBarAnimation;
  List<dynamic> transactions = [];
  Map pagination = Map<String, dynamic>();
  SharedPreferences prefs;
  final ScrollController scrollController = ScrollController();
  NetworkUtil _netUtil = new NetworkUtil();
  double topBarOpacity = 0.0;
  bool socketConnected = false,
      _loading = true,
      _hasError = false,
      searched = false;
  int result_per_page = 20, page = 1;
  String searchText = "";

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    initAll();
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == 0) {
          // You're at the top.
          if (!searched) {
            page = 1;
            _getData(silent: true, page: page);
          }
        } else {
          // You're at the bottom.
          if (pagination!=null && pagination.isNotEmpty && pagination['hasNext']) {
            page += 1;
            _getData(more: true, page: page, search: searchText);
          }
        }
      }

      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        //load more if view reaches last index of page
      }
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

  void initAll() async {
    prefs = await SharedPreferences.getInstance();
    String _transactions = prefs.getString(Constant.TRANSACTIONS_CURRENT_PREF_KEY);
    if (_transactions != null) {
      transactions = json.decode(_transactions);
      if (this.mounted) {
        setState(() {});
      }
    }
    _getData();
  }

  _getData({more = false, silent = false, page = 1, search = ""}) async {
    if (more) {
      _loading = true;
      setState(() {});
    }
    if (!silent) {
      setState(() {
        _loading = true;
        _hasError = false;
      });
    }

    Map<String, dynamic> params = new Map();
    params["result_per_page"] = result_per_page;
    params["search"] = search;
    params["page"] = page;

    await _netUtil
        .post("${Constant.current_transactions}", context, body: params)
        .then((value) {
          setState(() {
            _loading = false;
          });
          pagination = value['pagination'];
          if (value['success'] == true) {
            if (more) {
              transactions.insertAll(
                  transactions.length, value['transactions']);
            } else {
              transactions = value['transactions'];
              prefs.setString(
                  Constant.TRANSACTIONS_CURRENT_PREF_KEY, json.encode(transactions));
            }
            _loading = false;
            _hasError = false;
            setState(() {});
          } else {
            _loading = false;
            if (!silent) {
              if (mounted) {
                _hasError = false;
                setState(() {});
              }
            }
          }
        })
        .timeout(Duration(seconds: 10))
        .catchError((error) {
          print("Error $error");
          _loading = false;
          if (!silent) {
            if (mounted) {
              setState(() {
                _hasError = true;
              });
            }
          }
        });
  }

  @override
  Future didChangeAppLifecycleState(AppLifecycleState state) async {
    if (mounted) await _getData(silent: true);
  }

  @override
  dispose() {
    scrollController.dispose();
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
                int count = 1;

                if (searched) {
                  count = 2;
                  listViews.add(Padding(
                    padding: const EdgeInsets.only(
                        left: 24, right: 24, top: 0, bottom: 10),
                    child: InkWell(
                      child: Text(
                        "clear search",
                        style: TextStyle(
                          fontFamily: CryptoTradeAppTheme.fontName,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          letterSpacing: 0.0,
                          color: CryptoTradeAppTheme.nearlyDarkRed,
                        ),
                      ),
                      onTap: () {
                        searched = false;
                        page = 1;
                        searchText = "";
                        _getData(page: page);
                      },
                    ),
                  ));
                }

                listViews.add(UnsoldTradeListView(
                  transactions: transactions,
                  loading: _loading,
                  hasError: _hasError,
                  reload: () async {
                    _getData();
                  },
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / count) * 1, 1.0,
                              curve: Curves.fastOutSlowIn))),
                  animationController: widget.animationController,
                ));

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
                                child: Row(
                                  children: [
                                    InkWell(
                                        child: Icon(Icons.arrow_back_rounded),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        }),
                                    Text(
                                      'Unsold',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily:
                                            CryptoTradeAppTheme.fontName,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 22 + 6 - 6 * topBarOpacity,
                                        letterSpacing: 1.2,
                                        color: CryptoTradeAppTheme.darkerText,
                                      ),
                                    ),
                                  ],
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
                                  InkWell(
                                    onTap: () async {
                                      Dialogs dialogs = new Dialogs();
                                      await dialogs.inputDialog(context,
                                          title: 'Search Unsold Trades',
                                          initialValue: '',
                                          hintText:
                                              '2021-04-15 | XML:USD | BTC',
                                          result: (result) async {
                                        if (result != null) {
                                          transactions = [];
                                          page = 1;
                                          searched = true;
                                          searchText = result;
                                          _getData(page: page, search: result);
                                        }
                                      }, cancel: () async {});
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Icon(
                                        Icons.search_sharp,
                                        color: CryptoTradeAppTheme.grey,
                                        size: 22,
                                      ),
                                    ),
                                  ),
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
