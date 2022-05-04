import 'package:crypto_trade/crypto_app/models/tabIcon_data.dart';
import 'package:crypto_trade/crypto_app/models/trade_manager.dart';
import 'package:crypto_trade/crypto_app/my_trade_tickers_page/trade_tickers_page.dart';
import 'package:crypto_trade/crypto_app/trading/trading_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import 'crypto_trade_app_theme.dart';
import 'my_dashboard/my_dashboard_screen.dart';
import 'my_settings_view/my_settings_screen.dart';

class FitnessAppHomeScreen extends StatefulWidget {
  @override
  _FitnessAppHomeScreenState createState() => _FitnessAppHomeScreenState();
}

class _FitnessAppHomeScreenState extends State<FitnessAppHomeScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: CryptoTradeAppTheme.background,
  );

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    tabBody = MyDashboardScreen(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CryptoTradeAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {
            showMaterialModalBottomSheet(
              context: context,
              builder: (context) => TradeManager(completed: (){},),
            );
          },
          changeIndex: (int index) {
            switch (index) {
              case 0:
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = MyDashboardScreen(
                      animationController: animationController);
                });
                // animationController.reverse().then<dynamic>((data) {
                //   setState(() {
                //     tabBody = MyDashboardScreen(
                //         animationController: animationController);
                //   });
                // });
                break;
              case 1:
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      TradeScreen(animationController: animationController);
                });
                break;
              case 2:
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = TradeTickerPage(
                      animationController: animationController);
                });
                break;
              case 3:
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = MySettingsScreen(
                      animationController: animationController);
                });
                break;
            }
          },
        ),
      ],
    );
  }
}
