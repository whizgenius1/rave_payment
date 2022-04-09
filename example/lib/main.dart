import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rave_payment/charge_response.dart';
import 'package:rave_payment/customer_model.dart';
import 'package:rave_payment/rave_payment.dart';
import 'package:rave_payment/standard_request.dart';
import 'package:rave_payment/utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('add'),

            TextButton(onPressed: () async{
              final String transactionRef =
                  "${DateTime.now().microsecondsSinceEpoch}-${Platform.operatingSystem}-testservice";
              CustomerModel customer = CustomerModel(
                  name: 'Jane Doe',
                  phoneNumber: "1234566677777",
                  email: "janedoe@gmail.com");
              final request = StandardRequest(
                txRef: transactionRef,
                amount: '300',
                customer: customer,
                paymentOptions: "ussd, card, barter, payattitude",
                isTestMode: true,
                publicKey: 'FLWPUBK_TEST-0ba4f458f17481551940925fd15eecd3-X',
                currency: 'NGN',
                //paymentPlanId: paymentPlanId,
                redirectUrl: Utils.defaultURL,
                // redirectUrl: redirectUrl ?? Utils.DEFAULT_URL,
                //subAccounts: subAccounts,
                //meta: meta
              );

              RavePayment payment = RavePayment(
                mainContext: context,
                request: request,
              );

              ChargeResponse response = await payment.charge();

              print('test D');
              print(response.toString());
              print(response.success);
              print(response.status);
              print(response.transactionId);
              print(response.txRef);
              print(response.toJson());
              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text(
                      "Payment Details",
                      textAlign: TextAlign.center,
                    ),
                    content: Text('${response.toJson()}',
                        textAlign: TextAlign.center),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Dismiss"))
                    ],
                  ));
            }, child:const  Text("Make Payment"))
          ],
        ),
      ),
    );
  }
}
