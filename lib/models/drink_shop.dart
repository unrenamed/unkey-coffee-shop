import 'package:flutter/material.dart';
import 'package:unkey_coffee_shop/models/coupon.dart';

import 'drink.dart';

class DrinkShop with ChangeNotifier {
  final List<Drink> _drinksCollection = [
    Drink(
        name: "Bubble Tea",
        price: 5.50,
        imagePath: "lib/images/bubble-tea.png"),
    Drink(
        name: "Cappuccino",
        price: 4.75,
        imagePath: "lib/images/cappuccino.png"),
    Drink(name: "Espresso", price: 3.00, imagePath: "lib/images/espresso.png"),
    Drink(
        name: "Flat White",
        price: 4.25,
        imagePath: "lib/images/flat-white.png"),
    Drink(
        name: "Iced Latte",
        price: 4.50,
        imagePath: "lib/images/iced-latte.png"),
    Drink(name: "Mocha", price: 5.00, imagePath: "lib/images/mocha.png"),
    Drink(name: "Hot Tea", price: 3.50, imagePath: "lib/images/tea.png"),
  ];

  List<Drink> _userCart = [];
  Coupon? _appliedCoupon; // Track the applied coupon

  // Getter for the drinks collection
  List<Drink> get drinkShop => _drinksCollection;

  // Getter for the user's cart
  List<Drink> get userCart => _userCart;

  // Getter for the applied coupon
  Coupon? get appliedCoupon => _appliedCoupon;

  // Add a drink to the cart
  void addDrinkToCart(Drink drink) {
    _userCart.add(drink);
    notifyListeners();
  }

  // Remove a drink from the cart
  void removeDrinkFromCart(Drink drink) {
    _userCart.remove(drink);
    notifyListeners();
  }

  // Empty the user cart
  void emptyCart() {
    _userCart = [];
    notifyListeners(); // Notify listeners of the change
  }

  // Set the applied coupon
  void applyCoupon(Coupon coupon) {
    _appliedCoupon = coupon;
    notifyListeners(); // Notify listeners of the change
  }

  // Clear the applied coupon
  void clearCoupon() {
    _appliedCoupon = null;
    notifyListeners(); // Notify listeners of the change
  }

  // Function to calculate the total price including the discount if any
  double calculateTotalPrice() {
    double total = 0.0;
    for (Drink drink in _userCart) {
      double price = drink.price;
      // Apply the coupon discount if applicable
      if (_appliedCoupon != null && drink.name == _appliedCoupon!.drinkName) {
        price -= price * (_appliedCoupon!.discountPercentage / 100);
      }
      total += price;
    }
    return total;
  }
}
