import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hackerkernel/screens/home_screen.dart';
import 'package:hackerkernel/screens/login_screen.dart';
import 'package:hackerkernel/wrapper.dart';
import 'package:provider/provider.dart';

import 'authentication_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService(),)
      ],
      child: MaterialApp(
        title: 'Hacker Kernel',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Wrapper(),
          '/login': (context) => LoginScreen()
        },
      ),
    );
  }
}
