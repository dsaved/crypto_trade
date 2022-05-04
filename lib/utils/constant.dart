class Constant {
  static const String stats = '/home/stats';
  static const String auth_options = '/home/auth-option';
  static const String get_settings = '/home/settings';
  static const String update_base_currency = '/home/update-basecurrency';
  static const String transactions = '/transactions';
  static const String current_transactions = '/transactions/current';
  static const String single_transaction = '/transactions/get';
  static const String delete_trade = '/trade/delete';
  static const String update_trade = '/trade/update';
  static const String create_trade = '/trade/create';
  static const String single_trade = '/trade/get';
  static const String trades = '/trade';

  static const String regExpEmail = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
      "\\@" +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
      "(" +
      "\\." +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
      ")+";

  static const String STATS_PREF_KEY = 'stats';
  static const String TRADING_PREF_KEY = 'trading';
  static const String ABOUT_TO_BUY_PREF_KEY = 'ABOUT_TO_BUY';
  static const String AUTHS_PREF_KEY = 'auths';
  static const String TRANSACTIONS_PREF_KEY = '_transactions';
  static const String TRANSACTIONS_CURRENT_PREF_KEY = '_transactionsCurrent';
  static const String TRADES_PREF_KEY = '_trades';
  static const String AUTH_OPTION_PREF_KEY = 'auths_options';
  static const String BIOMETRIC_PREF_KEY = 'biometric';

  //crypto icons
  static const String crypto = 'assets/cryptos/';

  //Crypto trades
  static const List<String> cryptos = [
    "AAVE",
    "ADA",
    "BCH",
    "BTC",
    "BTT",
    "CVC",
    "DASH",
    "ETH",
    "KNC",
    "LINK",
    "MATIC",
    "MHC",
    "NEO",
    "OMG",
    "RSR",
    "TRX",
    "UMA",
    "WABI",
    "XLM",
    "XRP",
    "YFII",
    "ZIL",
    "ZWAP"
  ];

  //app images
  static const String logo = 'assets/images/logo.png';
  static const String error = 'assets/images/error.png';
  static const String waiting = 'assets/images/waiting.png';
  static const String logoWhite = 'assets/images/logo-white.png';
  static const String splash = 'assets/crypto_trade_app/splash.png';
}
