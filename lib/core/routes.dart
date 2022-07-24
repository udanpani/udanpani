// Defines all routes in the app

import 'package:flutter/widgets.dart';
import 'package:udanpani/presentation/screens/add_new_job_screen.dart';
import 'package:udanpani/presentation/screens/auth_pages/login_screen.dart';
import 'package:udanpani/presentation/resposive/mobile_layout.dart';
import 'package:udanpani/presentation/resposive/responsive_screen.dart';
import 'package:udanpani/presentation/resposive/web_screen_layout.dart';
import 'package:udanpani/presentation/screens/auth_pages/signup_screen.dart';
import 'package:udanpani/presentation/screens/job_details_screen.dart';

class Routes {
  static Map<String, WidgetBuilder> routes = {
    '/home': (context) => const ResponsiveLayout(
          webScreenLayout: WebScreenLayout(),
          mobileScreenLayout: MobileScreenLayout(),
        ),
    '/login': (context) => const LoginScreen(),
    '/signup': (context) => const SignUpScreen(),
    '/upload': (context) => const AddNewJobScreen(),
  };
}
