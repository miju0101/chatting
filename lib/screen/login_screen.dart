import 'package:chatting/screen/main_screen.dart';
import 'package:chatting/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await context.read<UserService>().signInWithGoogle();
            if (context.read<UserService>().user() != null) {
              //로그인에 성공하면
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(),
                ),
              );
            }
          },
          child: const Text("구글로 로그인"),
        ),
      ),
    );
  }
}
