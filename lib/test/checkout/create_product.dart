import 'package:http/http.dart' as http;
import 'dart:convert';

class StripeService {
  static void createProduct(
      {required String productName, required int price}) async {
    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/products'),
      headers: {
        'Authorization':
            'Bearer sk_test_51ONFqBSCZLsjgGKyK0hK81TS6RJ86nBg64deW0Eg184lQS5OxKdjjSh9081dR85vHoxLqe2mabLvV0d4sYILIxyK007mnBhJUN',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'name=$productName',
    );

    if (response.statusCode == 200) {
      final productId = jsonDecode(response.body)['id'];
      print(productId);

      // Create a price for the product
      final priceResponse = await http.post(
        Uri.parse('https://api.stripe.com/v1/prices'),
        headers: {
          'Authorization':
              'Bearer sk_test_51ONFqBSCZLsjgGKyK0hK81TS6RJ86nBg64deW0Eg184lQS5OxKdjjSh9081dR85vHoxLqe2mabLvV0d4sYILIxyK007mnBhJUN',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        // ignore: prefer_interpolation_to_compose_strings
        body: 'unit_amount=${price * 100}&currency=inr&product=' +
            productId, // 2000 paise  =  rs20.00
      );

      if (priceResponse.statusCode == 200) {
        final priceId = jsonDecode(priceResponse.body)['id'];
        print(priceId);
      } else {
        // Handle error...
        print("error creating price");
      }
    } else {
      // Handle error...
      print("error creating product");
    }
  }
}
