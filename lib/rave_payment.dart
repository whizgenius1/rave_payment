library rave_payment;

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'charge_response.dart';
import 'navigation_controller.dart';
import 'standard_request.dart';
import 'transaction_callback.dart';
import 'vuew_utils.dart';

class RavePayment implements TransactionCallBack {
  final StandardRequest request;
  final BuildContext mainContext;
  RavePayment({required this.mainContext, required this.request});

  Future<ChargeResponse> charge(
      {Widget? titleWidget,
        Widget? contentWidget,
        List<Widget> actions = const []}) async =>
      await showDialog(
          context: mainContext,
          builder: (_) => AlertDialog(
            title: titleWidget ??
                const Text(
                  'Confirm Transaction',
                  textAlign: TextAlign.center,
                ),
            content: contentWidget ??
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Text(
                    "You will be charged a total of ${request.currency}"
                        "${request.amount}. Do you wish to continue? ",
                    textAlign: TextAlign.center,
                  ),
                ),
            actions: actions.isEmpty
                ? [
              TextButton(
                onPressed: () => {Navigator.pop(mainContext)},
                child: const Text(
                  "CANCEL",
                ),
              ),
              TextButton(
                onPressed: () {
                  NavigationController controller =
                  NavigationController(
                      mainContext: mainContext,
                      client: Client(),
                      isTestMode: request.isTestMode,
                      callBack: this);
                  try {
                    controller.startTransaction(request);
                  } catch (e) {
                    _showErrorAndClose(e.toString());
                  }
                },
                child: const Text(
                  "CONTINUE",
                ),
              )
            ]
                : actions,
          ));

  void _showErrorAndClose(final String errorMessage) {
    ViewUtils.showToast(context: mainContext, text: errorMessage);
    Navigator.pop(mainContext); // return response to user
  }

  @override
  onCancelled() {
    // TODO: implement onCancelled
    ViewUtils.showToast(context: mainContext, text: "Transaction Cancelled");
    Navigator.pop(mainContext);
  }

  @override
  onTransactionError() {
    // TODO: implement onTransactionError
    _showErrorAndClose("Transaction error");
  }

  @override
  onTransactionSuccess(String id, String txRef) {
    // TODO: implement onTransactionSuccess
    final ChargeResponse chargeResponse = ChargeResponse(
        status: "success", success: true, transactionId: id, txRef: txRef);
    Navigator.pop(mainContext, chargeResponse);
  }
}