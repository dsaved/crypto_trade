import 'dart:math';

import 'package:crypto_trade/utils/constant.dart';
import 'package:flutter/material.dart';
import '../crypto_trade_app_theme.dart';

class AboutToTradeView extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;
  final List<dynamic> trading;

  const AboutToTradeView(
      {Key key, this.animationController, this.animation, this.trading})
      : super(key: key);

  @override
  _AboutToTradeViewState createState() => _AboutToTradeViewState();
}

class _AboutToTradeViewState extends State<AboutToTradeView> {
  @override
  Widget build(BuildContext context) {
    var trading = widget.trading != null ? widget.trading : null;
    List<Widget> widgets = [];

    if (trading != null) {
      for (var i = 0; i < trading.length; i++) {
        var trade = trading[i];
        widgets.add(Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 0),
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 6),
                child: Container(
                  decoration: BoxDecoration(
                    color: CryptoTradeAppTheme.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                        topRight: Radius.circular(8.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: CryptoTradeAppTheme.grey.withOpacity(0.4),
                          offset: Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        child: SizedBox(
                          height: 74,
                          child: AspectRatio(
                            aspectRatio: 1.714,
                            child: Opacity(
                                opacity: 0.5,
                                child: Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.rotationY(pi),
                                    child: Image.asset(
                                        "assets/crypto_trade_app/back.png"))),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left:8.0),
                            child: Image.asset('${Constant.crypto}${trade['ticker']}.png',width: 35,),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20,
                                        right: 16,
                                        top: 10,
                                      ),
                                      child: Text(
                                        "${trade['title']}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily: CryptoTradeAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          letterSpacing: 0.0,
                                          color: CryptoTradeAppTheme.nearlyDarkBlue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    bottom: 9,
                                    top: 4,
                                    right: 16,
                                  ),
                                  child: RichText(
                                    text: TextSpan(
                                      text:
                                      "Amount to buy ${trade['amount_to_buy']}\n",
                                      style: TextStyle(
                                        fontFamily: CryptoTradeAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        letterSpacing: 0.0,
                                        color: CryptoTradeAppTheme.grey.withOpacity(0.4),
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: "Current Price: ",
                                            style: TextStyle(
                                              fontFamily:
                                                  CryptoTradeAppTheme.fontName,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 11.5,
                                              letterSpacing: 0.0,
                                              color: CryptoTradeAppTheme.grey.withOpacity(0.4),
                                            )),
                                        TextSpan(
                                            text: "${trade['current_price']} ",
                                            style: TextStyle(
                                              fontFamily:
                                                  CryptoTradeAppTheme.fontName,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 11.5,
                                              letterSpacing: 0.0,
                                              color: CryptoTradeAppTheme.darkerText,
                                            )),
                                        TextSpan(
                                            text: "${trade['base_currency']}\nExpected Price: ",
                                            style: TextStyle(
                                              fontFamily:
                                              CryptoTradeAppTheme.fontName,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 11.5,
                                              letterSpacing: 0.0,
                                              color: CryptoTradeAppTheme.grey.withOpacity(0.4),
                                            )),
                                        TextSpan(
                                            text: "${trade['expected_price']} ",
                                            style: TextStyle(
                                              fontFamily:
                                                  CryptoTradeAppTheme.fontName,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 11.5,
                                              letterSpacing: 0.0,
                                              color: CryptoTradeAppTheme.nearlyDarkGreen,
                                            )),
                                        TextSpan(
                                            text: "${trade['base_currency']}\n${trade['d1']}\n${trade['d2']}",
                                            style: TextStyle(
                                              fontFamily:
                                              CryptoTradeAppTheme.fontName,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 11.5,
                                              letterSpacing: 0.0,
                                              color:  CryptoTradeAppTheme.grey.withOpacity(0.4),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
      }
    } else {
      widgets.add(Image.asset(
        Constant.splash,
      ));
    }
    widgets.add(SizedBox(height: 50));

    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation.value), 0.0),
            child: Column(
              children: widgets,
            ),
          ),
        );
      },
    );
  }
}
