import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:juniper_journal/src/backend/db/supabase_database.dart';
import 'package:juniper_journal/src/frontend/home_page/landing.dart';
import 'package:juniper_journal/src/frontend/home_page/login.dart';
import 'package:juniper_journal/src/frontend/home_page/signup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await SupabaseDatabase.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Juniper Journal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      // Allows for pushNamed
      routes: {
        '/signup': (_) => const SignupScreen(),
        '/login': (_) => const LoginScreen(),
      },
      home: const JuniperAuthScreen(),
    );
  }
}