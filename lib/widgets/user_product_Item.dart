// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/providers/products.dart';
import 'package:shopping_cart/screens/edit_product_screen.dart';

class UserProductItem extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String id;
  const UserProductItem(this.id, this.title, this.imageUrl, {Key? key})
      : super(key: key);

  @override
  State<UserProductItem> createState() => _UserProductItemState();
}

class _UserProductItemState extends State<UserProductItem> {
  @override
  Widget build(BuildContext context) {
    final scaffoldmessenger = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.imageUrl),
      ),
      title: Text(widget.title),
      // ignore: sized_box_for_whitespace
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName,
                    arguments: widget.id);
              },
              icon: const Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(widget.id);
                } catch (error) {
                  scaffoldmessenger.showSnackBar(const SnackBar(
                    content: Text(
                      'Deleting failed !',
                      textAlign: TextAlign.center,
                    ),
                  ));
                }
              },
              icon: const Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
