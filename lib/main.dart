import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:myshop/providers/providers.dart';
import 'package:myshop/ui/pages/pages.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => Auth()),
          ChangeNotifierProvider(create: (ctx) => Cart()),
          // ChangeNotifierProvider(create: (ctx) => ThemeProvider()),
          ChangeNotifierProxyProvider<Auth, Order>(
              create: (ctx) => Order(null, null, []),
              update: (ctx, auth, prevOrder) => Order(auth.token, auth.userId,
                  prevOrder == null ? [] : prevOrder.orders)),
          ChangeNotifierProxyProvider<Auth, ProductProvider>(
              create: (ctx) => ProductProvider(
                    null,
                    null,
                    [],
                  ),
              update: (ctx, auth, prevProduct) => ProductProvider(auth.token,
                  auth.userId, prevProduct == null ? [] : prevProduct.product)),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => GetMaterialApp(
            debugShowCheckedModeBanner: true,
            theme: ThemeData(
                primarySwatch: Colors.purple, accentColor: Colors.deepOrange),
            home: Wrapper(),
            initialRoute: '/',
            routes: {
              ProductDetailsPage.routeName: (context) =>
                  ProductDetailsPage(null),
              CartPage.routeName: (context) => CartPage(),
              OrderPages.routeName: (context) => OrderPages(),
              UserProductPage.routeName: (context) => UserProductPage(),
              EditProductPage.routeName: (context) => EditProductPage(),
            },
          ),
        ));
  }
}
