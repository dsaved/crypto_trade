import 'package:crypto_trade/crypto_app/crypto_trade_app_theme.dart';
import 'package:crypto_trade/utils/constant.dart';
import 'package:flutter/material.dart';

class TransactionInfoScreen extends StatefulWidget {
  final Map<String, dynamic> transaction;

  const TransactionInfoScreen({Key key, this.transaction}) : super(key: key);

  @override
  _TransactionInfoScreenState createState() => _TransactionInfoScreenState();
}

class _TransactionInfoScreenState extends State<TransactionInfoScreen>
    with TickerProviderStateMixin {
  final double infoHeight = 364.0;
  AnimationController animationController;
  Animation<double> animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
    super.initState();
  }

  Future<void> setData() async {
    animationController.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity2 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final transaction = widget.transaction;
    final sale = widget.transaction['sale'];
    final double tempHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        24.0;

    var profit = double.parse(sale['symbol2Amount']) -
        double.parse(transaction['symbol2Amount']);
    bool gain = true;
    if (profit < 0) {
      gain = false;
    }

    final currency = transaction['pair'].split(':')[1];

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

    var dateParse = DateTime.parse(transaction['datetime']);
    var formattedDate = "${dateParse.day}/${dateParse.month}/${dateParse.year}";
    var formattedTime =
        "${dateParse.hour}:${dateParse.minute}:${dateParse.second}";

    return Container(
      color: CryptoTradeAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Image.asset(
                          Constant.splash,
                          scale: .5,
                        ),
                        Center(
                          child: Image.asset(
                            '${Constant.crypto}${widget.transaction['ticker']}.png',
                            width: 150,
                            height: 150,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: (MediaQuery.of(context).size.width / 1.2) - 60.0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: CryptoTradeAppTheme.nearlyWhite,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32.0),
                      topRight: Radius.circular(32.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: CryptoTradeAppTheme.grey.withOpacity(0.2),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(
                          minHeight: infoHeight,
                          maxHeight: tempHeight > infoHeight
                              ? tempHeight
                              : infoHeight),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 32.0, left: 18, right: 16),
                            child: Text(
                              '${transaction['pair']}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                                letterSpacing: 0.27,
                                color: CryptoTradeAppTheme.darkerText,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 7, top: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Bought: ${transaction['symbol2Amount']} $currency',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 16,
                                    letterSpacing: 0.27,
                                    color: CryptoTradeAppTheme.nearlyDarkBlue,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Sold: ${sale['symbol2Amount']} $currency',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 16,
                                    letterSpacing: 0.27,
                                    color: CryptoTradeAppTheme.nearlyDarkBlue,
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Profit: ${profit.toStringAsFixed(2)} $currency",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 15,
                                          letterSpacing: 0.27,
                                          color: gain
                                              ? CryptoTradeAppTheme
                                                  .nearlyDarkBlue
                                                  .withOpacity(.5)
                                              : CryptoTradeAppTheme
                                                  .nearlyDarkRed,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: opacity1,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  getTimeBoxUI(
                                      '${transaction['symbol1Amount']}',
                                      'Crypto'),
                                  getTimeBoxUI('$formattedTime', 'Time'),
                                  getTimeBoxUI('$formattedDate', 'Date'),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Buy Details',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 18,
                                    letterSpacing: 0.27,
                                    color: CryptoTradeAppTheme.nearlyBlack,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: opacity2,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 8, bottom: 8),
                                child: Text(
                                  'Transaction ID: ${transaction['transid']}'
                                  '\nLow: ${transaction['low']}'
                                  '\nHigh: ${transaction['high']}'
                                  '\nLast: ${transaction['last']}'
                                  '\nVolume: ${transaction['volume']}'
                                  '\nAsk: ${transaction['ask']}'
                                  '\nBid: ${transaction['bid']}',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    letterSpacing: 0.20,
                                    color: CryptoTradeAppTheme.grey,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Sell Details',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 18,
                                    letterSpacing: 0.27,
                                    color: CryptoTradeAppTheme.nearlyBlack,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: opacity2,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 8, bottom: 8),
                                child: Text(
                                  'Transaction ID: ${sale['transid']}'
                                  '\nLow: ${sale['low']}'
                                  '\nHigh: ${sale['high']}'
                                  '\nLast: ${sale['last']}'
                                  '\nVolume: ${sale['volume']}'
                                  '\nAsk: ${sale['ask']}'
                                  '\nBid: ${sale['bid']}',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    letterSpacing: 0.20,
                                    color: CryptoTradeAppTheme.grey,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).padding.bottom,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: SizedBox(
                width: AppBar().preferredSize.height,
                height: AppBar().preferredSize.height,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(AppBar().preferredSize.height),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: CryptoTradeAppTheme.nearlyBlack,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getTimeBoxUI(String text1, String txt2) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        decoration: BoxDecoration(
          color: CryptoTradeAppTheme.nearlyWhite,
          borderRadius: const BorderRadius.all(Radius.circular(14.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: CryptoTradeAppTheme.grey.withOpacity(0.2),
                offset: const Offset(1.1, 1.1),
                blurRadius: 8.0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 15.0, right: 15.0, top: 12.0, bottom: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                text1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  letterSpacing: 0.17,
                  color: CryptoTradeAppTheme.nearlyBlue,
                ),
              ),
              Text(
                txt2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 13,
                  letterSpacing: 0.17,
                  color: CryptoTradeAppTheme.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
