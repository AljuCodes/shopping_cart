import 'package:flutter/cupertino.dart';
import 'package:shopping_cart/providers/cart.dart';

class OrderItemP {
  final String id;
  final double amount;
  final List<CartItemP> products;
  final DateTime dateTime;
  OrderItemP(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class OrdersP with ChangeNotifier {
  List<OrderItemP> _orders = [];
  List<OrderItemP> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItemP> cartProducts, double total) {
    _orders.insert(
        0,
        OrderItemP(
            id: DateTime.now().toString(),
            amount: total,
            dateTime: DateTime.now(),
            products: cartProducts));
    notifyListeners();
  }
}
