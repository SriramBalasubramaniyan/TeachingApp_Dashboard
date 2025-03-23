import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_app/Utils/appData.dart';
import 'package:student_app/providers/dashboard_provider.dart';
import 'package:student_app/views/dashboard_view.dart';

class RouterGenerator {
  static String currentScreen = AppData.dashBoardScreen;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final name = settings.name;
    currentScreen = name!;

    switch (name) {
      case AppData.dashBoardScreen:
        return MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (context) => DashBoardProvider(),
                  child: const DashboardView(),
                ));

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
        builder: (context) => const Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: Text("Navigation Error")),
                ],
              ),
            ));
  }
}

MaterialPageRoute<dynamic> materialPageRoute(target) =>
    MaterialPageRoute(builder: (context) => target);
