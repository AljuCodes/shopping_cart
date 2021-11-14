import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/providers/auth.dart';
import 'package:shopping_cart/providers/cart.dart';
import 'package:shopping_cart/providers/orders.dart';
import 'package:shopping_cart/screens/ProductDetailScreen.dart';
import 'package:shopping_cart/screens/auth_screen.dart';
import 'package:shopping_cart/screens/cart_screen.dart';
import 'package:shopping_cart/screens/edit_product_screen.dart';
import 'package:shopping_cart/screens/orders_screen.dart';
import 'package:shopping_cart/screens/product_overview_screen.dart';
import 'package:shopping_cart/screens/user_product_screen.dart';
import './providers/products.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, previousProducts) => Products(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.items),
            create: (context) => Products("", "", []),
          ),
          ChangeNotifierProvider(
            create: (ctx) => CartP(),
          ),
          ChangeNotifierProxyProvider<Auth, OrdersP>(
            update: (ctx, auth, previousProducts) => OrdersP(auth.token,
                previousProducts == null ? [] : previousProducts.orders),
            create: (context) => OrdersP("", []),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
              fontFamily: 'Lato',
              primaryColor: Colors.purple,
              colorScheme: ColorScheme.fromSwatch()
                  .copyWith(secondary: Colors.deepOrange),
            ),
            home: auth.isAuth
                ? const ProductOverviewScreen()
                : const AuthScreen(),
            routes: {
              ProductOverviewScreen.routeName: (ctx) =>
                  const ProductOverviewScreen(),
              ProductDetailScreen.routeName: (ctx) =>
                  const ProductDetailScreen(),
              CartScreen.routeName: (ctx) => const CartScreen(),
              OrdersScreen.routeName: (ctx) => const OrdersScreen(),
              UserProductScreen.routeName: (ctx) => const UserProductScreen(),
              EditProductScreen.routeName: (ctx) => const EditProductScreen(),
            },
          ),
        ));
  }
}
