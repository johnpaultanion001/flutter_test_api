import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo_api/providers/auth.dart';
import 'package:flutter_todo_api/providers/todo.dart';
import 'package:flutter_todo_api/views/loading.dart';
import 'package:flutter_todo_api/views/login.dart';
import 'package:flutter_todo_api/views/register.dart';
import 'package:flutter_todo_api/views/password_reset.dart';
import 'package:flutter_todo_api/views/todos.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (create) => AuthProvider(),
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => const Router(),
          '/login': (context) => LogIn(),
          '/register': (context) => Register(),
          '/password-reset': (context) => PasswordReset(),
        },
      ),
    ),
  );
}

class Router extends StatelessWidget {
  const Router({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Consumer<AuthProvider>(
      builder: (context, user, child) {
        switch (user.status) {
          case Status.Uninitialized:
            return const Loading();
          case Status.Unauthenticated:
            return LogIn();
          case Status.Authenticated:
            return ChangeNotifierProvider(
              create: (context) => TodoProvider(authProvider),
              child: Todos(),
            );
          default:
            return LogIn();
        }
      },
    );
  }
}
