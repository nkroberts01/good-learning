import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/session_config_provider.dart';
import 'providers/active_session_provider.dart';
import 'providers/content_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

/// Root widget of the application
/// 
/// Sets up:
/// - Provider state management (makes providers available app-wide)
/// - App theme
/// - Initial screen (HomeScreen)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider wraps your entire app and makes all providers available
    // to any widget in the app tree below it.
    return MultiProvider(
      providers: [
        // SessionConfigProvider: Manages session configuration
        // We initialize it with a default config when the app starts
        ChangeNotifierProvider(
          create: (_) {
            final provider = SessionConfigProvider();
            provider.initializeDefault();
            return provider;
          },
        ),
        // ActiveSessionProvider: Manages running sessions
        ChangeNotifierProvider(create: (_) => ActiveSessionProvider()),
        // ContentProvider: Manages content data (quiz questions, word of day, etc.)
        ChangeNotifierProvider(create: (_) => ContentProvider()),
      ],
      child: MaterialApp(
        title: 'Good Learning',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
