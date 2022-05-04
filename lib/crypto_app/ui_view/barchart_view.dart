import 'package:crypto_trade/crypto_app/crypto_trade_app_theme.dart';
import 'package:crypto_trade/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import 'package:syncfusion_flutter_charts/charts.dart';

class BarchartDataView extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;
  final Map stats;

  const BarchartDataView(
      {Key key, this.animationController, this.animation, this.stats})
      : super(key: key);

  @override
  _BarchartDataViewState createState() => _BarchartDataViewState();
}

class _BarchartDataViewState extends State<BarchartDataView> {
  @override
  Widget build(BuildContext context) {
    var bar_chart = widget.stats != null ? widget.stats['bar_chart'] : null;

    List<SalesData> statsData = [];
    statsData.add(SalesData(null, 0));
    if (bar_chart != null) {
      for (var i = 0; i < bar_chart.length; i++) {
        var inputFormat = DateFormat('yyyy-MM-dd');
        var inputDate =
            inputFormat.parse(bar_chart[i]['date']); // <-- Incoming date
        var outputFormat = DateFormat('dd');
        var outputDate = outputFormat.format(inputDate); // <-- Desired date
        int checkNum = int.parse('$outputDate');
        if (checkNum == 1 || checkNum == 21 || checkNum == 31) {
          outputDate = '${outputDate}st';
        } else if (checkNum == 2 || checkNum == 22) {
          outputDate = '${outputDate}nd';
        } else if (checkNum == 3 || checkNum == 23) {
          outputDate = '${outputDate}rd';
        } else {
          outputDate = '${outputDate}th';
        }
        statsData
            .add(SalesData(outputDate, double.parse(bar_chart[i]['profit'])));
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
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
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
                        color: CryptoTradeAppTheme.grey.withOpacity(0.2),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Container(
                        height: 200,
                        child: SfCartesianChart(
                            isTransposed: false,
                            title: ChartTitle(text: 'Daily Profit'),
                            // Initialize category axis
                            primaryXAxis: CategoryAxis(),
                            series: <SplineSeries<SalesData, String>>[
                              SplineSeries<SalesData, String>(
                                  // Bind data source
                                  dataSource: statsData,
                                  splineType: SplineType.cardinal,
                                  cardinalSplineTension: 0.4,
                                  xValueMapper: (SalesData sales, _) =>
                                      sales.day,
                                  yValueMapper: (SalesData sales, _) =>
                                      sales.count,
                                  emptyPointSettings: EmptyPointSettings(
                                      // Mode of empty point
                                      mode: EmptyPointMode.zero))
                            ]),
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

class SalesData {
  SalesData(this.day, this.count);

  final String day;
  final double count;
}
