import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/providers/orders.dart';
import 'package:shopping_cart/widgets/app_drawer.dart';
import 'package:shopping_cart/widgets/orderItem.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  dynamic _ordersFuture = null;
  Future _obtainOrdersFuture() {
    return Provider.of<OrdersP>(context, listen: false).fetchAndSetOrders();
  }

  // var _isLoading = false;
  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    // final orderData = Provider.of<OrdersP>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Order'),
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
            future: _ordersFuture,
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (dataSnapshot.error != null) {
                return const Center(child: Text('An error occured!'));
              } else {
                return Consumer<OrdersP>(
                  builder: (ctx, orderData, child) => ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                  ),
                );
              }
            })
        // Center(
        //         child: CircularProgressIndicator(),
        //       )
        //      ListView.builder(
        //         itemCount: orderData.orders.length,
        //         itemBuilder: (context, index) =>
        //             OrderItem(orderData.orders[index])),
        );
  }
}
