import 'package:crypto_trade/crypto_app/crypto_trade_app_theme.dart';
import 'package:flutter/material.dart';

typedef void CurrencyCallback(String currency);

class BaseCurrencyView extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;
  final String currency;
  final CurrencyCallback onChange;

  const BaseCurrencyView(
      {Key key,
      this.animationController,
      this.animation,
      this.currency,
      this.onChange})
      : super(key: key);

  @override
  _BaseCurrencyViewState createState() => _BaseCurrencyViewState();
}

class _BaseCurrencyViewState extends State<BaseCurrencyView> {
  @override
  Widget build(BuildContext context) {
    String _currency = widget.currency.isNotEmpty ? widget.currency : null;
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
                                      'Base Currency',
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
                          left: 24, right: 24, top: 2, bottom: 4),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: Text(
                            "Base Currency",
                            style: TextStyle(
                              fontFamily: CryptoTradeAppTheme.fontName,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              letterSpacing: -0.2,
                              color: CryptoTradeAppTheme.grey.withOpacity(0.5),
                            ),
                          ),
                          value: _currency,
                          isExpanded: true,
                          icon: Icon(
                            Icons.edit,
                            color: CryptoTradeAppTheme.grey.withOpacity(0.5),
                          ),
                          items:
                              <String>['USD', 'EUR', 'GBP'].map((String value) {
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
                                  color:
                                      CryptoTradeAppTheme.grey.withOpacity(0.5),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (_) {
                            widget.onChange(_);
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, top: 1, bottom: 8),
                      child: Text(
                        'If base currency is changed, you will have to update all trades. Note: current trading transaction will not use new currency',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: CryptoTradeAppTheme.fontName,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: CryptoTradeAppTheme.nearlyDarkRed
                                .withOpacity(0.6)),
                      ),
                    ),
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
