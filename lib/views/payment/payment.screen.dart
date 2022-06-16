import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:quranirab/provider/user.provider.dart';
import 'package:quranirab/views/payment/web.payment.dart';

import '../../services/stripe.service.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _phone = TextEditingController();

  Future<void> checkout(BuildContext context, String phone) async {
    try {
      var customer = await StripeService.createCustomer(
          AppUser.instance.user!.displayName!,
          '+6' + phone,
          AppUser.instance.user!.email!,
          'QuranIrab User');
      var paymentMethod = await StripeService.createCardPaymentMethod(
          number: '4111 1111 1111 1111',
          expMonth: '12',
          expYear: '2023',
          cvc: '111');
      // String description = 'QuranIrab';
      // var paymentIntent =
      //     await StripeService.createPaymentIntent('5000', 'MYR', description);
      // // print(json.encode(paymentIntent));
      // if (paymentIntent != null) {
      //   var confirmPayment = await Stripe.instance.confirmPayment(
      //     paymentIntent['client_secret'],
      //     PaymentMethodParams.cardFromMethodId(
      //       paymentMethodData: paymentMethod['id'],
      //     ),
      //   );
      // }
      showDialog(
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Customer ID' + customer!['id']),
            );
          },
          context: context);
    } catch (e) {
      showDialog(
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(e.toString()),
            );
          },
          context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _phone,
                decoration: InputDecoration(label: Text('Phone Number')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_phone.text.isNotEmpty) {
                      await checkout(context, _phone.text);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Insert Phone Number')));
                    }
                  },
                  child: const Text('Create customer'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewXPage()));
                  },
                  child: const Text('Checkout Using WebView'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      var event = await StripeService.getEvent();
                    } catch (e) {}
                    await StripeService.launchPaymentUrl(
                        'https://buy.stripe.com/test_14kaGT1NgdAf4lW4gg');
                  },
                  child: const Text('Checkout Using Url Launcher'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
