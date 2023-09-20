import 'package:book_a_bite_resto/modules/add_bite_bag/view.dart';
import 'package:book_a_bite_resto/modules/add_product/view.dart';
import 'package:book_a_bite_resto/modules/all_orders/view.dart';
import 'package:book_a_bite_resto/modules/all_products/view.dart';
import 'package:book_a_bite_resto/modules/help/view.dart';
import 'package:book_a_bite_resto/modules/home/view.dart';
import 'package:book_a_bite_resto/modules/login/view.dart';
import 'package:book_a_bite_resto/modules/order_detail/view.dart';
import 'package:book_a_bite_resto/modules/profile/view.dart';
import 'package:book_a_bite_resto/modules/sign_up/view_phone_login.dart';
import 'package:book_a_bite_resto/modules/sign_up/view.dart';
import 'package:book_a_bite_resto/modules/splash/view.dart';
import 'package:book_a_bite_resto/modules/useful_links/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'modules/forget_password.dart/view.dart';

routes() => [
      GetPage(name: "/splash", page: () => const SplashPage()),
      GetPage(name: "/login", page: () => const LoginPage()),
      GetPage(name: "/phoneLogin", page: () => const PhoneLoginView()),
      GetPage(name: "/signUp", page: () => const SignUpPage()),
      GetPage(name: "/home", page: () => const HomePage()),
      GetPage(name: "/addProduct", page: () => const AddProductPage()),
      GetPage(name: "/addBiteBag", page: () => const AddBiteBagPage()),
      GetPage(name: "/orderDetail", page: () => OrderDetailPage()),
      GetPage(name: "/allProducts", page: () => const AllProductsPage()),
      GetPage(name: "/allOrders", page: () => const AllOrdersPage()),
      GetPage(name: "/profile", page: () => const ProfilePage()),
      GetPage(name: "/help", page: () => const HelpPage()),
      GetPage(name: "/forgetPassword", page: () => const ForgotPassword()),
      GetPage(name: "/privacyPolicy", page: () => const PrivacyPolicyPage()),
    ];

class PageRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String phoneLogin = '/phoneLogin';
  static const String signUp = '/signUp';
  static const String home = '/home';
  static const String addProduct = '/addProduct';
  static const String addBiteBag = '/addBiteBag';
  static const String orderDetail = '/orderDetail';
  static const String allProducts = '/allProducts';
  static const String allOrders = '/allOrders';
  static const String profile = '/profile';
  static const String help = '/help';
  static const String forgetPassword = '/forgetPassword'; 
  static const String privacyPolicy = '/privacyPolicy';

  Map<String, WidgetBuilder> routes() {
    return {
      splash: (context) => const SplashPage(),
      login: (context) => const LoginPage(),
      phoneLogin: (context) => const PhoneLoginView(),
      signUp: (context) => const SignUpPage(),
      home: (context) => const HomePage(),
      addProduct: (context) => const AddProductPage(),
      addBiteBag: (context) => const AddBiteBagPage(),
      orderDetail: (context) => OrderDetailPage(),
      allProducts: (context) => const AllProductsPage(),
      allOrders: (context) => const AllOrdersPage(),
      profile: (context) => const ProfilePage(),
      help: (context) => const HelpPage(),
      forgetPassword: (context) => const ForgotPassword(),
      privacyPolicy: (context) => const PrivacyPolicyPage(),
    };
  }
}
