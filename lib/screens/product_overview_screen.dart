import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/providers/cart.dart';
import 'package:shopping_cart/screens/cart_screen.dart';
import 'package:shopping_cart/widgets/app_drawer.dart';
import 'package:shopping_cart/widgets/badge.dart';

import 'package:shopping_cart/widgets/products_grid.dart';

enum filterOptions { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Myshop"),
        actions: [
          PopupMenuButton(
              onSelected: (filterOptions selecetedValue) {
                setState(() {
                  if (selecetedValue == filterOptions.Favorites) {
                    _showOnlyFavorites = true;
                  } else {
                    _showOnlyFavorites = false;
                  }
                });
              },
              itemBuilder: (_) => [
                    const PopupMenuItem(
                      child: Text('Only Favorite'),
                      value: filterOptions.Favorites,
                    ),
                    const PopupMenuItem(
                      child: const Text('Show All'),
                      value: filterOptions.All,
                    )
                  ]),
          Consumer<CartP>(
            builder: (_, cart, ch) => Badge(
              child: ch as Widget,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_bag),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: ProductGrid(_showOnlyFavorites),
    );
  }
}
