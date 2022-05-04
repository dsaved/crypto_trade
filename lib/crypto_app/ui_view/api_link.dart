import 'package:crypto_trade/crypto_app/crypto_trade_app_theme.dart';
import 'package:flutter/material.dart';

class ApiLinkView extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;
  final bool status;
  final String link;
  final VoidCallback onClick;

  const ApiLinkView(
      {Key key, this.animationController, this.animation, this.status, this.link, this.onClick})
      : super(key: key);

  @override
  _ApiLinkViewState createState() => _ApiLinkViewState();
}

class _ApiLinkViewState extends State<ApiLinkView> {
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
                                      'API End Point',
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
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        widget.status
                                            ? Icons.check_circle_outline
                                            : Icons.error_outline,
                                        color: widget.status
                                            ? CryptoTradeAppTheme.nearlyDarkGreen
                                                .withOpacity(0.5)
                                            : CryptoTradeAppTheme.nearlyDarkRed
                                                .withOpacity(0.5),
                                        size: 16,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          widget.status ? 'Online' : 'Offline',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily:
                                                CryptoTradeAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            letterSpacing: 0.0,
                                            color: widget.status
                                                ? CryptoTradeAppTheme
                                                    .nearlyDarkBlue
                                                : CryptoTradeAppTheme
                                                    .nearlyDarkRed,
                                          ),
                                        ),
                                      ),
                                    ],
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
                                  '${widget.link}',
                                  textAlign: TextAlign.center,
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
                                GestureDetector(
                                  onTap: widget.onClick,
                                  child: Icon(
                                    Icons.edit,
                                    color: CryptoTradeAppTheme.grey
                                        .withOpacity(0.5),
                                  ),
                                )
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
