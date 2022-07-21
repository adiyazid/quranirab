import 'dart:convert';

import 'package:http/http.dart' as http;

import '../.env.dart';

class StripeService {
  static String apiURL = 'https://api.stripe.com/v1';
  static String paymentIntentURL = '$apiURL/payment_intents';
  static String paymentMethodURL = '$apiURL/payment_methods';
  static String customer = '$apiURL/customers';
  static String secret = StripeSecretKey; //your secret from stripe dashboard
  static Map<String, String> headers = {
    'Authorization': 'Bearer $secret',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  static Future<Map<String, dynamic>> createCardPaymentMethod(
      {required String number,
      required String expMonth,
      required String expYear,
      required String cvc}) async {
    try {
      Map<String, String> body = {
        'type': 'card',
        'card[number]': number,
        'card[exp_month]': expMonth,
        'card[exp_year]': expYear,
        'card[cvc]': cvc,
      };
      var response = await http.post(Uri.parse(paymentMethodURL),
          body: body, headers: headers);
      Map<String, dynamic> data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw ('Error creating payment method. ${data['error']['message']}');
      }

      return data;
    } catch (error) {
      // print('Error occured : ${error.toString()}');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        // amount charged will be specified when the method is called
        'description': 'buy premium QuranIrab',
        'currency': currency,
        // the currency
        'payment_method_types[]': 'card',
      };

      var response = await http.post(Uri.parse(paymentIntentURL), //api url
          body: body, //request body
          headers: headers //headers of the request specified in the base class
          );
      return jsonDecode(response.body); //decode the response to json
    } catch (error) {
      print('Error occured : ${error.toString()}');
    }
    return null;
  }

  static Future<Map<String, dynamic>?> createCustomer(
      String name, String phone, String email, String description) async {
    try {
      Map<String, dynamic> body = {
        'name':
            name, // amount charged will be specified when the method is called
        'phone': phone, // the currency
        'email': email,
        'description': description,
      };

      var response = await http.post(Uri.parse(customer), //api url
          body: body, //request body
          headers: headers //headers of the request specified in the base class
          );
      return jsonDecode(response.body); //decode the response to json
    } catch (error) {
      print('Error occured : ${error.toString()}');
    }
    return null;
  }

  static getIntent(String id) async {
    try {
      var response = await http.get(
          Uri.parse('$paymentIntentURL/$id'), //api url
          headers: headers //headers of the request specified in the base class
          );

      return jsonDecode(response.body); //decode the response to json
    } catch (error) {
      print('Error occured : ${error.toString()}');
    }
    return null;
  }

  static getCustomer(custId) async {
    try {
      var response = await http.get(Uri.parse('$customer/$custId'), //api url
          headers: headers //headers of the request specified in the base class
          );
      return jsonDecode(response.body); //decode the response to json
    } catch (error) {
      print('Error occured : ${error.toString()}');
    }
    return null;
  }

  static confirmPayment(paymentId, paymentMethodId) async {
    try {
      Map<String, dynamic> body = {"payment_method": '$paymentMethodId'};

      var response = await http.post(
          Uri.parse(paymentIntentURL + '/' + paymentId + '/confirm'), //api url
          body: body, //request body
          headers: headers //headers of the request specified in the base class
          );
      return jsonDecode(response.body); //decode the response to json
    } catch (error) {
      print('Error occured : ${error.toString()}');
    }
    return null;
  }

  static linkCustomerWithPaymentMethod(custId, paymentMethod) async {
    try {
      Map<String, dynamic> body = {"customer": custId};

      var response = await http.post(
          Uri.parse(paymentMethodURL + '/' + paymentMethod + '/attach'),
          //api url
          body: body, //request body
          headers: headers //headers of the request specified in the base class
          );
      return jsonDecode(response.body); //decode the response to json
    } catch (error) {
      print('Error occured : ${error.toString()}');
    }
    return null;
  }
}
