import 'package:flutter/material.dart';
import 'package:hackerkernel/screens/home_screen.dart';
import 'package:hackerkernel/screens/login_screen.dart';
import 'package:provider/provider.dart';

import 'authentication_service.dart';
import 'model/user_model.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          return user == null ? LoginScreen() : HomeScreen();
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      }
      );
  }
}
