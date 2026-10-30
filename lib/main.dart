import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/settings_provider.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return MaterialApp(
          title: 'App Điểm Danh',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: settings.appColor),
            useMaterial3: true,
            appBarTheme: AppBarTheme(
              backgroundColor: settings.appColor,
              foregroundColor: Colors.white,
            ),
            // Phóng to thu nhỏ cỡ chữ mặc định toàn app
            textTheme: Theme.of(context).textTheme.apply(
              fontSizeFactor: 1.0 + (settings.fontSizeOffset / 10),
            ),
          ),
          home: const LoginScreen(),
        );
      },
    );
  }
}
