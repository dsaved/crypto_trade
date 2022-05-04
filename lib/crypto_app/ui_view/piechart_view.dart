import 'package:crypto_trade/crypto_app/crypto_trade_app_theme.dart';
import 'package:crypto_trade/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import 'package:syncfusion_flutter_charts/charts.dart';

class PiechartDataView extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;
  final Map stats;

  const PiechartDataView(
      {Key key, this.animationController, this.animation, this.stats})
      : super(key: key);

  @override
  _PiechartDataViewState createState() => _PiechartDataViewState();
}

class _PiechartDataViewState extends State<PiechartDataView> {
  @override
  Widget build(BuildContext context) {
    var pie_chart = widget.stats != null ? widget.stats['pie_chart'] : null;

    List<_PieData> statsData = [];
    if (pie_chart != null) {
      for (var i = 0; i < pie_chart.length; i++) {
        var dataD = pie_chart[i];
        statsData.add(_PieData(dataD['name'], int.parse('${dataD['count']}'),
            dataD['percentage']));
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
                            const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
                        child: SfCircularChart(
                            title: ChartTitle(text: 'Transaction Summary'),
                            legend: Legend(isVisible: true, position: LegendPosition.top),
                            series: <PieSeries<_PieData, String>>[
                              PieSeries<_PieData, String>(
                                  enableSmartLabels: false,
                                  enableTooltip: false,
                                  legendIconType: LegendIconType.invertedTriangle,
                                  radius: '110%',
                                  explode: true,
                                  explodeIndex: 0,
                                  dataSource: statsData,
                                  xValueMapper: (_PieData data, _) =>
                                      data.xData,
                                  yValueMapper: (_PieData data, _) =>
                                      data.yData,
                                  dataLabelMapper: (_PieData data, _) =>
                                      data.text,
                                  dataLabelSettings: DataLabelSettings(
                                      isVisible: true,
                                      labelPosition:
                                          ChartDataLabelPosition.inside)),
                            ])),
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
  SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

class _PieData {
  _PieData(this.xData, this.yData, [this.text]);

  final String xData;
  final num yData;
  final String text;
}
