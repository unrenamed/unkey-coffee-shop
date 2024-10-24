import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:unkey_coffee_shop/components/drink_tile.dart';
import 'package:unkey_coffee_shop/models/drink_shop.dart';
import 'package:unkey_coffee_shop/services/coupon.dart';

import '../models/drink.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  int? _loadingIndex;

  void addToCart(Drink drink) {
    Provider.of<DrinkShop>(context, listen: false).addDrinkToCart(drink);

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => AlertDialog(
        backgroundColor: Colors.brown,
        content: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.only(top: 8),
          child: const Text(
            "Drink added to cart!",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  void generateCouponCode(Drink drink, int index) async {
    setState(() {
      _loadingIndex = index;
    });

    final couponCode = await generateRandCouponCode(drink.name);

    couponCode.match(
      () {
        setState(() {
          _loadingIndex = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Something went wrong.")),
        );
      },
      (code) {
        setState(() {
          _loadingIndex = null;
        });
        showDialog(
          context: context,
          barrierColor: Colors.black.withOpacity(0.7),
          builder: (context) => AlertDialog(
            backgroundColor: Colors.brown,
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Here is your coupon code for ${drink.name}:",
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    code,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: code));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Coupon code copied!")),
                        );
                        Navigator.of(context).pop();
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.copy,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Copy',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DrinkShop>(
      builder: (context, value, child) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              const Text(
                "How would you like your drink?",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 25),
              Expanded(
                child: ListView.builder(
                  itemCount: value.drinkShop.length,
                  itemBuilder: (context, index) {
                    Drink eachDrink = value.drinkShop[index];

                    return DrinkTile(
                      drink: eachDrink,
                      icons: [
                        IconWithCallback(
                          icon: _loadingIndex == index
                              ? const SizedBox(
                                  width: 15,
                                  height: 15,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.grey),
                                  ),
                                )
                              : Icon(Icons.discount_outlined,
                                  color: Colors.grey[600]),
                          onPressed: _loadingIndex == index
                              ? null
                              : () => generateCouponCode(eachDrink, index),
                        ),
                        IconWithCallback(
                          icon: Icon(Icons.add, color: Colors.grey[600]),
                          onPressed: () => addToCart(eachDrink),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
