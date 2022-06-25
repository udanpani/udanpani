import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:udanpani/core/constants.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    Key? key,
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  }) : super(key: key);

  final webScreenLayout;
  final mobileScreenLayout;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) {
        if (constraints.maxWidth > webScreenWidth) {
          return webScreenLayout;
        }
        return mobileScreenLayout;
      }),
    );
  }
}
