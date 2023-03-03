import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_todo_api/providers/auth.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  initAuthProvider(context) async {
    Provider.of<AuthProvider>(context, listen: false).initAuthProvider();
  }

  @override
  Widget build(BuildContext context) {
    initAuthProvider(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do App'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
