import 'dart:math';

import 'package:crypto_trade/crypto_app/crypto_trade_app_theme.dart';
import 'package:crypto_trade/utils/constant.dart';
import 'package:flutter/material.dart';

class AuthListView extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;
  final Map<String, dynamic> auths;

  const AuthListView(
      {Key key, this.animationController, this.animation, this.auths})
      : super(key: key);

  @override
  _AuthListViewState createState() => _AuthListViewState();
}

class _AuthListViewState extends State<AuthListView> {
  @override
  Widget build(BuildContext context) {
    var auths = widget.auths != null ? widget.auths : null;
    List<Widget> widgets = [];

    if (auths != null) {
      auths.forEach((key, value) {
        List api_key = value['apiKey'].split('');
        var apiKey = '***************';
        if(api_key.length>6){
          apiKey = '***************${api_key.sublist(api_key.length-5,api_key.length).join('')}';
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
                      Column(
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
                                  "$key - ${value['userID']}",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: CryptoTradeAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    letterSpacing: 0.0,
                                    color: CryptoTradeAppTheme.nearlyBlack,
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
                              child: Text(
                                "key: ${apiKey}\nSecret: ${value['apiSecret']}",
                                style: TextStyle(
                                  fontFamily: CryptoTradeAppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  letterSpacing: 0.0,
                                  color:
                                      CryptoTradeAppTheme.grey.withOpacity(0.4),
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
      });
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
