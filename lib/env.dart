enum devMode { development, production }

class Env{
  static bool isRTL = false;

  static String appName="QR";

  static const dummyProfilePic = "";

  //Route names
  static const mainPage = "/";
  static const authPage = "/authPage";
  static const homePage = "/homePage";
  static const scanPage = "/scanPage";

  // Keys
  static const consumerKey = "ck_84bf021fb3836e4daa569acf30a4ed7b67485163";
  static const consumerSecret = "cs_c1c1fd46e311cd7c2625012b9f6337623034490b";

  static int databaseVersion=3;



//todo:please Set API Base Route
  static String _localUrl = 'http://192.168.1.20/joovlly/qr-laravel/public/api';
  static String _productionUrl = 'https://amr.qr.com/api';
  static devMode mode = devMode.production;

  static String get baseUrl {
  if (mode == devMode.development)
  return _localUrl;
  else
  return _productionUrl;
  }










}