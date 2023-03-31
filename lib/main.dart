import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: PaystackCardMethod());
  }
}
class PaystackCardMethod extends StatefulWidget {
  @override
  _PaystackCardMethodState createState() => _PaystackCardMethodState();
}
class _PaystackCardMethodState extends State<PaystackCardMethod> {
  String publicKeyTest =
      'pk_test_275daca48185414ab86aa2f485fc635b55d93ea0'; //pass in the public test key here
  final plugin = PaystackPlugin();
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
      ..amount = 300 *
          100 //the money should be in kobo hence the need to multiply the value by 100
      ..reference = _getReference()
      ..accessCode = '12345'
      ..putCustomField('custom_id',
          '846gey6w') //to pass extra parameters to be retrieved on the response from Paystack
      ..email = 'ndubuisiaso@gmail.com';
CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.selectable,
      charge: charge,
    );
if (response.status == true) {
      _showMessage('Payment was successful!!!');
    } else {
      _showMessage('Payment Failed!!!');
    }
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Paystack Integration",
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              padding: const EdgeInsets.all(15),
              child: PayButton(         
                   callback: () => chargeCard(),
              ),
            ),
          )),
    );
  }
}

class PayButton extends StatelessWidget {
  const PayButton({required this.callback});

  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
        child: ButtonTheme(
          minWidth: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(10),
              primary: Colors.blueAccent,
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
            ),
            onPressed: callback,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Pay Now!!!',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}