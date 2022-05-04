import 'dart:math';

import 'package:crypto_trade/crypto_app/my_history_page/transaction_info_screen.dart';
import 'package:crypto_trade/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import '../crypto_trade_app_theme.dart';

class TransactionListView extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;
  final List<dynamic> transactions;
  final bool loading, hasError;
  final VoidCallback reload;

  const TransactionListView(
      {Key key,
      this.animationController,
      this.animation,
      this.transactions,
      this.reload,
      this.loading,
      this.hasError})
      : super(key: key);

  @override
  _TransactionListViewState createState() => _TransactionListViewState();
}

class _TransactionListViewState extends State<TransactionListView> {

  void viewHistoryData(Map<String,dynamic> transaction){

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TransactionInfoScreen(transaction: transaction,),
        ));
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> transactions =
        widget.transactions != null ? widget.transactions : null;
    List<Widget> widgets = [];

    if (transactions != null) {
      for (var i = 0; i < transactions.length; i++) {
        var transaction = transactions[i];
        var sales = transaction['sale'];
        var profit = double.parse(sales['symbol2Amount']) -
            double.parse(transaction['symbol2Amount']);
        bool gain = true;
        if (profit < 0) {
          gain = false;
        }

        var currency = transaction['pair'].split(':')[1];
        widgets.add(Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 0),
          child: GestureDetector(
            onTap: (){viewHistoryData(transaction);},
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topRight,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
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
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Image.asset(
                                  '${Constant.crypto}${transaction['ticker']}.png',
                                  width: 35),
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
                                          "${transaction['pair']}",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontFamily:
                                                CryptoTradeAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            letterSpacing: 0.0,
                                            color: gain
                                                ? CryptoTradeAppTheme.nearlyDarkBlue
                                                : CryptoTradeAppTheme.nearlyDarkRed,
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
                                      "Purchase Price: ${transaction['symbol2Amount']}\nSold Price: ${sales['symbol2Amount']}",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: CryptoTradeAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10,
                                        letterSpacing: 0.0,
                                        color: CryptoTradeAppTheme.nearlyBlack
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      bottom: 9,
                                      top: 4,
                                      right: 16,
                                    ),
                                    child: Text(
                                      "Profit: ${profit.toStringAsFixed(2)} $currency",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: CryptoTradeAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        letterSpacing: 0.0,
                                        color: gain
                                            ? CryptoTradeAppTheme.nearlyDarkBlue.withOpacity(.5)
                                            : CryptoTradeAppTheme.nearlyDarkRed,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                SizedBox(height: 50),
                                Padding(
                                  padding: const EdgeInsets.only(right:5.0),
                                  child: Text(transaction['datetime'],
                                  style: TextStyle(
                                    fontFamily: CryptoTradeAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    letterSpacing: 0.0,
                                    color: gain
                                        ? CryptoTradeAppTheme.nearlyDarkBlue
                                        : CryptoTradeAppTheme.nearlyDarkRed,
                                  ),),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 5,
                  left: 0,
                  child: Container(
                    width: 6,
                    height: 70,
                    decoration: BoxDecoration(
                      color: gain
                          ? CryptoTradeAppTheme.nearlyDarkGreen
                          : CryptoTradeAppTheme.nearlyDarkRed,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                          topRight: Radius.circular(8.0)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
      }
    }

    if (widget.loading) {
      widgets.add(Center(
        child: GlowingProgressIndicator(
          child: Icon(
            Icons.radio_button_checked,
            color: CryptoTradeAppTheme.nearlyBlue,
            size: 45,
          ),
        ),
      ));
    }

    if (transactions.isEmpty || transactions == null) {
      if (widget.hasError) {
        widgets.add(Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 8, right: 8),
                child: Image.asset(
                  Constant.error,
                  width: 300,
                ),
              ),
            ),
            Center(
              child: Text(
                'Error Loading Transactions',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: CryptoTradeAppTheme.fontName,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: 1.2,
                  color: CryptoTradeAppTheme.nearlyBlack,
                ),
              ),
            ),
            !widget.loading
                ? Center(
                    child: ElevatedButton(
                      onPressed: widget.reload,
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              CryptoTradeAppTheme.getColor),
                          enableFeedback: true),
                      child: Text(
                        'Try Again',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: CryptoTradeAppTheme.fontName,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          letterSpacing: 1.2,
                          color: CryptoTradeAppTheme.white,
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ));
      } else {
        widgets.add(Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 8, right: 8),
            child: Image.asset(
              Constant.waiting,
              width: 300,
            ),
          ),
        ));
      }
    }

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
