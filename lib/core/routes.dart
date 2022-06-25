// Defines all routes in the app

import 'package:flutter/widgets.dart';
import 'package:udanpani/presentation/login_screen.dart';
import 'package:udanpani/presentation/resposive/mobile_layout.dart';
import 'package:udanpani/presentation/resposive/responsive_screen.dart';
import 'package:udanpani/presentation/resposive/web_screen_layout.dart';
import 'package:udanpani/presentation/signup_screen.dart';

class Routes {
  static Map<String, WidgetBuilder> routes = {
    '/home': (context) => const ResponsiveLayout(
          webScreenLayout: WebScreenLayout(),
          mobileScreenLayout: MobileScreenLayout(),
        ),
    '/login': (context) => const LoginScreen(),
    '/signup': (context) => const SignUpScreen(),
  };
}
