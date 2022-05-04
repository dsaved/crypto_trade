import 'package:crypto_trade/crypto_app/crypto_trade_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:percent_indicator/percent_indicator.dart';

typedef void AcceptCallBack(bool success);
typedef Future<void> InputCallBack(String text);

class Dialogs {
  static const SCALE_TRANSITION = 1,
      SLIDE_TRANSITION = 2,
      GLOWING = 3,
      TEXT_JUMPING = 4,
      TEXT_FADING = 5,
      TEXT_SLIDING = 6;

  bool isLoading = false;

  infoDialog(BuildContext context, String mTitle, String description,
      {AcceptCallBack onPressed}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: CryptoTradeAppTheme.nearlyWhite,
            title: Text(
              mTitle,
              style: TextStyle(
                  color: CryptoTradeAppTheme.nearlyDarkBlue,
                  fontWeight: FontWeight.bold),
            ),
            content: Container(
              color: Colors.grey[100],
              child: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(description, style: TextStyle(color: Colors.black))
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onPressed(true);
                },
                child: Text(
                  'Okay',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          );
        });
  }

  Future<void> inputDialog(BuildContext context,
      {initialValue = '',
      title,
      hintText,
      InputCallBack result,
      VoidCallback cancel,
      TextInputType textType = TextInputType.url}) async {
    TextEditingController _textFieldController = TextEditingController();
    _textFieldController.text = initialValue;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('$title'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: hintText),
            keyboardType: textType,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
                cancel();
              },
            ),
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.pop(context);
                result(_textFieldController.text);
              },
            ),
          ],
        );
      },
    );
  }

  loading(BuildContext context, String mTitle, int loader) {
    Widget loadContent;
    switch (loader) {
      case SCALE_TRANSITION:
        loadContent = CollectionScaleTransition(
          children: <Widget>[
            Icon(Icons.keyboard_arrow_right, color: Colors.white),
            Icon(Icons.keyboard_arrow_right, color: Colors.white),
            Icon(Icons.keyboard_arrow_right, color: Colors.white),
          ],
        );
        break;
      case SLIDE_TRANSITION:
        loadContent = CollectionSlideTransition(
          children: <Widget>[
            Icon(
              Icons.apps,
              color: CryptoTradeAppTheme.grey,
            ),
            Icon(
              Icons.apps,
              color: CryptoTradeAppTheme.grey,
            ),
            Icon(
              Icons.apps,
              color: CryptoTradeAppTheme.grey,
            ),
          ],
        );
        break;
      case GLOWING:
        loadContent = GlowingProgressIndicator(
          child: Icon(
            Icons.radio_button_checked,
            color: CryptoTradeAppTheme.nearlyBlue,
          ),
        );
        break;
      case TEXT_JUMPING:
        loadContent = JumpingText('Please Wait...');
        break;
      case TEXT_FADING:
        loadContent = FadingText('Please Wait...');
        break;
      case TEXT_SLIDING:
        loadContent = ScalingText('Please Wait...');
        break;
      default:
        loadContent = CollectionScaleTransition(
          children: <Widget>[
            Icon(Icons.keyboard_arrow_right),
            Icon(Icons.keyboard_arrow_right),
            Icon(Icons.keyboard_arrow_right),
          ],
        );
        break;
    }

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          this.isLoading = true;
          return AlertDialog(
              backgroundColor: CryptoTradeAppTheme.nearlyWhite,
              title: Text(mTitle,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      color: CryptoTradeAppTheme.grey)),
              content: SingleChildScrollView(
                child: Center(
                  child: ListBody(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          loadContent,
                        ],
                      ),
                    ],
                  ),
                ),
              ));
        });
  }

  close(BuildContext context) {
    if (this.isLoading) {
      this.isLoading = false;
      Navigator.pop(context);
    }
  }

  confirm(BuildContext context, String mTitle, String description,
      {AcceptCallBack onPressed}) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: CryptoTradeAppTheme.grey,
            title: Text(mTitle,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CryptoTradeAppTheme.nearlyBlue)),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    description,
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onPressed(false);
                },
                child: Text('Cancel',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        fontSize: 18)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onPressed(true);
                },
                child: Text('Okay',
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 18)),
              ),
            ],
          );
        });
  }

  progress(
      BuildContext context, String mTitle, String progressText, double progress,
      {AcceptCallBack onPressed}) {
    print("current progress: $progress");
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        if (progress >= 1.0) {
          Navigator.of(context).pop();
        }

        return AlertDialog(
          title: new Text(
            mTitle,
            style: TextStyle(fontSize: 14.0),
          ),
          content: Padding(
            padding: EdgeInsets.all(8.0),
            child: new LinearPercentIndicator(
              width: 180.0,
              lineHeight: 14.0,
              percent: progress,
              center: Text(
                "$progressText",
                style: new TextStyle(fontSize: 12.0),
              ),
              trailing: Icon(Icons.music_note),
              linearStrokeCap: LinearStrokeCap.roundAll,
              backgroundColor: Colors.grey,
              progressColor: Colors.blue,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                onPressed(true);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
