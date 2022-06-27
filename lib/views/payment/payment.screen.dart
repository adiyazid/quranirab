import 'dart:convert';

import 'package:flutter/material.dart' hide Card;
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/models/payment.output.dart';
import 'package:quranirab/provider/user.provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/stripe.service.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _phone = TextEditingController();
  var custId = GetStorage().read('custID');
  PaymentOutput? _paymentOutput;

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> checkout(BuildContext context, String phone) async {
    try {
      var customer;
      var paymentIntent;
      var paymentMethod;
      if (custId == null) {
        customer = await StripeService.createCustomer(
            AppUser.instance.user!.displayName!,
            '+6' + phone,
            AppUser.instance.user!.email!,
            'QuranIrab User');
        setState(() {});
        custId = customer['id'];
        GetStorage().write('custID', customer['id']);
      } else {
        customer = await StripeService.getCustomer(custId);
      }

      paymentMethod = await StripeService.createCardPaymentMethod(
          number: '4111 1111 1111 1111',
          expMonth: '12',
          expYear: '2023',
          cvc: '111');
      setState(() {});
      var paymentMethodID = paymentMethod['id'];

      ///todo:for invoice purpose;
      // await StripeService.linkCustomerWithPaymentMethod(
      //     custId, paymentMethodID);

      var id = await GetStorage().read('intent');
      if (id == null) {
        paymentIntent = await StripeService.createPaymentIntent('5000', 'MYR');
        String newId = paymentIntent!['id'];
        GetStorage().write('intent', newId);
      } else {
        paymentIntent = await StripeService.getIntent(id);
      }
      showDialog(
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Customer ID: ' + customer!['id']),
              content: Text('Payment ID: ' + paymentIntent!['id']),
              actions: [
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      print(paymentIntent!['id'] + ' ' + paymentMethodID);
                      var paymentConfirm = await StripeService.confirmPayment(
                          paymentIntent!['id'], paymentMethodID);
                      setState(() {});
                      _paymentOutput =
                          paymentOutputFromJson(jsonEncode(paymentConfirm));
                      Navigator.pop(context);
                      if (_paymentOutput!.status == 'succeeded') {
                        Provider.of<AppUser>(context, listen: false)
                            .updateRole();
                      }
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Payment ${_paymentOutput!.status}')));
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  label: Text('Confirm Payment'),
                  icon: Icon(Icons.save),
                )
              ],
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
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Flutter Credit Card View'),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              obscureCardNumber: true,
              obscureCardCvv: true, onCreditCardWidgetChange: (CreditCardBrand ) {  },),
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CreditCardForm(cardNumber: cardNumber,
                        expiryDate: expiryDate,
                        cardHolderName: cardHolderName,
                        cvvCode: cvvCode,
                        onCreditCardModelChange: onCreditCardModelChange,
                        themeColor: Colors.blue,
                        formKey: formKey,
                        cardNumberDecoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Number',
                            hintText: 'xxxx xxxx xxxx xxxx'
                        ),
                        expiryDateDecoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Expired Date',
                            hintText: 'xx/xx'
                        ),
                        cvvCodeDecoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'CVV',
                            hintText: 'xxx'
                        ),
                        cardHolderDecoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Card Holder',
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            primary: Color(0xff1b447b)

                        ),
                        child: Container(
                          margin: EdgeInsets.all(8.0),
                          child: Text(
                            'validate',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'halter',
                              fontSize: 14,
                              package: 'flutter_credit_card',
                            ),
                          ),
                        ),
                        onPressed: (){
                          if(formKey.currentState!.validate()){
                            print('valid');
                          }
                          else{
                            print('inValid');
                          }
                        },)
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
  // {
  //   return Scaffold(
  //     appBar: AppBar(),
  //     body: Center(
  //       child: Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //           children: [
  //             if (custId == null)
  //               TextField(
  //                 controller: _phone,
  //                 decoration: InputDecoration(label: Text('Phone Number')),
  //               ),
  //             if (custId == null)
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: ElevatedButton(
  //                   onPressed: () async {
  //                     if (_phone.text.isNotEmpty) {
  //                       await checkout(context, _phone.text);
  //                     } else {
  //                       ScaffoldMessenger.of(context).showSnackBar(
  //                           SnackBar(content: Text('Insert Phone Number')));
  //                     }
  //                   },
  //                   child: const Text('Check Out'),
  //                 ),
  //               ),
  //             if (_paymentOutput != null)
  //               Flexible(
  //                 child: ListView(
  //                   children: [
  //                     ListTile(
  //                         title: Text('Payment ID'),
  //                         subtitle: Text(_paymentOutput!.id)),
  //                     ListTile(
  //                         title: Text('Payment Status'),
  //                         subtitle: Text(_paymentOutput!.status)),
  //                     ListTile(
  //                         title: Text('Payment Amount'),
  //                         subtitle: Text(_paymentOutput!.currency +
  //                             ' ' +
  //                             _paymentOutput!.amount.toString().substring(
  //                                 0,
  //                                 _paymentOutput!.amount.toString().length -
  //                                     2))),
  //                     ElevatedButton(
  //                         onPressed: () {
  //                           launchUrl(Uri.parse(
  //                               _paymentOutput!.charges.data.last.receiptUrl));
  //                         },
  //                         child: Text('Get Receipt')),
  //                   ],
  //                 ),
  //               )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  void onCreditCardModelChange(CreditCardModel creditCardModel){
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
