import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends StatelessWidget {
  void Function(int)? onTabChange;
  BottomNavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(40),
        child: GNav(
            onTabChange: (value) => onTabChange!(value),
            color: Colors.grey[400],
            mainAxisAlignment: MainAxisAlignment.center,
            activeColor: Colors.grey[800],
            tabBackgroundColor: Colors.grey.shade300,
            tabBorderRadius: 32,
            tabActiveBorder: Border.all(color: Colors.grey.shade600),
            gap: 10,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            tabs: const [
              GButton(
                icon: Icons.coffee,
                text: "Shop",
              ),
              GButton(
                icon: Icons.shopping_cart_sharp,
                text: "Cart",
              )
            ]));
  }
}
