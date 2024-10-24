import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

import '../models/coupon.dart';
import '../utils.dart';

const String unkeyApiUrl = 'https://api.unkey.dev/v1';

Future<Option<Coupon>> retrieveCouponByCode(String couponCode) async {
  final response = await http.post(
    Uri.parse('$unkeyApiUrl/keys.verifyKey'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'apiId': dotenv.env['UNKEY_API_ID'], 'key': couponCode}),
  );

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    final isValid = jsonResponse['valid'] == true;
    if (!isValid) return const None();

    // 4NHdLybc7gvCR

    final drinkName = jsonResponse['meta']['drink'];
    final discountPercentage = jsonResponse['meta']['discount'];
    final coupon = Coupon(
        code: couponCode,
        drinkName: drinkName,
        discountPercentage: discountPercentage);
    return Some(coupon);
  } else {
    return const None();
  }
}

Future<Option<String>> generateRandCouponCode(String drinkName) async {
  final response = await http.post(
    Uri.parse('$unkeyApiUrl/keys.createKey'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${dotenv.env['UNKEY_ROOT_KEY']}'
    },
    body: jsonEncode({
      'apiId': dotenv.env['UNKEY_API_ID'],
      "ownerId": "anonymous",
      "meta": {"drink": drinkName, "discount": generateRandomTenToHundred()},
      "expires": durationToTimestamp(dotenv.env['COUPON_DURATION']!),
      "remaining": 1,
    }),
  );

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    final error = jsonResponse['error'];
    final couponCode = jsonResponse['key'];
    if (error != null || couponCode == null) return const None();
    return Some(couponCode);
  } else {
    return const None();
  }
}
