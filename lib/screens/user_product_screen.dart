import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shopping_cart/screens/edit_product_screen.dart';
import 'package:shopping_cart/widgets/app_drawer.dart';
import 'package:shopping_cart/widgets/user_product_Item.dart';

import '../providers/products.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/UserProductScreen';

  const UserProductScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Proudcts'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProductScreen.routeName, arguments: 'i');
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
        child: ListView.builder(
          itemBuilder: (_, i) => Column(
            children: [
              UserProductItem(
                _productsData.items[i].id,
                _productsData.items[i].title,
                _productsData.items[i].imageUrl,
              ),
              const Divider()
            ],
          ),
          itemCount: _productsData.items.length,
        ),
      ),
    );
  }
}
