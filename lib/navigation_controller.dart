import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart';

import 'customeInAppBrowser.dart';
import 'standard_request.dart';
import 'standard_response.dart';
import 'transaction_callback.dart';
import 'transaction_error.dart';

class NavigationController {
  Client client;
  TransactionCallBack callBack;
  bool isTestMode;
  BuildContext mainContext;
  NavigationController(
      {required this.client,
      required this.isTestMode,
      required this.callBack,
      required this.mainContext});

  startTransaction(final StandardRequest request) async =>
      await request.execute(client).then((StandardResponse standardResponse) {
        if (standardResponse.status == "error") {
          throw (TransactionError(standardResponse.message!));
        }
        _openBrowser(
          standardResponse.data?.link ?? "",
          request.redirectUrl,
        );
      });

  _openBrowser(
    final String url,
    final String redirectUrl,
  ) async{
    CustomInAppBrowser browser =
    CustomInAppBrowser(callBack: callBack);

    InAppBrowserClassOptions options = InAppBrowserClassOptions(
      crossPlatform: InAppBrowserOptions(
        hideUrlBar: true,
      ),
      inAppWebViewGroupOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          javaScriptEnabled: true,
        ),
      ),
    );
    await browser.openUrlRequest(
        urlRequest: URLRequest(url: Uri.parse(url)), options: options);
  }

}
