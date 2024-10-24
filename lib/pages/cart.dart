import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unkey_coffee_shop/pages/home.dart';
import 'package:unkey_coffee_shop/services/coupon.dart';

import '../components/drink_tile.dart';
import '../models/drink.dart';
import '../models/drink_shop.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isCouponInputVisible = false; // Track if coupon input is visible
  final TextEditingController _couponController = TextEditingController();

  void removeFromCart(Drink drink) {
    Provider.of<DrinkShop>(context, listen: false).removeDrinkFromCart(drink);
  }

  void submitPayment() {
    /**
     * Handle payment submission logic here
     */

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content:
              Text("Thank you for your order. Your drinks are on their way!")),
    );

    Provider.of<DrinkShop>(context, listen: false).clearCoupon();
    Provider.of<DrinkShop>(context, listen: false).emptyCart();
  }

  void applyCoupon() async {
    String couponCode = _couponController.text;
    final coupon = await retrieveCouponByCode(couponCode);

    coupon.match(
        () => {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Invalid coupon code")),
              )
            },
        (value) => {
              // Set the coupon in the DrinkShop provider state
              Provider.of<DrinkShop>(context, listen: false).applyCoupon(value),
              setState(() {
                _isCouponInputVisible = false;
              }),
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Coupon applied: ${value.code}")),
              )
            });
  }

  void cancelCoupon() {
    // Clear the coupon from the DrinkShop provider state
    Provider.of<DrinkShop>(context, listen: false).clearCoupon();
    setState(() {
      _isCouponInputVisible = false;
      _couponController.clear(); // Clear the input field
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DrinkShop>(
      builder: (context, value, child) {
        // Use the total price calculated by DrinkShop
        double totalPrice = value.calculateTotalPrice();
        final appliedCoupon = value.appliedCoupon;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                const Text(
                  "Your Cart",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 25,
                ),
                if (value.userCart.isEmpty) ...[
                  Column(
                    children: [
                      const Text(
                        "Your cart is waiting for you! Add some drinks to get started.",
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.brown,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              "Browse Drinks",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ] else ...[
                  Expanded(
                    child: ListView.builder(
                      itemCount: value.userCart.length,
                      itemBuilder: (context, index) {
                        Drink eachDrink = value.userCart[index];

                        final discount =
                            appliedCoupon?.drinkName == eachDrink.name
                                ? appliedCoupon?.discountPercentage
                                : null;

                        return DrinkTile(
                          drink: eachDrink,
                          icons: [
                            IconWithCallback(
                                icon:
                                    Icon(Icons.delete, color: Colors.grey[600]),
                                onPressed: () => removeFromCart(eachDrink))
                          ],
                          discount: discount,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_isCouponInputVisible)
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _couponController,
                            decoration: InputDecoration(
                              hintText: "Enter coupon code",
                              hintStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.black45, width: 2),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.check,
                            color: Colors.brown,
                          ),
                          onPressed: applyCoupon,
                        ),
                        IconButton(
                          icon: Icon(Icons.cancel, color: Colors.grey[600]),
                          onPressed: cancelCoupon,
                        ),
                      ],
                    )
                  else if (appliedCoupon == null)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isCouponInputVisible = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.black54,
                            width: 1.0,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Use coupon",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Coupon: ${appliedCoupon.code}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: submitPayment,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.brown,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "Pay Now - \$$totalPrice",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
