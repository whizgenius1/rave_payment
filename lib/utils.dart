class Utils {
  static const String defaultURL = "https://www.google.com";
  static const String _productionBaseURL = "https://api.ravepay.co/v3/sdkcheckout/";
  static const String standardPayment = "payments";
  static const String _debugBaseURL =
      "https://ravesandboxapi.flutterwave.com/v3/sdkcheckout/";

  /// Returns base url depending on test mode
  static String getBaseUrl(final bool isTestMode) {
    return isTestMode ? _debugBaseURL : _productionBaseURL;
  }

}
