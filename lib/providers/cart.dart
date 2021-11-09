import 'package:flutter/cupertino.dart';

class CartItemP {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItemP(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.price});
}

class CartP with ChangeNotifier {
  Map<String, CartItemP> _items = {};

  Map<String, CartItemP> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, carItem) {
      total += carItem.price * carItem.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartItem) => CartItemP(
              id: existingCartItem.id,
              title: existingCartItem.title,
              quantity: existingCartItem.quantity + 1,
              price: existingCartItem.price));
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItemP(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String id) {
    if (!_items.containsKey(id)) {
      return;
    }
    var __quantity = _items[id]!.quantity;
    if (__quantity > 1) {
      _items.update(
          id,
          (existingCartItem) => CartItemP(
              id: existingCartItem.id,
              title: existingCartItem.title,
              quantity: existingCartItem.quantity - 1,
              price: existingCartItem.price));
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }
}
