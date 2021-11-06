import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/providers/cart.dart';
import 'package:shopping_cart/providers/orders.dart';
import 'package:shopping_cart/screens/orders_screen.dart';
import 'package:shopping_cart/widgets/app_drawer.dart';
import 'package:shopping_cart/widgets/cartItem.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartP>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  const Text('Total'),
                  const Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              ?.color),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FlatButton(
                    child: const Text('Order Now'),
                    onPressed: () {
                      Navigator.of(context).pushNamed(OrdersScreen.routeName);

                      Provider.of<OrdersP>(context, listen: false).addOrder(
                          cart.items.values.toList(), cart.totalAmount);

                      cart.clear();
                      // Navigator.pop(context);
                    },
                    textColor: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, i) => CartItem(
              cart.items.values.toList()[i].id,
              cart.items.values.toList()[i].price,
              cart.items.keys.toList()[i],
              cart.items.values.toList()[i].quantity,
              cart.items.values.toList()[i].title,
            ),
            itemCount: cart.items.length,
          ))
        ],
      ),
    );
  }
}
