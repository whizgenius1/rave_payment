import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:rave_payment/customer_model.dart';

import 'standard_response.dart';
import 'sub_account.dart';
import 'transaction_error.dart';
import 'utils.dart';

class StandardRequest {
  final String txRef;
  final String amount;
  final CustomerModel customer;
  final bool isTestMode;
  final String publicKey;
  final String paymentOptions;
  final String redirectUrl;
  final String? currency;
  final String? paymentPlanId;
  final List<SubAccount>? subAccounts;
  final Map<dynamic, dynamic>? meta;

  StandardRequest(
      {required this.txRef,
      required this.amount,
      required this.customer,
      required this.paymentOptions,
      required this.isTestMode,
      required this.publicKey,
      required this.redirectUrl,
      this.currency,
      this.paymentPlanId,
      this.subAccounts,
      this.meta});

  @override
  String toString() => jsonEncode(_toJson());

  Map<String, dynamic> _toJson() {
    return {
      "tx_ref": txRef,
      "publicKey": publicKey,
      "amount": amount,
      "currency": currency,
      "payment_options": paymentOptions,
      "payment_plan": paymentPlanId,
      "redirect_url": redirectUrl,
      "customer": customer.toJson(),
      "subaccounts": subAccounts?.map((e) => e.toJson()).toList(),
      "meta": meta,
    };
  }

  Future<StandardResponse> execute(Client client) async {
    final url = Utils.getBaseUrl(isTestMode) + Utils.standardPayment;
    final uri = Uri.parse(url);
    try {
      final response = await client.post(uri,
          headers: {
            HttpHeaders.authorizationHeader: publicKey,
            HttpHeaders.contentTypeHeader: 'application/json'
          },
          body: json.encode(_toJson()));
      final responseBody = json.decode(response.body);
      if (responseBody["status"] == "error") {
        throw TransactionError(responseBody["message"] ??
            "An unexpected error occurred. Please try again.");
      }
      return StandardResponse.fromJson(responseBody);
    } catch (error) {
      rethrow;
    }
  }
}
