import 'dart:convert';

import 'package:http/http.dart' as http;

class PayMobService {
  final String apiKey;
  final String integrationId;
  final String redirectUrl;

  PayMobService({
    required this.apiKey,
    required this.integrationId,
    required this.redirectUrl,
  });

  Future<String> createPayment(String amountCents) async {
    try {
      final authToken = await _getAuthToken();
      final orderId = await _createOrder(authToken, amountCents);
      return await _getPaymentToken(authToken, orderId, amountCents);
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  Future<String> _getAuthToken() async {
    final url = 'https://accept.paymobsolutions.com/api/auth/tokens';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'api_key': apiKey}),
    );

    if (response.statusCode == 201) {
      final body = jsonDecode(response.body);
      return body['token'];
    } else {
      throw Exception('Failed to get auth token: ${response.statusCode}');
    }
  }

  Future<String> _createOrder(String authToken, String amountCents) async {
    final url = 'https://accept.paymobsolutions.com/api/ecommerce/orders';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode({
        'auth_token': authToken,
        'delivery_needed': 'false',
        'amount_cents': amountCents,
        'currency': 'EGP',
        'items': [],
      }),
    );

    if (response.statusCode == 201) {
      final body = jsonDecode(response.body);
      return body['id'].toString();
    } else {
      throw Exception(
          'Failed to create order: ${response.statusCode} ${response.body}');
    }
  }

  Future<String> _getPaymentToken(
      String authToken, String orderId, String amountCents) async {
    final url =
        'https://accept.paymobsolutions.com/api/acceptance/payment_keys';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode({
        'auth_token': authToken,
        'amount_cents': amountCents,
        'expiration': 3600,
        'order_id': orderId,
        'billing_data': {
          'apartment': 'NA',
          'email': 'email@example.com',
          'floor': 'NA',
          'first_name': 'First',
          'street': 'NA',
          'building': 'NA',
          'phone_number': '+201000000000',
          'shipping_method': 'NA',
          'postal_code': 'NA',
          'city': 'NA',
          'country': 'NA',
          'last_name': 'Last',
          'state': 'NA',
        },
        'currency': 'EGP',
        'integration_id': integrationId,
        'lock_order_when_paid': 'false',
      }),
    );

    if (response.statusCode == 201) {
      final body = jsonDecode(response.body);
      return body['token'];
    } else {
      throw Exception(
          'Failed to get payment token: ${response.statusCode} ${response.body}');
    }
  }
}
