import 'package:flutter/material.dart';
import 'package:shop_app/helpers/custom_route.dart';
import 'package:shop_app/screens/splash_screen.dart';
import './providers/auth.dart';
import './screens/auth_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/user_product_screen.dart';
import './screens/orders_screen.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './providers/cart.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/products_provider.dart';
import 'package:provider/provider.dart';

void main(){
  runApp(MyApp()) ;
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return  MultiProvider(providers:[
        ChangeNotifierProvider(create: (ctx) => Auth()),
       ChangeNotifierProxyProvider<Auth,Products>(
           create: (ctx) => Products('','',[]),
          update:  (ctx, auth, previousProduct) => Products(auth.token,
            auth.userId,
            previousProduct == null ? [] : previousProduct.items,),

        ),

      ChangeNotifierProvider(create: (ctx) => Cart()),
      ChangeNotifierProxyProvider<Auth,Orders>(
        create: (ctx) => Orders('','',[]),
      update: (ctx, auth, previousOrders) => Orders(auth.token,
          auth.userId,
          previousOrders == null ? [] : previousOrders.orders),),
    ],
      child: Consumer<Auth>( builder : (ctx, auth, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.red,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CustomPageTransitionBuilder(),
            TargetPlatform.iOS: CustomPageTransitionBuilder(),
          },
          ),
        ),
        home:   auth.isAuth ? ProductsOverviewScreen() : FutureBuilder(
            future: auth.tryAutoLogin(),
            builder: (ctx, authResultSnapShot) =>
        authResultSnapShot.connectionState ==
            ConnectionState.waiting ? SplashScreen() : AuthScreen(),
        ),

        routes: {
          ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
          ProductDetail.routeName : (ctx) => ProductDetail(),
          CartScreen.routeName : (ctx) => CartScreen(),
          OrderScreen.routeName : (ctx) => OrderScreen(),
          UserProductScreen.routeName : (ctx) => UserProductScreen(),
          EditProductScreen.routeName : (ctx) => EditProductScreen(),
        },
      ),)


    );
  }
}




