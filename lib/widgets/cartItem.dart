import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final double price;
  final int quantity;
  final String title;
  final String productId;
  const CartItem(this.id, this.price, this.productId, this.quantity, this.title,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<CartP>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(child: Text('\$$price')),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${(price * quantity).toStringAsFixed(2)}'),
            trailing: Text('$quantity X'),
          ),
        ),
      ),
    );
  }
}
