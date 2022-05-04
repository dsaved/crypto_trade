import 'dart:math';

import 'package:crypto_trade/crypto_app/models/trade_manager.dart';
import 'package:crypto_trade/network/network_util.dart';
import 'package:crypto_trade/utils/Dialogs.dart';
import 'package:crypto_trade/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:toast/toast.dart';
import '../crypto_trade_app_theme.dart';

class TradTickerView extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;
  final List<dynamic> trades;
  final bool loading, hasError;
  final VoidCallback reload;

  const TradTickerView(
      {Key key,
      this.animationController,
      this.animation,
      this.trades,
      this.reload,
      this.loading,
      this.hasError})
      : super(key: key);

  @override
  _TradTickerViewState createState() => _TradTickerViewState();
}

class _TradTickerViewState extends State<TradTickerView> {
  // ignore: non_constant_identifier_names
  String Ucfirst(word) {
    return "${word[0].toUpperCase()}${word.substring(1)}";
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> trades = widget.trades != null ? widget.trades : null;
    List<Widget> widgets = [];

    if (trades != null) {
      for (var i = 0; i < trades.length; i++) {
        var trade = trades[i];
        bool active = true;
        if (trade['status'] == 'inactive') {
          active = false;
        }

        var currency = trade['base_currency'];
        widgets.add(Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 10),
          child: InkWell(
            onDoubleTap: () {
              showMaterialModalBottomSheet(
                  context: context,
                  builder: (context) =>
                      TradeManager(trade: trade, completed: widget.reload));
            },
            onLongPress: () {
              showMaterialModalBottomSheet(
                expand: false,
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => Container(
                  color: CryptoTradeAppTheme.nearlyWhite,
                  height: 140,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Delete ${trade['ticker']} Trade!",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: CryptoTradeAppTheme.fontName,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            letterSpacing: 0.25,
                            color: CryptoTradeAppTheme.nearlyBlack,
                          ),
                        ),
                        Text(
                          "Are you sure you want to delete this trade?",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: CryptoTradeAppTheme.fontName,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            letterSpacing: 0.15,
                            color: CryptoTradeAppTheme.dark_grey,
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 30.0, right: 30.0, top: 20.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.cancel),
                                      Text("Cancel")
                                    ],
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              CryptoTradeAppTheme.getColor),
                                      enableFeedback: true),
                                )),
                            Expanded(child: Container()),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 30.0, right: 30.0, top: 20.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    deleteTrade(trade['id']);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete_forever),
                                      Text("Delete")
                                    ],
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              CryptoTradeAppTheme.redColor),
                                      enableFeedback: true),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 2,
                  height: 120,
                  decoration: BoxDecoration(
                    color: active
                        ? CryptoTradeAppTheme.nearlyDarkGreen
                        : CryptoTradeAppTheme.nearlyDarkRed,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                        topRight: Radius.circular(8.0)),
                  ),
                ),
                Expanded(
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
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Image.asset(
                                  '${Constant.crypto}${trade['ticker']}.png',
                                  width: 35),
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
                                        "${trade['ticker']}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily:
                                              CryptoTradeAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          letterSpacing: 0.0,
                                          color: active
                                              ? CryptoTradeAppTheme
                                                  .nearlyDarkBlue
                                              : CryptoTradeAppTheme
                                                  .nearlyDarkRed,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    bottom: 4,
                                    top: 4,
                                    right: 16,
                                  ),
                                  child: Text(
                                    "Amount To Buy: ${trade['buy_amount']} $currency\n"
                                    "Number Of Trades: ${trade['number_of_trades']}\n"
                                    "Change In Percentage (Buy): ${trade['change_percentage_buy']}%\n"
                                    "Change In Percentage (Sell): ${trade['change_percentage_sell']}%\n"
                                    "Base Currency: $currency",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily:
                                          CryptoTradeAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      letterSpacing: 0.24,
                                      wordSpacing: 1,
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
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Status: ${Ucfirst(trade['status'])}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily:
                                          CryptoTradeAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          letterSpacing: 0.3,
                                          color: active
                                              ? CryptoTradeAppTheme.nearlyDarkBlue
                                              .withOpacity(.5)
                                              : CryptoTradeAppTheme.nearlyDarkRed,
                                        ),
                                      ),
                                      SizedBox(width: 25.0,),
                                      Text(
                                        "Trading: ${Ucfirst(trade['trading'])}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily:
                                          CryptoTradeAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          letterSpacing: 0.3,
                                          color: trade['trading']=="yes"
                                              ? CryptoTradeAppTheme.nearlyDarkBlue
                                              .withOpacity(.5)
                                              : CryptoTradeAppTheme.nearlyDarkRed,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
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

    if (trades.isEmpty || trades == null) {
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
                        'Try Active',
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

  void deleteTrade(id) async {
    NetworkUtil _netUtil = new NetworkUtil();
    Dialogs dialogs = new Dialogs();
    dialogs.loading(context, "Deleting trade, Please wait", Dialogs.GLOWING);
    await _netUtil.post("${Constant.delete_trade}", context,
        body: {"id": id}).then((value) async {
      dialogs.close(context);
      Toast.show("The Trade has been deleted successfully", context);
      if (value['success'] == true) {
        widget.reload();
        Navigator.pop(context);
      }
    }).catchError((error) {
      dialogs.close(context);
      Toast.show("Error $error", context);
      print("Error $error");
    });
  }
}
