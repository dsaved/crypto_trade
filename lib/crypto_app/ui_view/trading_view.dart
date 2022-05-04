import 'dart:math';

import 'package:crypto_trade/utils/constant.dart';
import 'package:flutter/material.dart';
import '../crypto_trade_app_theme.dart';

class TradingView extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;
  final List<dynamic> trading;

  const TradingView(
      {Key key, this.animationController, this.animation, this.trading})
      : super(key: key);

  @override
  _TradingViewState createState() => _TradingViewState();
}

class _TradingViewState extends State<TradingView> {
  @override
  Widget build(BuildContext context) {
    var trading = widget.trading != null ? widget.trading : null;
    List<Widget> widgets = [];

    if (trading != null) {
      for (var i = 0; i < trading.length; i++) {
        var trade = trading[i];
        var _cryptoColor = CryptoTradeAppTheme.nearlyDarkRed;
        if (trade!=null) {
          if (trade['current_bid']!=null && trade['current_bid'] >= trade['gain']) {
            _cryptoColor = CryptoTradeAppTheme.nearlyDarkGreen;
          } else if (trade['current_bid']!=null && trade['current_bid'] > trade['buy_bid'] &&
              trade['current_bid'] < trade['gain']) {
            _cryptoColor = CryptoTradeAppTheme.nearlyDarkYellow;
          } else if (trade['current_bid']!=null && trade['current_bid'] == trade['buy_bid']) {
            _cryptoColor = CryptoTradeAppTheme.nearlyDarkBlue;
          }
        }
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
                                        "${trade['pair']} - ${trade['current_bid']}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily: CryptoTradeAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          letterSpacing: 0.0,
                                          color: _cryptoColor,
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
                                      "Bought @${trade['buy_bid']} \nCrypto will be sold when >= ",
                                      style: TextStyle(
                                        fontFamily: CryptoTradeAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        letterSpacing: 0.0,
                                        color: CryptoTradeAppTheme.grey.withOpacity(0.4),
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: "${double.parse('${trade['gain']}').toStringAsFixed(2)}",
                                            style: TextStyle(
                                              fontFamily:
                                                  CryptoTradeAppTheme.fontName,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12,
                                              letterSpacing: 0.0,
                                              color: CryptoTradeAppTheme.nearlyDarkGreen,
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
