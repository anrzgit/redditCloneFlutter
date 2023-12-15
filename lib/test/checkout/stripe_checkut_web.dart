@JS()
library stripe;

import 'package:js/js.dart';

String pk =
    'pk_test_51ONFqBSCZLsjgGKy3oYIkhuq2BSRFNvrDOK66i3DlwmkKnSZgGy2seS81EHNofmhMzFN5kbVJ49Ow2GUumDFXyfK00N9pGzRkd';
String sk =
    'sk_test_51ONFqBSCZLsjgGKyK0hK81TS6RJ86nBg64deW0Eg184lQS5OxKdjjSh9081dR85vHoxLqe2mabLvV0d4sYILIxyK007mnBhJUN';

void redirectToCheckout(String priceId, int quantity) {
  Stripe(pk).redirectToCheckout(CheckoutOptions(
    lineItems: [
      LineItem(
        price: priceId,
        quantity: quantity,
      )
    ],
    mode: 'payment',
    successUrl: 'http://localhost:8080/#/success',
    cancelUrl: 'http://localhost:8080/#/cancel',
  ));
}

@JS()
class Stripe {
  external Stripe(String key);

  external redirectToCheckout(CheckoutOptions checkoutOptions);
}

@JS()
@anonymous
class CheckoutOptions {
  external List<LineItem> get lineItems;

  external String get mode;

  external String get successUrl;

  external String get cancelUrl;

  external String get sessionId;

  external factory CheckoutOptions({
    List<LineItem> lineItems,
    String mode,
    String successUrl,
    String cancelUrl,
    String sessionId,
  });
}

@JS()
@anonymous
class LineItem {
  external String get price;

  external int get quantity;

  external factory LineItem({String price, int quantity});
}
