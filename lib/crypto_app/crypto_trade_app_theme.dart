import 'package:flutter/material.dart';

class CryptoTradeAppTheme {
  CryptoTradeAppTheme._();
  static const Color nearlyWhite = Color(0xFFFAFAFA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF2F3F8);
  static const Color nearlyDarkBlue = Color(0xFF2633C5);
  static const Color nearlyDarkGreen = Color(0xFF26C529);
  static const Color nearlyDarkYellow = Color(0xFFC5B526);
  static const Color nearlyDarkRed = Color(0xFFC5262B);

  static const Color nearlyBlue = Color(0xFF00B6F0);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color spacer = Color(0xFFF2F2F2);
  static const _bluePrimaryValue = 0xFF3f51b5;
  static const String fontName = 'Roboto';

  static const MaterialColor blueMaterial =
  MaterialColor(_bluePrimaryValue, <int, Color>{
    50: const Color(0xFFe8eaf6),
    100: const Color(0xFF9fa8da),
    200: const Color(0xFF9fa8da),
    300: const Color(0xFF7986cb),
    400: const Color(0xFF5c6bc0),
    500: const Color(_bluePrimaryValue),
    600: const Color(0xFF3949ab),
    700: const Color(0xFF303f9f),
    800: const Color(0xFF283593),
    900: const Color(0xFF1a237e)
  });

  static const Map<int, Color> blue = const <int, Color>{
    50: const Color(0xFFe8eaf6),
    100: const Color(0xFF9fa8da),
    200: const Color(0xFF9fa8da),
    300: const Color(0xFF7986cb),
    400: const Color(0xFF5c6bc0),
    500: const Color(_bluePrimaryValue),
    600: const Color(0xFF3949ab),
    700: const Color(0xFF303f9f),
    800: const Color(0xFF283593),
    900: const Color(0xFF1a237e)
  };

  static Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return CryptoTradeAppTheme.blue[600];
    }
    return CryptoTradeAppTheme.blue[400];
  }

  static Color redColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Color(0xFFC5262B);
    }
    return Color(0xFFE33A3F);
  }

  static const IconThemeData iconTheme = IconThemeData(
    color: CryptoTradeAppTheme.nearlyBlack
  );

  static const TextTheme textTheme = TextTheme(
    headline4: display1,
    headline5: headline,
    headline6: title,
    subtitle2: subtitle,
    bodyText2: body2,
    bodyText1: body1,
    caption: caption,
  );

  static const TextStyle display1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText, // was lightText
  );
}
