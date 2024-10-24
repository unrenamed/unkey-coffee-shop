import 'package:flutter/material.dart';

import '../models/drink.dart';

class IconWithCallback {
  final Widget icon;
  final void Function()? onPressed;

  IconWithCallback({required this.icon, this.onPressed});
}

class DrinkTile extends StatelessWidget {
  final Drink drink;
  final List<IconWithCallback> icons;
  final int? discount;

  const DrinkTile({
    super.key,
    required this.drink,
    required this.icons,
    this.discount,
  });

  @override
  Widget build(BuildContext context) {
    double discountedPrice =
        discount != null ? drink.price * (1 - discount! / 100) : drink.price;

    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: ListTile(
        title: Row(
          children: [
            Text(
              drink.name,
              style: const TextStyle(fontWeight: FontWeight.w300),
            ),
            if (discount != null)
              Container(
                margin: const EdgeInsets.only(left: 10),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.brown[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$discount% off',
                  style: const TextStyle(
                      color: Colors.brown,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
              ),
          ],
        ),
        subtitle: Row(
          children: [
            if (discount != null) ...[
              Text(
                '\$${drink.price}',
                style: TextStyle(
                  color: Colors.red[400],
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.lineThrough,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '\$${discountedPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.green[400],
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ] else
              Text(
                '\$${drink.price}',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
          ],
        ),
        leading: Image.asset(drink.imagePath),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: icons
              .map(
                (iconWithCallback) => IconButton(
                  onPressed: iconWithCallback.onPressed,
                  icon: iconWithCallback.icon,
                  iconSize: 23,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
