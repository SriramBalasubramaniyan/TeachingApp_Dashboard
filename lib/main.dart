import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student_app/Utils/routing_generator.dart';
import 'Utils/appData.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  runApp(
    DevicePreview(
      builder: (context) => const MyApp(),
      enabled: true,
      tools: const [
        ...DevicePreview.defaultTools,
      ],
    ),
  );
  // runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            chipTheme: ChipThemeData(
                shape: const StadiumBorder(),
                elevation: 3,
                surfaceTintColor: Colors.white,
                color: WidgetStateProperty.all(Colors.white)),
            canvasColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppData.appPrimaryColor,
            ),
            primarySwatch: Colors.blue,
            appBarTheme: const AppBarTheme(
                backgroundColor: AppData.appPrimaryColor,
                foregroundColor: Colors.white)),
        onGenerateRoute: RouterGenerator.generateRoute,
        initialRoute: AppData.dashBoardScreen,
      );
    });
  }
}
