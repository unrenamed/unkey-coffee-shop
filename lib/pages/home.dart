import 'package:flutter/material.dart';
import 'package:unkey_coffee_shop/components/bottom_nav_bar.dart';
import 'package:unkey_coffee_shop/const.dart';

import 'cart.dart';
import 'shop.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIdx = 0;

  void navigateBottomBar(int idx) {
    setState(() {
      _selectedIdx = idx;
    });
  }

  final List<Widget> _pages = [const ShopPage(), const CartPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      bottomNavigationBar:
          BottomNavBar(onTabChange: (idx) => navigateBottomBar(idx)),
      body: _pages[_selectedIdx],
    );
  }
}
