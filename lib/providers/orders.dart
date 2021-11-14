import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shopping_cart/providers/cart.dart';
import 'package:http/http.dart' as http;

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
  dynamic authToken;

  OrdersP(this.authToken, this._orders);
  List<OrderItemP> _orders = [];
  List<OrderItemP> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://shop-app-f0a34-default-rtdb.firebaseio.com/orders.json?auth=$authToken');
    final response = await http.get(url);

    final List<OrderItemP> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItemP(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItemP(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItemP> cartProducts, double total) async {
    final url = Uri.parse(
        'https://shop-app-f0a34-default-rtdb.firebaseio.com/orders.json?auth=$authToken');
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': double.parse((total.toStringAsFixed(2))),
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price
                  })
              .toList()
        }));

    _orders.insert(
        0,
        OrderItemP(
            id: json.decode(response.body)['name'],
            amount: total,
            dateTime: timestamp,
            products: cartProducts));
    notifyListeners();
  }
}
