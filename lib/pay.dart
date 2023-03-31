import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';

import 'button.dart';

class PaystackCardMethod extends StatefulWidget {
  const PaystackCardMethod({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PaystackCardMethodState createState() => _PaystackCardMethodState();
}

class _PaystackCardMethodState extends State<PaystackCardMethod> {
  String publicKeyTest =
      'pk_test_275daca48185414ab86aa2f485fc635b55d93ea0'; //pass in the public test key here
  final plugin = PaystackPlugin();
  var balance = 0;
  var amt = 100;
  @override
  void initState() {
    plugin.initialize(publicKey: publicKeyTest);
    super.initState();
  }

  void _showMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  String _getReference() {
    var platform = (Platform.isIOS) ? 'iOS' : 'Android';
    final thisDate = DateTime.now().millisecondsSinceEpoch;
    return 'ChargedFrom${platform}_$thisDate';
  }

  chargeCard() async {
    var charge = Charge()
      ..amount = amt *
          100 //the money should be in kobo hence the need to multiply the value by 100
      ..reference = _getReference()
      ..putCustomField('custom_id',
          '846gey6w') //to pass extra parameters to be retrieved on the response from Paystack
      ..email = 'ndubuisiaso@gmail.com';
    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card,
      charge: charge,
    );
    if (response.status == true) {
      _showMessage('Payment was successful!!!');
      updateWallet();
    } else {
      _showMessage('Payment Failed!!!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Paystack",
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Wallet Balance\n",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            "NGN $balance.00",
            style: const TextStyle(fontSize: 36),
          ),
          Container(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  padding: const EdgeInsets.all(15),
                  child: PayButton(
                    callback: () => chargeCard(),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  void updateWallet() {
    setState(() {
      balance += amt;
    });
  }
}
