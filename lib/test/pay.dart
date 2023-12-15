import 'package:flutter/material.dart';
import 'package:reddit_clone/test/checkout/create_product.dart';
import 'package:reddit_clone/test/checkout/stripe_checkut_web.dart';

class PayScreeen extends StatefulWidget {
  const PayScreeen({super.key});

  @override
  State<PayScreeen> createState() => _PayScreeenState();
}

class _PayScreeenState extends State<PayScreeen> {
  Map<String, dynamic>? paymentIntent;
  //
  String pk =
      'pk_test_51ONFqBSCZLsjgGKy3oYIkhuq2BSRFNvrDOK66i3DlwmkKnSZgGy2seS81EHNofmhMzFN5kbVJ49Ow2GUumDFXyfK00N9pGzRkd';

  String sk =
      'sk_test_51ONFqBSCZLsjgGKyK0hK81TS6RJ86nBg64deW0Eg184lQS5OxKdjjSh9081dR85vHoxLqe2mabLvV0d4sYILIxyK007mnBhJUN';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  StripeService.createProduct(price: 30, productName: "Nike");
                },
                child: const Text("Create Product"),
              ),
              ElevatedButton(
                onPressed: () {
                  redirectToCheckout('price_1ONZFASCZLsjgGKy8GNhr5eb', 1);
                },
                child: const Text("Pay"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
